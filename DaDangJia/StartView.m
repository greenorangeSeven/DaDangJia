//
//  StartView.m
//  JinChang
//
//  Created by Seven on 15/8/28.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "StartView.h"
#import "AppDelegate.h"
#import "LoginView.h"
#import "MainFrameView.h"
#import "LeftView.h"

@interface StartView ()
{
    UIImageView *_imageView;
    NSArray *_permissions;
    int GlobalPageControlNumber;
    
}

@property (strong,nonatomic) YRSideViewController *sideViewController;

@end

@implementation StartView

#define KSCROLLVIEW_WIDTH [UIScreen mainScreen].applicationFrame.size.width
#define KSCROLLVIEW_HEIGHT [UIScreen mainScreen].applicationFrame.size.height

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    //    self.navigationController.navigationBarHidden = YES;
    self.intoButton.hidden = YES;
    [self buildUI];
    [self createScrollView];
}

#pragma mark - privite method
#pragma mark
- (void)buildUI
{
//    if (!IS_IPHONE_5) {
//        _pageControl.frame = CGRectMake(_pageControl.frame.origin.x, _pageControl.frame.origin.y-88, _pageControl.frame.size.width, _pageControl.frame.size.height);
//    }
    _pageControl.numberOfPages = 4;
    _pageControl.currentPage = 0;
    _pageControl.enabled = NO;
}
#pragma mark createScrollView
-(void)createScrollView
{
    self.scrollView.contentSize=CGSizeMake(KSCROLLVIEW_WIDTH*4, KSCROLLVIEW_HEIGHT);
    self.scrollView.delegate=self;
    for (int i=0; i<4; i++)
    {
        UIImageView *photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*KSCROLLVIEW_WIDTH, 0, KSCROLLVIEW_WIDTH, KSCROLLVIEW_HEIGHT+20)];
        NSLog(@"the x:%f, y:%f  the width:%f, height:%f",i*KSCROLLVIEW_WIDTH,60.0f,KSCROLLVIEW_WIDTH,KSCROLLVIEW_HEIGHT);
        //        CGRect frame = photoImageView.frame;
        [photoImageView setBackgroundColor:[UIColor blackColor]];
        NSString *str = @"";
        if (IS_IPHONE_5)
        {
            str = [NSString stringWithFormat:@"v引导_%d",i+1];
        }
        else
        {
            str = [NSString stringWithFormat:@"v引导480_%d",i+1];
        }
        photoImageView.image = [UIImage imageNamed:str];
        [photoImageView setContentMode:UIViewContentModeScaleToFill];
        [self.scrollView addSubview:photoImageView];
    }
}

#pragma mark - scrollView delegate Method
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x <= 0) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    if (scrollView.contentOffset.x >= KSCROLLVIEW_WIDTH*5) {
        scrollView.contentOffset = CGPointMake(KSCROLLVIEW_WIDTH*5, 0);
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    GlobalPageControlNumber = scrollView.contentOffset.x/KSCROLLVIEW_WIDTH;
    _pageControl.currentPage=GlobalPageControlNumber;
    if (GlobalPageControlNumber == 3)
    {
        self.intoButton.hidden = NO;
    }
    else
    {
        self.intoButton.hidden = YES;
    }
}

- (IBAction)enterAction:(id)sender
{
    MainFrameView *mainView = [[MainFrameView alloc] initWithNibName:@"MainFrameView" bundle:nil];
    UINavigationController *mainFrameNav = [[UINavigationController alloc] initWithRootViewController:mainView];
    
    LeftView *leftViewController=[[LeftView alloc]initWithNibName:@"LeftView" bundle:nil];
    
    _sideViewController=[[YRSideViewController alloc]initWithNibName:nil bundle:nil];
    _sideViewController.rootViewController=mainFrameNav;
    _sideViewController.leftViewController=leftViewController;
    
    _sideViewController.leftViewShowWidth=230;
    _sideViewController.needSwipeShowMenu=true;//默认开启的可滑动展示
    
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    delegate.window.rootViewController = _sideViewController;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    //    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
