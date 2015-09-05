//
//  HotGroupBuyDetailView.h
//  DaDangJia
//
//  Created by Seven on 15/9/1.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotGroupBuyDetailView : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UITextFieldDelegate>

@property (weak, nonatomic) NSString *groupId;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *imageIv;
@property (weak, nonatomic) IBOutlet UILabel *phoneLb;
@property (weak, nonatomic) IBOutlet UILabel *addressLb;
@property (weak, nonatomic) IBOutlet UILabel *personCountLb;
@property (weak, nonatomic) IBOutlet UILabel *stateLb;
@property (weak, nonatomic) IBOutlet UILabel *joinCountLb;
@property (weak, nonatomic) IBOutlet UILabel *badCountLb;
@property (weak, nonatomic) IBOutlet UIButton *tuanBtn;
@property (weak, nonatomic) IBOutlet UILabel *badLb;

@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
- (IBAction)praiseAction:(id)sender;
- (IBAction)commentAction:(id)sender;

- (IBAction)groupBuyAction:(id)sender;

@end
