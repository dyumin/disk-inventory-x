//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "NSView.h"

@interface NTBoxView : NSView
{
    BOOL _drawsFrame;
    BOOL _shadow;
}

- (id)initWithFrame:(struct _NSRect)arg1;
- (void)dealloc;
- (void)setDrawsFrame:(BOOL)arg1;
- (void)setDrawsFrame:(BOOL)arg1 withShadow:(BOOL)arg2;
- (BOOL)drawsShadow;
- (BOOL)drawsFrame;
- (struct _NSRect)contentBounds;
- (void)drawRect:(struct _NSRect)arg1;

@end

