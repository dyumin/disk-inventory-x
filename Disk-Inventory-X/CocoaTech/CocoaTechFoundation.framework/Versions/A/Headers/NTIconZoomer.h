//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "NSObject.h"

@class NTIconZoomerWindow;

@interface NTIconZoomer : NSObject
{
    NTIconZoomerWindow *_window;
    BOOL _inUse;
}

+ (id)sharedInstance;
+ (void)zoomIcon:(id)arg1 atPoint:(struct _NSPoint)arg2;
- (id)init;
- (void)zoomIcon:(id)arg1 atPoint:(struct _NSPoint)arg2;

@end

