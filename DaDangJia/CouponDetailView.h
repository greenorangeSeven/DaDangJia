//
//  CouponDetailView.h
//  DaDangJia
//
//  Created by Seven on 15/9/9.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coupon.h"

@interface CouponDetailView : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UITextFieldDelegate,UIWebViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) Coupon *coupon;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *imageIv;
@property (weak, nonatomic) IBOutlet UILabel *couponNameLb;
@property (weak, nonatomic) IBOutlet UILabel *desLb;
@property (weak, nonatomic) IBOutlet UILabel *phoneLb;
@property (weak, nonatomic) IBOutlet UILabel *addressLb;
@property (weak, nonatomic) IBOutlet UILabel *convertCodeLb;
@property (weak, nonatomic) IBOutlet UIButton *convertBtn;
@property (weak, nonatomic) IBOutlet UIWebView *contentWebView;

@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
- (IBAction)praiseAction:(id)sender;
- (IBAction)commentAction:(id)sender;

- (IBAction)convertAction:(id)sender;

@end
