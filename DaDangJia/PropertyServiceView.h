//
//  PropertyServiceView.h
//  DaDangJia
//
//  Created by Seven on 15/8/26.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PropertyServiceView : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *noticeTitleTf;
@property (weak, nonatomic) IBOutlet UITextView *feeTitleTf;
@property (weak, nonatomic) IBOutlet UIView *noticeView;
@property (weak, nonatomic) IBOutlet UIButton *billBtn;
@property (weak, nonatomic) IBOutlet UIButton *expressBtn;
@property (weak, nonatomic) IBOutlet UIButton *repairBtn;

- (IBAction)noticeAction:(id)sender;
- (IBAction)addRepairAction:(id)sender;
- (IBAction)expressAction:(id)sender;
- (IBAction)payfeeAction:(id)sender;

@end
