NSInteger newObjsIndex = 0;
id  _Nonnull __unsafe_unretained newObjects[cnt];
for (int i = 0; i < cnt; i++) {
    
    id objc = objects[i];
    if (objc == nil) {
        NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : Array constructor appear nil ",
                            [self class], XXSEL2Str(@selector(arrayWithObjects:count:))];
        
        [XXRecord recordFatalWithReason:reason errorType:EXXShieldTypeContainer];
        continue;
    }
    newObjects[newObjsIndex++] = objc;
    
}
return XXHookOrgin(newObjects, newObjsIndex);
