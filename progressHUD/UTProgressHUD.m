//
//  UTProgressHUD.m
//  MobileUU
//
//  Created by dcj on 15/7/30.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import "UTProgressHUD.h"

@implementation UTProgressHUD

+(UTProgressHUD *)showHUDAddToView:(UIView *)view animated:(BOOL)animated{

    UTProgressHUD * hud = [[UTProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    [hud show:YES];
    return hud;
}

+(UTProgressHUD *)HUDForView:(UIView *)view{

    Class hudClass = [UTProgressHUD class];
    
    for (UIView * tempView in view.subviews) {
        if ([tempView isKindOfClass:hudClass]) {
            return (UTProgressHUD *)tempView;
        }
    }
    return nil;
}

+(BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated{
    
    UTProgressHUD *hud = [UTProgressHUD HUDForView:view];
    if (hud != nil) {
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:animated];
        return YES;
    }
    return NO;
}
+(NSUInteger)hideAllHUDForView:(UIView *)view animated:(BOOL)animated{
    NSArray * huds = [UTProgressHUD allHUDsForView:view];
    for (UTProgressHUD * tempHud in huds) {
        tempHud.removeFromSuperViewOnHide = YES;
        [tempHud hide:animated];
    }
    return huds.count;
}
+ (NSArray *)allHUDsForView:(UIView *)view {
    NSMutableArray *huds = [NSMutableArray array];
    NSArray *subviews = view.subviews;
    Class hudClass = [UTProgressHUD class];
    for (UIView *aView in subviews) {
        if ([aView isKindOfClass:hudClass]) {
            [huds addObject:aView];
        }
    }
    return [NSArray arrayWithArray:huds];
}

@end
