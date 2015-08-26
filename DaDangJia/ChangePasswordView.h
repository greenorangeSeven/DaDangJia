//
//  ChangePasswordView.h
//  DaDangJia
//
//  Created by Seven on 15/8/24.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordView : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *securitycodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *oldPwdTf;
@property (weak, nonatomic) IBOutlet UITextField *securitycodeTf;
@property (weak, nonatomic) IBOutlet UITextField *newsPwdTf;
@property (weak, nonatomic) IBOutlet UITextField *newsPwdATf;

- (IBAction)sendSecurityCodeAction:(id)sender;

@end
