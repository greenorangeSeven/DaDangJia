//
//  ModifyHouseView.h
//  DaDangJia
//
//  Created by Seven on 15/8/24.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyHouseView : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *cityTf;
@property (weak, nonatomic) IBOutlet UITextField *communityTf;
@property (weak, nonatomic) IBOutlet UITextField *buildingTf;
@property (weak, nonatomic) IBOutlet UITextField *houseNumTf;

@end
