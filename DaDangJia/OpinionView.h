//
//  OpinionView.h
//  DaDangJia
//
//  Created by Seven on 15/9/13.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpinionView : UIViewController<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *contentTf;
@property (weak, nonatomic) IBOutlet UILabel *contentPlaceholder;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

- (IBAction)submitAction:(id)sender;

@end
