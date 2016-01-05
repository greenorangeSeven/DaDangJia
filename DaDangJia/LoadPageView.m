//
//  LoadPageView.m
//  DaDangJia
//
//  Created by Seven on 15/9/16.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "LoadPageView.h"
#import "UIViewController+CWPopup.h"

@interface LoadPageView ()

@end

@implementation LoadPageView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loadIv.layer.masksToBounds=YES;
    self.loadIv.layer.cornerRadius=10.0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeLoad) name:Notification_CloseLoadPage object:nil];
}

- (void)closeLoad
{
    [_parentView dismissPopupViewControllerAnimated:YES completion:^{
        NSLog(@"popup view dismissed");
        [ [NSNotificationCenter defaultCenter] removeObserver:self name:Notification_CloseLoadPage object:nil];
    }];
}

- (void)didReceiveMemoryWarning {
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
