//
//  MyPublicClassView.h
//  DaDangJia
//
//  Created by Seven on 15/9/16.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPublicClassView : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
