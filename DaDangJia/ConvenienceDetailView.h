//
//  ConvenienceDetailView.h
//  DaDangJia
//
//  Created by Seven on 15/8/23.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopInfo.h"

@interface ConvenienceDetailView : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) ShopInfo *shopInfo;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *shopImageIv;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLb;
@property (weak, nonatomic) IBOutlet UILabel *projectLb;
@property (weak, nonatomic) IBOutlet UILabel *phoneLb;
@property (weak, nonatomic) IBOutlet UILabel *addressLb;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;

@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
- (IBAction)praiseAction:(id)sender;
- (IBAction)commentAction:(id)sender;
- (IBAction)callAction:(id)sender;

@end
