//
//  OpinionView.m
//  DaDangJia
//
//  Created by Seven on 15/9/13.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "OpinionView.h"

@interface OpinionView ()

@end

@implementation OpinionView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    
    self.contentTf.delegate = self;
    self.submitBtn.layer.cornerRadius=self.submitBtn.frame.size.height/2;
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger textLength = [textView.text length];
    if (textLength == 0) {
        [self.contentPlaceholder setHidden:NO];
    }else{
        [self.contentPlaceholder setHidden:YES];
    }
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

- (IBAction)submitAction:(id)sender
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        NSString *contentStr = self.contentTf.text;
        if ([contentStr length] == 0) {
            [Tool showCustomHUD:@"请输入内容" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
            return;
        }
        self.submitBtn.enabled = NO;
        UserInfo *userInfo = [[UserModel Instance] getUserInfo];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:contentStr forKey:@"content"];
        [param setValue:userInfo.regUserId forKey:@"regUserId"];
        NSString *addAfterFellUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_addAfterFell] params:param];
        [[AFOSCClient sharedClient]getPath:addAfterFellUrl parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       @try {
                                           NSData *data = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                                           NSError *error;
                                           NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                           
                                           NSString *state = [[json objectForKey:@"header"] objectForKey:@"state"];
                                           if ([state isEqualToString:@"0000"] == NO) {
                                               UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"错误提示"
                                                                                            message:[[json objectForKey:@"header"] objectForKey:@"msg"]
                                                                                           delegate:nil
                                                                                  cancelButtonTitle:@"确定"
                                                                                  otherButtonTitles:nil];
                                               [av show];
                                               return;
                                           }
                                           else
                                           {
                                               [Tool showCustomHUD:@"提交成功" andView:self.view andImage:@"37x-Failure.png" andAfterDelay:2];
                                               self.contentTf.text = @"";
                                           }
                                           self.submitBtn.enabled = YES;
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
    }
}

@end
