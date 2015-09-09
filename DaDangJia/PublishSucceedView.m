//
//  PublishSucceedView.m
//  DaDangJia
//
//  Created by Seven on 15/9/7.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "PublishSucceedView.h"
#import "UIViewController+CWPopup.h"

@interface PublishSucceedView ()

@end

@implementation PublishSucceedView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.succeedView.layer.cornerRadius=10.0;
    
    self.closebBtn.layer.cornerRadius=self.closebBtn.frame.size.height/2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeAction:(id)sender {
    [_parentView dismissPopupViewControllerAnimated:YES completion:^{
        NSLog(@"popup view dismissed");
    }];
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
