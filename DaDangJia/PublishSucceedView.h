//
//  PublishSucceedView.h
//  DaDangJia
//
//  Created by Seven on 15/9/7.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublishSucceedView : UIViewController

@property (weak, nonatomic) IBOutlet UIView *succeedView;
@property (weak, nonatomic) UIViewController *parentView;
@property (weak, nonatomic) IBOutlet UIButton *closebBtn;
- (IBAction)closeAction:(id)sender;

@end
