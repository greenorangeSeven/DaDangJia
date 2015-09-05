//
//  MainFrameView.h
//  DaDangJia
//
//  Created by Seven on 15/8/18.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainPageView.h"
#import "ConvenienceView.h"
#import "ReadilyView.h"

@interface MainFrameView : UIViewController

@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UIButton *item1Btn;
@property (weak, nonatomic) IBOutlet UIButton *item2Btn;
@property (weak, nonatomic) IBOutlet UIButton *item3Btn;
@property (weak, nonatomic) IBOutlet UIButton *item4Btn;
@property (weak, nonatomic) IBOutlet UIButton *item5Btn;

@property (weak, nonatomic) IBOutlet UILabel *item1Lb;
@property (weak, nonatomic) IBOutlet UILabel *item2Lb;
@property (weak, nonatomic) IBOutlet UILabel *item4Lb;
@property (weak, nonatomic) IBOutlet UILabel *item5Lb;

- (IBAction)item1Action:(id)sender;
- (IBAction)item2Action:(id)sender;
- (IBAction)item3Action:(id)sender;
- (IBAction)item4Action:(id)sender;
- (IBAction)item5Action:(id)sender;

@property (strong, nonatomic) MainPageView *mainPage;
@property (strong, nonatomic) ConvenienceView *conveniencePage;
@property (strong, nonatomic) ReadilyView *readilyPage;

@end
