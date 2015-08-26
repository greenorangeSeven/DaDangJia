//
//  RegisterStep1View.h
//  DaDangJia
//
//  Created by Seven on 15/8/19.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterStep1View : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *mobileNoTf;
@property (weak, nonatomic) IBOutlet UITextField *securityCodeTf;
@property (weak, nonatomic) IBOutlet UIButton *securitycodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *passwordTf;
@property (weak, nonatomic) IBOutlet UITextField *passwordATf;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;

- (IBAction)getSecurityCodeAction:(id)sender;
- (IBAction)agreeAction:(id)sender;

@end
