//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "NSObject.h"

@interface NTGridHelper : NSObject
{
}

+ (void)drawItemInRect:(struct _NSRect)arg1 layout:(int)arg2 icon:(id)arg3 text:(id)arg4 textColor:(id)arg5 label:(int)arg6 style:(int)arg7 flip:(BOOL)arg8;
+ (void)drawItemInRect:(struct _NSRect)arg1 layout:(int)arg2 icon:(id)arg3 textGlyphs:(id)arg4 textColor:(id)arg5 label:(int)arg6 style:(int)arg7 flip:(BOOL)arg8;
+ (struct _NSRect)iconRectForLayout:(int)arg1 inRect:(struct _NSRect)arg2;
+ (struct _NSRect)textRectForText:(id)arg1 layout:(int)arg2 inRect:(struct _NSRect)arg3;
+ (void)drawBackground:(struct _NSRect)arg1 color:(id)arg2;
+ (id)textGlyphs:(id)arg1 forText:(id)arg2 layout:(int)arg3 forRect:(struct _NSRect)arg4;

@end

