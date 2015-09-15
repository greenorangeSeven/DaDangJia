//
//  LeftView.h
//  DaDangJia
//
//  Created by Seven on 15/8/19.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftView : UIViewController<UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *faceIv;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLb;
@property (weak, nonatomic) IBOutlet UILabel *userInfoLb;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)loginAction:(id)sender;
- (IBAction)settingAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *integralLb;
- (IBAction)myGroupByAction:(id)sender;
- (IBAction)myRedPacketAction:(id)sender;
- (IBAction)myCouponAction:(id)sender;
- (IBAction)myPublicAction:(id)sender;
- (IBAction)myCollectAction:(id)sender;

@end
