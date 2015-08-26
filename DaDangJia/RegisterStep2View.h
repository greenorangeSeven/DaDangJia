//
//  RegisterStep2View.h
//  DaDangJia
//
//  Created by Seven on 15/8/20.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterStep2View : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (copy, nonatomic) NSString *mobileNoStr;
@property (copy, nonatomic) NSString *validateCodeStr;
@property (copy, nonatomic) NSString *passwordStr;

@property (weak, nonatomic) IBOutlet UITextField *nickNameTf;

@property (weak, nonatomic) IBOutlet UITextField *cityTf;
@property (weak, nonatomic) IBOutlet UITextField *communityTf;
@property (weak, nonatomic) IBOutlet UITextField *buildingTf;
//@property (weak, nonatomic) IBOutlet UITextField *unitTf;
@property (weak, nonatomic) IBOutlet UITextField *houseNumTf;

@end
