//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "NSObject.h"

@interface NTDoubleClickHandler : NSObject
{
    id _delegate;
}

+ (id)sharedInstance;
- (void)dealloc;
- (void)setDelegate:(id)arg1;
- (void)handleDoubleClick:(id)arg1 startRect:(struct _NSRect)arg2 window:(id)arg3 treatPackagesAsFolders:(BOOL)arg4;

@end

