//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "NSObject.h"

@class NSArray;

@interface NTFilePasteboardSource : NSObject
{
    NSArray *_descs;
}

+ (id)defaultTypes;
+ (id)imageTypes;
+ (id)file:(id)arg1 toPasteboard:(id)arg2 types:(id)arg3;
+ (id)files:(id)arg1 toPasteboard:(id)arg2 types:(id)arg3;
- (id)initWithDescs:(id)arg1;
- (void)dealloc;

@end

