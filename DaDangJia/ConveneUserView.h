//
//  ConveneUserView.h
//  DaDangJia
//
//  Created by Seven on 15/9/20.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConveneUserView : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) NSMutableArray *users;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
