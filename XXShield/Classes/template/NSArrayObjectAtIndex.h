
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
