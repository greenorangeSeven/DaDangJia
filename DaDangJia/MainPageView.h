//
//  MainPageView.h
//  DaDangJia
//
//  Created by Seven on 15/8/18.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainPageView : UIViewController<UIActionSheetDelegate>

@property (weak, nonatomic) UIView *frameView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)propertyServiceAction:(id)sender;
- (IBAction)tuanAction:(id)sender;
- (IBAction)welfreAction:(id)sender;
- (IBAction)helpAction:(id)sender;
- (IBAction)zjlAction:(id)sender;
- (IBAction)hyhAction:(id)sender;

@end
