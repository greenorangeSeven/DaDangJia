//
//  StartView.h
//  JinChang
//
//  Created by Seven on 15/8/28.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartView : UIViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *intoButton;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property bool isPush;

- (IBAction)enterAction:(id)sender;

@end
