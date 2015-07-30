//
//  UTProgressHUD.h
//  MobileUU
//
//  Created by dcj on 15/7/30.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import "MBProgressHUD.h"

@interface UTProgressHUD : MBProgressHUD

+(UTProgressHUD *)showHUDAddToView:(UIView *)view animated:(BOOL)animated;
+(UTProgressHUD *)HUDForView:(UIView *)view;

+(BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated;
+(NSUInteger)hideAllHUDForView:(UIView *)view animated:(BOOL)animated;

@end
