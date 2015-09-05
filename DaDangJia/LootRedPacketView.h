//
//  LootRedPacketView.h
//  DaDangJia
//
//  Created by Seven on 15/9/4.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedPacket.h"

@interface LootRedPacketView : UIViewController

@property (weak, nonatomic) RedPacket *redPacket;
@property (weak, nonatomic) UIViewController *parentView;
@property (weak, nonatomic) IBOutlet UIImageView *lootBgIv;
- (IBAction)closeAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *lootBtn;
- (IBAction)lootAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *moneyBglB;
@property (weak, nonatomic) IBOutlet UILabel *moneyLb;

@end
