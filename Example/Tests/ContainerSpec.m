//
//  ContainerSpec.m
//  XXShield_Tests
//
//  Created by nero on 2017/11/1.
//  Copyright © 2017年 ValiantCat. All rights reserved.
//

QuickSpecBegin(ContainerSpec)

describe(@"Container test", ^{
    context(@"NSCache test", ^{
        it(@"should avoid crash by insert nil value  to NSCache", ^{
            NSCache *cache = [[NSCache alloc] init];
            id stub = nil;
            [cache setObject:@"val" forKey:@"key"]; //
            [cache setObject:stub forKey:@"key"];
            
            expect([cache objectForKey:@"key"]).to(equal(@"val"));
            
            [cache setObject:@"value" forKey:@"anotherKey" cost:10];
            [cache setObject:stub forKey:@"anotherKey" cost:10];
            expect([cache objectForKey:@"anotherKey"]).to(equal(@"value"));
        });
    });
    
    context(@"NSArray(Private SubClass) test", ^{
        it(@"should avoid crash by using subscribe method objectAtIndex while index out of bounds.", ^{
            NSArray *arr = @[];
            NSString *clazzName = [[NSString alloc] initWithUTF8String:object_getClassName(arr)];
            expect(clazzName).to(equal(@"__NSArray0"));
            expect(arr[10]).to(beNil());
            
            arr = @[@1];
            clazzName = [[NSString alloc] initWithUTF8String:object_getClassName(arr)];
            expect(clazzName).to(equal(@"__NSSingleObjectArrayI"));
            expect(arr[10]).to(beNil());
            
            arr = @[@1, @2];
            clazzName = [[NSString alloc] initWithUTF8String:object_getClassName(arr)];
            expect(clazzName).to(equal(@"__NSArrayI"));
            expect(arr[10]).to(beNil());
        });
        
        it(@"should avoid crash by using convience constructor arrayWithObjects:count: while object appear nil.", ^{
            const id os[] = { @"1",nil};
            NSArray *arr = [NSArray arrayWithObjects:os count:2];
            expect(arr).to(equal(@[@"1"]));
        });
    });
    
    context(@"NSDictionary test", ^{
        it(@"should avoid crash by using convience constructor dictionaryWithObjects:forKeys:count: while object or key appear nil.", ^{
            NSString *nilValue = nil;
            NSDictionary *dict = @{
                                   @"name" : @"zs",
                                   @"age" : nilValue,
                                   nilValue : @""
                                   };
            
            expect(dict).to(equal(@{@"name" : @"zs"}));
        });
    });
    
    context(@"NSMutableArray(Private SubClass) test", ^{
        it(@"should avoid crash by using addObject: while object appear nil.", ^{
            NSMutableArray *arr = @[].mutableCopy;
            NSString *clazzName = [[NSString alloc] initWithUTF8String:object_getClassName(arr)];
            expect(clazzName).to(equal(@"__NSArrayM"));
            id nilValue = nil;
            [arr addObject:@1];
            [arr addObject:nilValue];
            [arr addObject:@3];
            expect(arr).to(equal(@[@1, @3]));
        });
        
        it(@"should avoid crash by using objectAtIndex: while index out of bounds.", ^{
            NSMutableArray *arr = @[].mutableCopy;
            NSString *clazzName = [[NSString alloc] initWithUTF8String:object_getClassName(arr)];
            expect(clazzName).to(equal(@"__NSArrayM"));
            [arr addObject:@1];
            [arr addObject:@3];
            expect(arr[100]).to(beNil());
        });
        
        it(@"should avoid crash by using removeObjectAtIndex: while index out of bounds.", ^{
            NSMutableArray *arr = @[].mutableCopy;
            NSString *clazzName = [[NSString alloc] initWithUTF8String:object_getClassName(arr)];
            expect(clazzName).to(equal(@"__NSArrayM"));
            [arr addObject:@1];
            [arr addObject:@3];
            [arr removeObjectAtIndex:2];
            expect(arr).to(equal(@[@1, @3]));
        });
        
        it(@"should avoid crash by using insertObject:atIndex: while object appear nil.", ^{
            NSMutableArray *arr = @[].mutableCopy;
            NSString *clazzName = [[NSString alloc] initWithUTF8String:object_getClassName(arr)];
            expect(clazzName).to(equal(@"__NSArrayM"));
            [arr addObject:@1];
            [arr addObject:@3];
            id nilValue = nil;
            [arr insertObject:nilValue atIndex:10];
            expect(arr).to(equal(@[@1, @3]));
        });
        it(@"should avoid crash by using setObject:atIndexedSubscript: while object appear nil or idx out of bounds.", ^{
            NSMutableArray *arr = @[].mutableCopy;
            NSString *clazzName = [[NSString alloc] initWithUTF8String:object_getClassName(arr)];
            expect(clazzName).to(equal(@"__NSArrayM"));
            [arr addObject:@1];
            [arr addObject:@3];
            
            id nilValue = nil;
            [arr setObject:nilValue atIndexedSubscript:1];
            expect(arr).to(equal(@[@1, @3]));
            arr[1] = nilValue;
            expect(arr).to(equal(@[@1, @3]));
            
            [arr setObject:@"xx" atIndexedSubscript:100];
            expect(arr).to(equal(@[@1, @3]));
            arr[100] = @"xx";
            expect(arr).to(equal(@[@1, @3]));
        });
    });
    
    context(@"NSMutableDictionary(Private SubClass) test", ^{
        it(@"should avoid crash by using setObject:forKey: while object or key appear nil.", ^{
            NSMutableDictionary *dict = @{
                                          @"name" : @"zs"
                                          }.mutableCopy;
            NSString *clazzName = [[NSString alloc] initWithUTF8String:object_getClassName(dict)];
            expect(clazzName).to(equal(@"__NSDictionaryM"));
            
            id nilValue = nil;
            [dict setObject:nilValue forKey:@"xx"];
            expect(dict).to(equal(@{ @"name" : @"zs"}));
            dict[@"xx"] = nilValue;
            expect(dict).to(equal(@{ @"name" : @"zs"}));
            
            [dict setObject:@"xx" forKey:nilValue];
            expect(dict).to(equal(@{ @"name" : @"zs"}));
            dict[nilValue] = @"xx";
            expect(dict).to(equal(@{ @"name" : @"zs"}));
        });
    });

});

QuickSpecEnd
