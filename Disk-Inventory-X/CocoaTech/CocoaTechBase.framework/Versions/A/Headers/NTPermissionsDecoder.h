//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "NSObject.h"

@interface NTPermissionsDecoder : NSObject
{
    unsigned int _permissions;
}

+ (id)decoder:(unsigned int)arg1;
- (id)initWithPerms:(unsigned int)arg1;
- (unsigned int)perms;
- (BOOL)ownerRead;
- (BOOL)ownerWrite;
- (BOOL)ownerExecute;
- (BOOL)groupRead;
- (BOOL)groupWrite;
- (BOOL)groupExecute;
- (BOOL)otherRead;
- (BOOL)otherWrite;
- (BOOL)otherExecute;
- (void)setOwnerRead:(BOOL)arg1;
- (void)setOwnerWrite:(BOOL)arg1;
- (void)setOwnerExecute:(BOOL)arg1;
- (void)setGroupRead:(BOOL)arg1;
- (void)setGroupWrite:(BOOL)arg1;
- (void)setGroupExecute:(BOOL)arg1;
- (void)setOtherRead:(BOOL)arg1;
- (void)setOtherWrite:(BOOL)arg1;
- (void)setOtherExecute:(BOOL)arg1;

@end

