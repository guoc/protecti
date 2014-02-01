%hook UIImagePickerController
- (unsigned int )sourceType {
    %log; unsigned int  r = %orig; NSLog(@" = %u", r);
    if (YES)
        return 1;
    return r;
}
- (void)setSourceType:(unsigned int )sourceType {
    %log;
    if (YES)
        %orig(1);
        else
            %orig(sourceType);
            }
%end
