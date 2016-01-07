//
//  ZQSideViewController.m
//  ZQCustomNavigationDemo1
//
//  Created by zq on 15/12/31.
//  Copyright © 2015年 zhangqiang. All rights reserved.
//

#import "ZQSideViewController.h"

#define SIDE_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SIDE_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ZQSideViewController () <UIScrollViewDelegate>
@property (nonatomic, retain) UIScrollView* mScrollView;
@end

@implementation ZQSideViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    self.view.userInteractionEnabled = YES;
    [self setUpView];
}
- (void)setUpView
{
    [self.view addSubview:self.mScrollView];
    [self.mScrollView setContentSize:CGSizeMake(self.leftViewShowWidth + self.rightViewShowWidth + self.mScrollView.frame.size.width, self.mScrollView.frame.size.height)];
    [self.mScrollView setContentOffset:CGPointMake(self.leftViewShowWidth, 0)];
    self.rootViewController.view.frame = CGRectMake(self.leftViewShowWidth, 0, self.rootViewController.view.frame.size.width, self.rootViewController.view.frame.size.height);
    self.rightViewController.view.frame = CGRectMake(self.mScrollView.contentSize.width - self.rightViewController.view.frame.size.width, 0, self.rightViewController.view.frame.size.width, self.rightViewController.view.frame.size.height);

    self.leftViewController.view.layer.anchorPoint = CGPointMake(self.leftViewShowWidth / SIDE_SCREEN_WIDTH, 0.5);
    self.leftViewController.view.center = CGPointMake(self.leftViewShowWidth, self.leftViewController.view.center.y);

    //    self.rightViewController.view.layer.anchorPoint = CGPointMake((SIDE_SCREEN_WIDTH - self.rightViewShowWidth) / SIDE_SCREEN_WIDTH, 0.5);
    //    self.rightViewController.view.center = CGPointMake(SIDE_SCREEN_WIDTH - self.rightViewShowWidth - self.leftViewShowWidth, self.rightViewController.view.center.y);
    //    self.rightViewController.view.layer.anchorPoint = CGPointMake(self.leftViewShowWidth / SIDE_SCREEN_WIDTH, 0.5);
    //    self.rightViewController.view.center = CGPointMake(0, self.rightViewController.view.center.y);
}
#pragma mark------------------.delegate-------------------
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    float tOffsetX = scrollView.contentOffset.x;
    if (tOffsetX >= 0 && tOffsetX <= self.leftViewShowWidth) //左侧
    {
        double offsetX = (double)scrollView.contentOffset.x;
        double angle = offsetX * (M_PI / (self.leftViewShowWidth * 2.0));
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = 1.0 / 500.0;
        transform = CATransform3DRotate(transform, angle, 0.0, 1.0, 0.0);
        self.leftViewController.view.layer.transform = transform;
    }
    if (tOffsetX >= self.leftViewShowWidth && tOffsetX <= (self.leftViewShowWidth + self.rightViewShowWidth)) //右侧
    {
        double offsetX = (double)scrollView.contentOffset.x;
        double angle = (self.rightViewShowWidth - (self.leftViewShowWidth - offsetX)) * (M_PI / (self.rightViewShowWidth * 2.0));
        //        + M_PI_2;

        NSLog(@"======offsetX=%f,==rScaleX=%f", offsetX, angle);
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = 1.0 / 500;
        transform = CATransform3DRotate(transform, angle, 0.0, 1.0, 0.0);
        self.rightViewController.view.layer.transform = transform;
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView
{
}
- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate
{
    [self movePageShouldOffset];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
    [self movePageShouldOffset];
}
#pragma mark------------------OperateMethod-------------------
- (void)movePageShouldOffset
{
    float scrollCOffsetX = self.mScrollView.contentOffset.x;
    float lastOffsetNo = 0;
    float nOffsetNo = 0;
    NSArray* tempArray = @[ @(self.leftViewShowWidth), @(self.rightViewShowWidth), @(self.rootViewController.view.frame.size.width) ];
    for (int i = 0; i < tempArray.count; i++) {
        nOffsetNo += [[tempArray objectAtIndex:i] floatValue];

        if (scrollCOffsetX >= lastOffsetNo && scrollCOffsetX <= nOffsetNo) {
            float midCOffsetX = (lastOffsetNo + nOffsetNo) / 2.0;
            [self.mScrollView setContentOffset:CGPointMake(scrollCOffsetX > midCOffsetX ? nOffsetNo : lastOffsetNo, self.mScrollView.contentOffset.y) animated:YES];
        }
        lastOffsetNo = nOffsetNo;
    }
}
- (void)showLeftViewController:(BOOL)animated
{
    if (self.leftViewController == nil) {
        return;
    }
}
- (void)showRightViewController:(BOOL)animated
{
    if (self.rightViewController == nil) {
        return;
    }
}
- (void)hideSideViewController:(BOOL)animated
{
}

#pragma mark------------------lazy_load-------------------
- (UIScrollView*)mScrollView
{
    if (_mScrollView == nil) {
        _mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SIDE_SCREEN_WIDTH, SIDE_SCREEN_HEIGHT)];
        _mScrollView.delegate = self;
        _mScrollView.pagingEnabled = NO;
        _mScrollView.showsHorizontalScrollIndicator = NO;
        _mScrollView.bounces = NO;
    }
    return _mScrollView;
}
#pragma mark------------------Setter-------------------
- (void)setLeftViewShowWidth:(float)leftViewShowWidth
{
    _leftViewShowWidth = leftViewShowWidth;
    //    self.leftViewController.view.layer.anchorPoint = CGPointMake(_leftViewShowWidth / SIDE_SCREEN_WIDTH, 0);
}
- (void)setRightViewShowWidth:(float)rightViewShowWidth
{
    _rightViewShowWidth = rightViewShowWidth;
}

- (void)setRootViewController:(UIViewController*)rootViewController
{
    if (_rootViewController != rootViewController) {
        if (_rootViewController) {
            [_rootViewController.view removeFromSuperview];
        }
        _rootViewController = rootViewController;
        if (_rootViewController) {
            [self.mScrollView addSubview:_rootViewController.view];
        }
    }
}
- (void)setLeftViewController:(UIViewController*)leftViewController
{
    if (_leftViewController != leftViewController) {
        if (_leftViewController) {
            [_leftViewController.view removeFromSuperview];
        }
        _leftViewController = leftViewController;
        if (_leftViewController) {
            [self.mScrollView addSubview:_leftViewController.view];
        }
    }
}
- (void)setRightViewController:(UIViewController*)rightViewController
{
    if (_rightViewController != rightViewController) {
        if (_rightViewController) {
            [_rightViewController.view removeFromSuperview];
        }
        _rightViewController = rightViewController;
        if (_rightViewController) {
            [self.mScrollView addSubview:_rightViewController.view];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
