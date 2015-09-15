//
//  SettingView.h
//  DaDangJia
//
//  Created by Seven on 15/8/26.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingView : UIViewController

@property (weak, nonatomic) IBOutlet UIView *logoutView;
- (IBAction)yhxyAction:(id)sender;
- (IBAction)ystkAction:(id)sender;
- (IBAction)yjfkAction:(id)sender;
- (IBAction)tjxzAction:(id)sender;
- (IBAction)kfrxAction:(id)sender;
- (IBAction)gywmAction:(id)sender;
- (IBAction)bbsmAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
