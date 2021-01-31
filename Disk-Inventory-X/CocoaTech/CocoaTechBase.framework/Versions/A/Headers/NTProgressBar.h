//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "NSObject.h"

@class NSLock, NSNumber, NSString, NTProgressPanelController;

@interface NTProgressBar : NSObject
{
    NSLock *_threadLock;
    BOOL _isIndeterminate;
    BOOL _needsUpdate;
    BOOL _needsIndeterminateUpdate;
    BOOL _needsTitleUpdate;
    BOOL _needsShowWindow;
    BOOL _stoppedByUser;
    BOOL _stoppable;
    BOOL _finished;
    NSString *_progressMessage;
    NSString *_windowTitle;
    NSString *_infoMessage;
    NSNumber *_progressPercentage;
    NTProgressPanelController *_controller;
}

- (void)dealloc;
- (void)setFinished;
- (void)setStoppedByUser:(BOOL)arg1;
- (void)setIndeterminate:(BOOL)arg1;
- (void)setWindowTitle:(id)arg1;
- (BOOL)stoppable;
- (BOOL)stoppedByUser;
- (void)updateProgress:(id)arg1 message:(id)arg2 info:(id)arg3;

@end

