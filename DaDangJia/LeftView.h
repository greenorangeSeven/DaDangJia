//
//  LeftView.h
//  DaDangJia
//
//  Created by Seven on 15/8/19.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftView : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *faceIv;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLb;
@property (weak, nonatomic) IBOutlet UILabel *userInfoLb;


- (IBAction)loginAction:(id)sender;
- (IBAction)settingAction:(id)sender;

@end
