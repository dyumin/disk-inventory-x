//
//  NTLocalizedString.h
//  Disk Inventory X
//
//  Created by El D on 01.02.2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NTLocalizedString : NSObject
{
}

+ (id)localize:(id)arg1;
+ (id)localize:(id)arg1 table:(id)arg2;
+ (void)localizeWindow:(id)arg1;
+ (void)localizeWindow:(id)arg1 table:(id)arg2;
+ (void)localizeView:(id)arg1;
+ (void)localizeView:(id)arg1 table:(id)arg2;

@end

NS_ASSUME_NONNULL_END
