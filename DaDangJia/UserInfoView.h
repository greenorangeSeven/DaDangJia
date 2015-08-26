//
//  UserInfoView.h
//  DaDangJia
//
//  Created by Seven on 15/8/24.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPImageCropperViewController.h"

@interface UserInfoView : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, VPImageCropperDelegate, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *faceBg1View;
@property (weak, nonatomic) IBOutlet UILabel *faceBg2View;
@property (weak, nonatomic) IBOutlet UIImageView *faceIv;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTf;
@property (weak, nonatomic) IBOutlet UIButton *uodateFaceBtn;

@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
@property (weak, nonatomic) IBOutlet UILabel *mobileNoLb;

@property (weak, nonatomic) IBOutlet UIView *changePwdView;

- (IBAction)updateFaceAction:(id)sender;
- (IBAction)modifyHouseAction:(id)sender;

@end
