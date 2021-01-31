//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "NSWindowController.h"

@interface NTWindowController : NSWindowController
{
}

- (void)commonInit;
- (id)initWithWindow:(id)arg1;
- (id)initWithWindowNibName:(id)arg1;
- (id)initWithWindowNibName:(id)arg1 owner:(id)arg2;
- (id)initWithWindowNibPath:(id)arg1 owner:(id)arg2;
- (void)show;
- (void)hide;
- (BOOL)isVisible;
- (void)setFloating:(BOOL)arg1;
- (BOOL)isFloating;
- (void)setHidesOnDeactivate:(BOOL)arg1;
- (BOOL)hidesOnDeactivate;
- (void)setTransparency:(id)arg1;
- (id)transparency;
- (void)floatAction:(id)arg1;
- (void)hidesOnDeactivateAction:(id)arg1;
- (void)transparencyAction:(id)arg1;
- (void)transparencySheetSelector:(id)arg1;
- (BOOL)validateMenuItem:(id)arg1;

@end

