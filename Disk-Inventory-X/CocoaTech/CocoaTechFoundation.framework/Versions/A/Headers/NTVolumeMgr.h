//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

//#import "NSObject.h"

#import "NTSimpleTimerProtocol-Protocol.h"

@class NSArray, NSLock, NSMutableDictionary, NTFileDesc, NTSimpleTimer, NTThreadWorkerController;

@interface NTVolumeMgr : NSObject <NTSimpleTimerProtocol>
{
    NSLock *_threadLock;
    NSArray *_mountedVolumes;
    NTThreadWorkerController *_volumeThread;
    NSLock *_volumeListIDLock;
    unsigned long long _volumeListID;
    NSLock *_listIsValidLock;
    BOOL _listIsValid;
    BOOL _volumesSetToRebuild;
    BOOL _cancelRebuildAndStartAgain;
    NTSimpleTimer *_scanTimer;
    NTFileDesc *_volumesFolderDesc;
    NSMutableDictionary *_notificationDictionary;
}

+ (id)sharedInstance;
- (id)init;
- (void)dealloc;
- (id)mountedVolumes;
- (id)mountedVolumes:(BOOL)arg1;
- (id)mountedVolumeDescs;
- (id)mountedVolumePaths;
- (id)mountedVolumeForRefNum:(short)arg1;
- (id)volumeWithDisplayName:(id)arg1;
- (id)rootVolumeName;
- (void)rebuildVolumesList;
- (void)doRebuildVolumesList:(id)arg1;
- (void)delegate_simpleTimerNotification:(id)arg1;

@end

