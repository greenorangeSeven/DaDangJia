//
//  FindPasswordView.h
//  DaDangJia
//
//  Created by Seven on 15/8/19.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindPasswordView : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *securitycodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property (weak, nonatomic) IBOutlet UITextField *mobileNoTf;
@property (weak, nonatomic) IBOutlet UITextField *securitycodeTf;
@property (weak, nonatomic) IBOutlet UITextField *newsPwdTf;
@property (weak, nonatomic) IBOutlet UITextField *newsPwdATf;

- (IBAction)sendSecurityCodeAction:(id)sender;
- (IBAction)saveAction:(id)sender;

@end
