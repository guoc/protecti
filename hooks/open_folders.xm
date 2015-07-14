%hook SBIconController

- (void)openFolder:(SBFolder *)arg1 animated:(BOOL)arg2 {
    if (GetValueOf_DisabledFolders && global_Enable)
    {
        NSArray *folders = [GetValueOf_DisabledFolders componentsSeparatedByString:@";"];
        if ([folders containsObject:[arg1 displayName]])
        {
            return;
        }
        else
        {
            return %orig;
        }
    }
    else
    {
        return %orig;
    }
}

%end
