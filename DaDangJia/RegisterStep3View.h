//
//  RegisterStep3View.h
//  DaDangJia
//
//  Created by Seven on 15/8/20.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterStep3View : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *finishBtn;

@property (copy, nonatomic) NSString *mobileNoStr;
@property (copy, nonatomic) NSString *validateCodeStr;
@property (copy, nonatomic) NSString *passwordStr;
@property (copy, nonatomic) NSString *numberId;
@property (copy, nonatomic) NSString *nickName;

@property (weak, nonatomic) IBOutlet UITextField *ownerNameTf;
@property (weak, nonatomic) IBOutlet UITextField *idCardTf;
@property (weak, nonatomic) IBOutlet UITextField *identityTf;

- (IBAction)finishAction:(id)sender;

@end
