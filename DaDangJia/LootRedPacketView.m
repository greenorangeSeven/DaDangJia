//
//  LootRedPacketView.m
//  DaDangJia
//
//  Created by Seven on 15/9/4.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "LootRedPacketView.h"
#import "UIViewController+CWPopup.h"

@interface LootRedPacketView ()

@end

@implementation LootRedPacketView

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)closeAction:(id)sender {
    [_parentView dismissPopupViewControllerAnimated:YES completion:^{
        NSLog(@"popup view dismissed");
    }];
}

- (IBAction)lootAction:(id)sender {
    self.lootBtn.hidden = YES;
    UserInfo *userInfo = [[UserModel Instance] getUserInfo];
    //抢红包
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:self.redPacket.rpRuleId forKey:@"rpRuleId"];
    [param setValue:userInfo.regUserId forKey:@"regUserId"];
    NSString *addRPUrl =[Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_addUserRedpackage] params:param];
    [[AFOSCClient sharedClient]getPath:addRPUrl parameters:Nil
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   @try {
                                       NSLog(@"%@", operation.responseString);
                                       NSData *data = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                                       NSError *error;
                                       NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                       
                                       NSString *state = [[json objectForKey:@"header"] objectForKey:@"state"];
                                       NSString *msg = [[json objectForKey:@"header"] objectForKey:@"msg"];
                                       if([state isEqualToString:@"0000"])
                                       {
                                           self.moneyLb.text = msg;
                                           self.moneyLb.hidden = NO;
                                           self.moneyBglB.hidden = NO;
                                           return;
                                       }
                                       else
                                       {
                                           self.moneyBglB.text = msg;
                                           self.moneyLb.hidden = YES;
                                           self.moneyBglB.hidden = NO;
                                           
                                       }
                                   }
                                   @catch (NSException *exception) {
                                       [NdUncaughtExceptionHandler TakeException:exception];
                                   }
                                   @finally {
                                       
                                   }
                               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   if ([UserModel Instance].isNetworkRunning == NO) {
                                       return;
                                   }
                                   if ([UserModel Instance].isNetworkRunning) {
                                       [Tool ToastNotification:@"错误 网络无连接" andView:self.view andLoading:NO andIsBottom:NO];
                                   }
                               }];
    
    
    
    
    
    
    [self.lootBgIv setImage:[UIImage imageNamed:@"looted"]];
}
@end
