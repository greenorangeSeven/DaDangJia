//
//  FeeTableView.h
//  DaDangJia
//
//  Created by Seven on 15/8/28.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeeTableView : UIViewController<UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) NSString *typeId;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *operationView;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLb;
@property (weak, nonatomic) IBOutlet UIButton *payfeeBtn;
@property (weak, nonatomic) IBOutlet UILabel *payTypeLb;
@property (weak, nonatomic) IBOutlet UITextField *payTypeTf;


- (IBAction)payfeeAction:(id)sender;

@end
