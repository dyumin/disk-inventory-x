//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "NSMutableDictionary.h"

@interface NSMutableDictionary (ThreadSafety)
- (id)threadSafeObjectForKey:(id)arg1 usingLock:(id)arg2;
- (void)threadSafeRemoveObjectForKey:(id)arg1 usingLock:(id)arg2;
- (void)threadSafeSetObject:(id)arg1 forKey:(id)arg2 usingLock:(id)arg3;
@end

