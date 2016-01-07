//
//  ZQSideViewController.h
//  ZQCustomNavigationDemo1
//
//  Created by zq on 15/12/31.
//  Copyright © 2015年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQSideViewController : UIViewController

@property (nonatomic, retain) UIViewController* leftViewController NS_AVAILABLE_IOS(5_0);
@property (nonatomic, retain) UIViewController* rightViewController NS_AVAILABLE_IOS(5_0);
@property (nonatomic, retain) UIViewController* rootViewController NS_AVAILABLE_IOS(5_0);

@property (nonatomic, assign) float leftViewShowWidth; //左侧栏的展示大小
@property (nonatomic, assign) float rightViewShowWidth; //右侧栏的展示大小

- (void)showLeftViewController:(BOOL)animated;
- (void)showRightViewController:(BOOL)animated;
- (void)hideSideViewController:(BOOL)animated;

@end
