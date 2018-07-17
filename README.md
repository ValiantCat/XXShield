
[![CI Status](http://img.shields.io/travis/ValiantCat/XXShield.svg?style=flat)](https://travis-ci.org/ValiantCat/XXShield) [![Version](https://img.shields.io/cocoapods/v/XXShield.svg?style=flat)](http://cocoapods.org/pods/XXShield) [![License](https://img.shields.io/cocoapods/l/XXShield.svg?style=flat)](http://cocoapods.org/pods/XXShield) [![Platform](https://img.shields.io/cocoapods/p/XXShield.svg?style=flat)](http://cocoapods.org/pods/XXShield)


<!--markdown-->
<!-- toc -->


# 前言 

正在运行的 APP 突然 Crash，是一件令人不爽的事，会流失用户，影响公司发展，所以 APP 运行时拥有防 Crash 功能能有效降低 Crash 率，提升 APP 稳定性。但是有时候 APP Crash 是应有的表现，我们不让 APPCrash 可能会导致别的逻辑错误，不过我们可以抓取到应用当前的堆栈信息并上传至相关的服务器，分析并修复这些 BUG。

所以本文介绍的 XXShield 库有两个重要的功能:

1. 防止Crash
2. 捕获异常状态下的崩溃信息

类似的相关技术分析也有 [网易iOS App运行时Crash自动防护实践](https://mp.weixin.qq.com/s?__biz=MzA3ODg4MDk0Ng==&mid=2651113088&idx=1&sn=10b28d7fbcdf0def1a47113e5505728d&chksm=844c6f5db33be64b57fc9b4013cdbb7122d7791f3bbca9b4b29e80cce295eb341b03a9fc0f2f&mpshare=1&scene=23&srcid=0207njmGS2HWHI0BZmpjNKhv%23rd)


# 目前已经实现的功能

1. Unrecognized Selector Crash
2. KVO Crash
3. Container Crash
4. NSNotification Crash
5. NSNull Crash
6. NSTimer Crash 
7. 野指针 Crash 


----

# 1 Unrecoginzed Selector Crash


## 出现原因

由于 Objective-C 是动态语言，所有的消息发送都会放在运行时去解析，有时候我们把一个信息传递给了错误的类型，就会导致这个错误。

##  解决办法

Objective-C 在出现无法解析的方法时有三部曲来进行消息转发。
详见[Objective-C Runtime 运行时之三：方法与消息](https://southpeak.github.io/2014/11/03/objective-c-runtime-3/)

1. 动态方法解析
2. 备用接收者
3. 完整转发

1 一般适用与 Dynamic 修饰的 Property
2 一般适用与将方法转发至其他对象
3 一般适用与消息可以转发多个对象，可以实现类似多继承或者转发中心的概念。

这里选择的是方案二，因为三里面用到了 NSInvocation 对象，此对象性能开销较大，而且这种异常如果出现必然频次较高。最适合将消息转发到一个备用者对象上。

这里新建一个智能转发类。此对象将在其他对象无法解析数据时，返回一个 0 来防止 Crash。返回 0 是因为这个通用的智能转发类做的操作接近向 nil 发送一个消息。

代码如下

```Objc

#import <objc/runtime.h>

/**
 default Implement
 @param target trarget
 @param cmd cmd
 @param ... other param
 @return default Implement is zero
 */
int smartFunction(id target, SEL cmd, ...) {
    return 0;
}

static BOOL __addMethod(Class clazz, SEL sel) {
    NSString *selName = NSStringFromSelector(sel);
    
    NSMutableString *tmpString = [[NSMutableString alloc] initWithFormat:@"%@", selName];
    
    int count = (int)[tmpString replaceOccurrencesOfString:@":"
                                                withString:@"_"
                                                   options:NSCaseInsensitiveSearch
                                                     range:NSMakeRange(0, selName.length)];
    
    NSMutableString *val = [[NSMutableString alloc] initWithString:@"i@:"];
    
    for (int i = 0; i < count; i++) {
        [val appendString:@"@"];
    }
    const char *funcTypeEncoding = [val UTF8String];
    return class_addMethod(clazz, sel, (IMP)smartFunction, funcTypeEncoding);
}

@implementation XXShieldStubObject

+ (XXShieldStubObject *)shareInstance {
    static XXShieldStubObject *singleton;
    if (!singleton) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            singleton = [XXShieldStubObject new];
        });
    }
    return singleton;
}

- (BOOL)addFunc:(SEL)sel {
    return __addMethod([XXShieldStubObject class], sel);
}

+ (BOOL)addClassFunc:(SEL)sel {
    Class metaClass = objc_getMetaClass(class_getName([XXShieldStubObject class]));
    return __addMethod(metaClass, sel);
}

@end

```

我们这里需要 Hook NSObject的 `- (id)forwardingTargetForSelector:(SEL)aSelector` 方法启动消息转发。
很多人不知道的是如果想要转发类方法，只需要实现一个同名的类方法即可，虽然在头文件中此方法并未声明。

```Objc

XXStaticHookClass(NSObject, ProtectFW, id, @selector(forwardingTargetForSelector:), (SEL)aSelector) {
    // 1 如果是NSSNumber 和NSString没找到就是类型不对  切换下类型就好了
    if ([self isKindOfClass:[NSNumber class]] && [NSString instancesRespondToSelector:aSelector]) {
        NSNumber *number = (NSNumber *)self;
        NSString *str = [number stringValue];
        return str;
    } else if ([self isKindOfClass:[NSString class]] && [NSNumber instancesRespondToSelector:aSelector]) {
        NSString *str = (NSString *)self;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        NSNumber *number = [formatter numberFromString:str];
        return number;
    }
    
    BOOL aBool = [self respondsToSelector:aSelector];
    NSMethodSignature *signatrue = [self methodSignatureForSelector:aSelector];
    
    if (aBool || signatrue) {
        return XXHookOrgin(aSelector);
    } else {
        XXShieldStubObject *stub = [XXShieldStubObject shareInstance];
        [stub addFunc:aSelector];
        
        NSString *reason = [NSString stringWithFormat:@"*****Warning***** logic error.target is %@ method is %@, reason : method forword to SmartFunction Object default implement like send message to nil.",
                            [self class], NSStringFromSelector(aSelector)];
        [XXRecord recordFatalWithReason:reason errorType:EXXShieldTypeUnrecognizedSelector];
        
        return stub;
    }
}
XXStaticHookEnd

```

这里汇报了 Crash 信息，出现消息转发一般是一个 logic 错误，为必须修复的Bug，上报尤为重要。

----

# 2 KVO Crash

## 出现原因

KVOCrash总结下来有以下2大类。

 1. 不匹配的移除和添加关系。
 2. 观察者和被观察者释放的时候没有及时断开观察者关系。

 
## 解决办法

> 尼古拉斯赵四说过 :![赵四](https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1487130185&di=41675c8578b69177ee9172e488c803f7&imgtype=jpg&er=1&src=http%3A%2F%2Fimgsrc.baidu.com%2Fforum%2Fw%3D580%2Fsign%3Dd1ac5ff09e25bc312b5d01906edf8de7%2Fcedafc039245d6882866389aa3c27d1ed21b244b.jpg)
> 对比到程序世界就是，程序世界没有什么难以解决的问题都是不可以通过抽象层次来解决的，如果有，那就两层。
> 纵观程序的架构设计，计算机网络协议分层设计，操作系统内核设计等等都是如此。

问题1 ： 不成对的添加观察者和移除观察者会导致 Crash，以往我们使用 KVO，观察者和被观察者都是直接交互的。这里的设计方案是我们找一个 Proxy 用来做转发， 真正的观察者是 Proxy，被观察者出现了通知信息，由 Proxy 做分发。所以 Proxy 里面要保存一个数据结构 {keypath : [observer1, observer2,...]} 。


```Objc

@interface XXKVOProxy : NSObject {
    __unsafe_unretained NSObject *_observed;
}

/**
 {keypath : [ob1,ob2](NSHashTable)}
 */
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSHashTable<NSObject *> *> *kvoInfoMap;

@end

```

我们需要 Hook NSObject的 KVO 相关方法。

```Objc

- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;

- (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;

```

1. 在添加观察者时
![addObserver](http://ompeszjl2.bkt.clouddn.com/iOS-APP-%E8%BF%90%E8%A1%8C%E6%97%B6%E9%98%B2Crash%E5%B7%A5%E5%85%B7XXShield%E7%BB%83%E5%B0%B1//KVO-Add.png)


2. 在移除观察者时

![removeObserver](http://ompeszjl2.bkt.clouddn.com/iOS-APP-%E8%BF%90%E8%A1%8C%E6%97%B6%E9%98%B2Crash%E5%B7%A5%E5%85%B7XXShield%E7%BB%83%E5%B0%B1/KVO-Remove.png)


问题2: 观察者和被观察者释放的时候没有断开观察者关系。
对于观察者， 既然我们是自己用 Proxy 做的分发，我们自己就需要保存观察者，这里我们简单的使用 `NSHashTable` 指定指针持有策略为 `weak` 即可。

对于被观察者，我们使用 [iOS 界的毒瘤-MethodSwizzling](https://www.valiantcat.cn/index.php/2017/11/03/53.html)
一文中到的方法。我们在被观察者上绑定一个关联对象，在关联对象的 dealloc 方法中做相关操作即可。

```Objc

- (void)dealloc {
    @autoreleasepool {
        NSDictionary<NSString *, NSHashTable<NSObject *> *> *kvoinfos =  self.kvoInfoMap.copy;
        for (NSString *keyPath in kvoinfos) {
            // call original  IMP
            __xx_hook_orgin_function_removeObserver(_observed,@selector(removeObserver:forKeyPath:),self, keyPath);
        }
    }
}

```

 ----

# 3 Container Crash


## 出现原因

容器在任何编程语言中都尤为重要，容器是数据的载体，很多容器对容器放空值都做了容错处理。不幸的是 Objective-C 并没有，容器插入了 `nil` 就会导致 Crash，容器还有另外一个最容易 Crash 的原因就是下标越界。

## 解决办法

常见的容器有 NS(Mutable)Array , NS(Mutable)Dictionary, NSCache 等。我们需要 hook 常见的方法加入检测功能并且捕获堆栈信息上报。

例如

```Objc

XXStaticHookClass(NSArray, ProtectCont, id, @selector(objectAtIndex:),(NSUInteger)index) {
if (self.count == 0) {
    
    NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : index %@ out of count %@ of array ",
                        [self class], XXSEL2Str(@selector(objectAtIndex:)), @(index), @(self.count)];
    [XXRecord recordFatalWithReason:reason errorType:EXXShieldTypeContainer];
    return nil;
}

if (index >= self.count) {
    NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : index %@ out of count %@ of array ",
                        [self class], XXSEL2Str(@selector(objectAtIndex:)), @(index), @(self.count)];
    [XXRecord recordFatalWithReason:reason errorType:EXXShieldTypeContainer];
    return nil;
}

return XXHookOrgin(index);
}
XXStaticHookEnd

```

但是需要注意的是 NSArray 是一个 Class Cluster 的抽象父类，所以我们需要 Hook 到我们真正的子类。

这里给出一个辅助方法，获取一个类的所有直接子类：

```Objc
+ (NSArray *)findAllOf:(Class)defaultClass {
    
    int count = objc_getClassList(NULL, 0);
    
    if (count <= 0) {
        
        @throw@"Couldn't retrieve Obj-C class-list";
        
        return @[defaultClass];
    }
    
    NSMutableArray *output = @[].mutableCopy;
    
    Class *classes = (Class *) malloc(sizeof(Class) * count);
    
    objc_getClassList(classes, count);
    
    for (int i = 0; i < count; ++i) {
        
        if (defaultClass == class_getSuperclass(classes[i]))//子类
        {
            [output addObject:classes[i]];
        }
        
    }
    
    free(classes);
    
    return output.copy;
    
}

// 对于NSarray ：

//[NSarray array] 和 @[] 的类型是__NSArray0
//只有一个元素的数组类型 __NSSingleObjectArrayI,
// 其他的大部分是//__NSArrayI,



// 对于NSMutableArray ：
//[NSMutableDictionary dictionary] 和 @[].mutableCopy__NSArrayM



// 对于NSDictionary: :

//[NSDictionary dictionary];。 @{}; __NSDictionary0
// 其他一般是  __NSDictionaryI

// 对于NSMutableDictionary: :
// 一般用到的是 __NSDictionaryM
```


---- 


# 4 NSNotification Crash

## 出现原因

在 iOS8 及以下的操作系统中添加的观察者一般需要在 dealloc 的时候做移除，如果开发者忘记移除，则在发送通知的时候会导致 Crash，而在 iOS9 上即使移忘记除也无所谓，猜想可能是 iOS9 之后系统将通知中心持有对象由 `assign` 变为了`weak`。


## 解决办法

所以这里两种解决办法 

1. 类似 KVO 中间加上 Proxy 层，使用 weak 指针来持有对象
2. 在 dealloc 的时候将未被移除的观察者移除

这里我们使用 [iOS 界的毒瘤-MethodSwizzling](https://www.valiantcat.cn/index.php/2017/11/03/53.html)
一文中到的方法。


- - - - -

# 5 NSNull Crash

## 出现原因

虽然 Objecttive-C 不允许开发者将 nil 放进容器内，但是另外一个代表用户态 `空` 的类 NSNull 却可以放进容器，但令人不爽的是这个类的实例，并不能响应任何方法。 

容器中出现 NSNull 一般是 API 接口返回了含有 null 的 JSON 数据，
调用方通常将其理解为 NSNumber，NSString，NSDictionary 和 NSArray。 这时开发者如果没有做好防御 一旦对 NSNull 这个类型调用任何方法都会出现 unrecongized selector 错误。 



## 解决办法

我们在 NSNull 的转发方法中可以判断上面的四种类型是否可以解析。如果可以解析直接将其转发给这几种对象，如果不能则调用父类的默认实现。


```Objc

XXStaticHookClass(NSNull, ProtectNull, id, @selector(forwardingTargetForSelector:), (SEL) aSelector) {
    static NSArray *sTmpOutput = nil;
    if (sTmpOutput == nil) {
        sTmpOutput = @[@"", @0, @[], @{}];
    }
    
    for (id tmpObj in sTmpOutput) {
        if ([tmpObj respondsToSelector:aSelector]) {
            return tmpObj;
        }
    }
    return XXHookOrgin(aSelector);
}
XXStaticHookEnd

```
#  6. NSTimer Crash 


## 出现原因

在使用 `+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo` 创建定时任务的时候，target 一般都会持有 timer，timer又会持有 target 对象，在我们没有正确关闭定时器的时候，timer 会一直持有target 导致内存泄漏。

## 解决办法

同 KVO 一样，既然 timer 和 target 直接交互容易出现问题，我们就再找个代理将 target 和 selctor 等信息保存到 Proxy 里，并且是弱引用 target。  
这样避免因为循环引用造成的内存泄漏。然后在触发真正 target 事件的时候如果 target 置为 nil 了这时候手动去关闭定时器。

```Objc

XXStaticHookMetaClass(NSTimer, ProtectTimer,  NSTimer * ,@selector(scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:),
                      (NSTimeInterval)ti , (id)aTarget, (SEL)aSelector, (id)userInfo, (BOOL)yesOrNo ) {
    if (yesOrNo) {
        NSTimer *timer =  nil ;
        @autoreleasepool {
            XXTimerProxy *proxy = [XXTimerProxy new];
            proxy.target = aTarget;
            proxy.aSelector = aSelector;
            timer.timerProxy = proxy;
            timer = XXHookOrgin(ti, proxy, @selector(trigger:), userInfo, yesOrNo);
            proxy.sourceTimer = timer;
        }
        return  timer;
    }
    return XXHookOrgin(ti, aTarget, aSelector, userInfo, yesOrNo);
}
XXStaticHookEnd
@implementation XXTimerProxy

- (void)trigger:(id)userinfo  {
    id strongTarget = self.target;
    if (strongTarget && ([strongTarget respondsToSelector:self.aSelector])) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [strongTarget performSelector:self.aSelector withObject:userinfo];
#pragma clang diagnostic pop
    } else {
        NSTimer *sourceTimer = self.sourceTimer;
        if (sourceTimer) {
            [sourceTimer invalidate];
        }
        NSString *reason = [NSString stringWithFormat:@"*****Warning***** logic error target is %@ method is %@, reason : an object dealloc not invalidate Timer.",
                            [self class], NSStringFromSelector(self.aSelector)];
        
        [XXRecord recordFatalWithReason:reason errorType:(EXXShieldTypeTimer)];
    }
}

@end

```

# 7. 野指针 Crash 

## 出现原因

一般在单线程条件下使用 ARC 正确的处理引用关系野指针出现的并不频繁， 但是多线程下则不尽然，通常在一个线程中释放了对象，另外一个线程还没有更新指针状态 后续访问就可能会造成随机性 bug。

之所以是随机 bug 是因为被回收的内存不一定立马被使用。而且崩溃的位置可能也与原来的逻辑相聚很远，因此收集的堆栈信息也可能是杂乱无章没有什么价值。
具体的分类请看Bugly整理的脑图。
![x](http://upload-images.jianshu.io/upload_images/783864-9fa6e25efbe248e8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

更多关于野指针的文章请参考:

1. [如何定位Obj-C野指针随机Crash(一)](https://dev.qq.com/topic/59141e56ca95d00d727ba750)
1. [如何定位Obj-C野指针随机Crash(二)](https://dev.qq.com/topic/59142d61ca95d00d727ba752)
1. [如何定位Obj-C野指针随机Crash(三)](https://dev.qq.com/topic/5915134b75d11c055ca7fca0)

## 解决办法

这里我们可以借用系统的NSZombies对象的设计。
参考[buildNSZombie](https://mikeash.com/pyblog/friday-qa-2014-11-07-lets-build-nszombie.html)


解决过程

1. 建立白名单机制，由于系统的类基本不会出现野指针，而且 hook 所有的类开销较大。所以我们只过滤开发者自定义的类。
2. hook dealloc 方法 这些需要保护的类我们并不让其释放，而是调用objc_desctructInstance 方法释放实例内部所持有属性的引用和关联对象。
3. 利用 object_setClass(id，Class) 修改 isa 指针将其指向一个Proxy 对象(类比系统的 KVO 实现)，此 Proxy 实现了一个和前面所说的智能转发类一样的 `return 0`的函数。
4. 在 Proxy 对象内的 `- (void)forwardInvocation:(NSInvocation *)anInvocation` 中收集 Crash 信息。

5. 缓存的对象是有成本的，我们在缓存对象到达一定数量时候将其释放(object_dispose)。

## 存在问题

1. 延迟释放内存会造成性能浪费，所以默认缓存会造成野指针的Class实例的对象限制是50，超出之后会释放，如果这时候再此触发了刚好释放掉的野指针，还是会造成Crash的，

2. 建议使用的时候如果近期没有野指针的Crash可以不必开启，如果野指针类型的Crash突然增多，可以考虑在 hot Patch 中开启野指针防护，待收取异常信息之后，再关闭此开关。

- - - - 

# 收集信息

由于希望此库没有任何外部依赖，所以并未实现响应的上报逻辑。使用者如果需要上报信息 只需要自行实现 `XXRecordProtocol` 即可，然后在开启 SDK 之前将其注册进入 SDK。
在实现方法里面会接收到 XXShield 内部定义的错误信息。
开发者无论可以使用诸如 CrashLytics，友盟， bugly等第三库，或者自行 dump堆栈信息都可。

```objc
@protocol XXRecordProtocol <NSObject>

- (void)recordWithReason:(NSError * )reason userInfo:(NSDictionary *)userInfo;

@end
```




# 使用方法

## 示例工程

```sh

git clone git@github.com:ValiantCat/XXShield.git
cd Example
pod install 
open XXShield.xcworkspace

```


## Install 

```ruby
    
  pod "XXShield"
    
```

##  Usage

```Objc

/**
 注册汇报中心
 
 @param record 汇报中心
 */
+ (void)registerRecordHandler:(id<XXRecordProtocol>)record;

/**
 注册SDK，默认只要开启就打开防Crash，如果需要DEBUG关闭，请在调用处使用条件编译
 本注册方式不包含EXXShieldTypeDangLingPointer类型
 */
+ (void)registerStabilitySDK;

/**
 本注册方式不包含EXXShieldTypeDangLingPointer类型
 
 @param ability ability
 */
+ (void)registerStabilityWithAbility:(EXXShieldType)ability;

/**
 ///注册EXXShieldTypeDangLingPointer需要传入存储类名的array，暂时请不要传入系统框架类
 
 @param ability ability description
 @param classNames 野指针类列表
 */
+ (void)registerStabilityWithAbility:(EXXShieldType)ability withClassNames:(nonnull NSArray<NSString *> *)classNames;


```

## ChangeLog

[ChangeLog](https://github.com/ValiantCat/XXShield/blob/develop/Changelog.md)

## 单元测试

相关的单元测试在示例工程的Test Target下，有兴趣的开发者可以自行查看。并且已经接入 [TrivisCI](https://travis-ci.org/ValiantCat/XXShield)保证了代码质量。

## Bug&Feature

如果有相关的 Bug 请提 [Issue](https://github.com/ValiantCat/XXShield/issues)。

如果觉得可以扩充新的防护类型，请提 [PR](https://github.com/ValiantCat/XXShield/pulls) 给我。

## 作者

ValiantCat, 519224747@qq.com

[个人博客](https://www.valiantcat.cn/index.php/2017/11/03/53.html)

[南栀倾寒的简书](http://www.jianshu.com/u/cc1e4faec5f7)



# License

XXShield 使用 Apache-2.0 开源协议.

