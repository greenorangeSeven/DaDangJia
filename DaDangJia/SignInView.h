//
//  SignInView.h
//  DaDangJia
//
//  Created by Seven on 15/9/13.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInView : UIViewController

- (IBAction)lotteryAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *signInBtn;
- (IBAction)signInAction:(id)sender;

@end
