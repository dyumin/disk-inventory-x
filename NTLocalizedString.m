//
//  NTLocalizedString.m
//  Disk Inventory X
//
//  Created by El D on 01.02.2021.
//

#import "NTLocalizedString.h"

@implementation NTLocalizedString

+ (id)localize:(id)arg1
{
    return [NSString stringWithFormat:@"localize: %@", arg1];
}

+ (id)localize:(id)arg1 table:(id)arg2
{
    return [NSString stringWithFormat:@"localize:table: %@", arg1];
}

+ (void)localizeWindow:(id)arg1
{
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, arg1);
}

+ (void)localizeWindow:(id)arg1 table:(id)arg2
{
    NSLog(@"%s: window: %@ table: %@", __PRETTY_FUNCTION__, arg1, arg2);
}

+ (void)localizeView:(id)arg1
{
    NSLog(@"%s: view: %@", __PRETTY_FUNCTION__, arg1);
}

+ (void)localizeView:(id)arg1 table:(id)arg2
{
    NSLog(@"%s: view: %@ table: %@", __PRETTY_FUNCTION__, arg1, arg2);
}


@end
