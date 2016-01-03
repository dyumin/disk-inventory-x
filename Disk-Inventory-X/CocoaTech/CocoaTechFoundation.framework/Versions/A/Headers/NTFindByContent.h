//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "NSObject.h"

#import "NTFindControllerProtocol.h"

@class NSLock, NSMutableArray, NTFindByContentThread;

@interface NTFindByContent : NSObject <NTFindControllerProtocol>
{
    NSObject *_delegate;
    NTFindByContentThread *_thread;
    NSLock *_stoppedLock;
    BOOL _stopped;
    NSLock *_resultsLock;
    NSMutableArray *_results;
}

- (id)initWithDelegate:(id)arg1;
- (void)dealloc;
- (void)find:(id)arg1 content:(id)arg2;
- (void)stopFind;
- (id)results:(char *)arg1;

@end

