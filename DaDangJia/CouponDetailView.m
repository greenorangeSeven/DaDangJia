//
//  CouponDetailView.m
//  DaDangJia
//
//  Created by Seven on 15/9/9.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "CouponDetailView.h"
#import "GroupBuyCommentCell.h"
#import "GroupBuyComment.h"
#import "UIImageView+WebCache.h"
#import "IQKeyboardManager/KeyboardManager.framework/Headers/IQKeyboardManager.h"

@interface CouponDetailView ()
{
    Coupon *detail;
    NSArray *comments;
    UserInfo *userInfo;
    int heartCount;
}

@property(nonatomic, strong) IBOutlet UIToolbar *toolbar;
@property(nonatomic, strong) IBOutlet UITextField *textField;
@property(nonatomic, strong) IBOutlet UITextField *textFieldOnToolbar;

@end

@implementation CouponDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"优惠券";
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //    设置无分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.convertBtn.layer.cornerRadius=self.convertBtn.frame.size.height/2;
    
    [self findCouponDetail];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(-10, 0, 0, 0)];
    [self.tableView addSubview:self.textField];
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.delegate = self;
    self.textFieldOnToolbar.delegate = self;
    self.textField.inputAccessoryView = [self keyboardToolBar];
}

- (void)textFieldBecomeFirstResponder
{
    [self.textFieldOnToolbar becomeFirstResponder];
    [self.textField becomeFirstResponder];
}

- (UIToolbar *)keyboardToolBar
{
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    [toolBar sizeToFit];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 4, width - 70, 32)];
    textField.delegate = self;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textFieldOnToolbar = textField;
    self.textFieldOnToolbar.returnKeyType = UIReturnKeyDone;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:textField];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] init];
    doneButton.title = @"评价";
    doneButton.style = UIBarButtonItemStyleDone;
    doneButton.action = @selector(doneClicked:);
    doneButton.tintColor = [Tool getColorForMain];
    doneButton.target = self;
    
    [toolBar setItems:@[item,doneButton]];
    
    return toolBar;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textFieldOnToolbar resignFirstResponder];
    [self.textField resignFirstResponder];
    return YES;
}

- (void)doneClicked:(id)sender
{
    [self.textField resignFirstResponder];
    [self.textFieldOnToolbar resignFirstResponder];
    NSString *commentContent = self.textFieldOnToolbar.text;
    if ([commentContent length] == 0) {
        return;
    }
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:detail.couponId forKey:@"couponId"];
    [param setValue:userInfo.regUserId forKey:@"regUserId"];
    [param setValue:commentContent forKey:@"content"];
    
    NSString *addCouponCommentSign = [Tool serializeSign:[NSString stringWithFormat:@"%@%@", api_base_url, api_addCouponComment] params:param];
    [param setValue:Appkey forKey:@"accessId"];
    [param setValue:addCouponCommentSign forKey:@"sign"];
    
    NSString *addCouponCommentUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_addCouponComment];
    [[AFOSCClient sharedClient] postPath:addCouponCommentUrl parameters:param
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
                                         }
                                         else
                                         {
                                             self.textFieldOnToolbar.text = @"";
                                             [self.textFieldOnToolbar resignFirstResponder];
                                             [self.textField resignFirstResponder];
                                             
                                             [self findCouponDetail];
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
}

- (void)findCouponDetail
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:self.coupon.couponId forKey:@"couponId"];
        NSString *getCouponDetailUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_findCouponInfoById] params:param];
        [[AFOSCClient sharedClient]getPath:getCouponDetailUrl parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       @try {
                                           NSData *data = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                                           NSError *error;
                                           NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                           
                                           NSDictionary *datas = [json objectForKey:@"data"];
                                           detail = [Tool readJsonDicToObj:datas andObjClass:[Coupon class]];
                                           comments = detail.commentList;
                                           [self initHeaderView];
                                           if ([comments count] > 0) {
                                               for (GroupBuyComment *comment in comments) {
                                                   comment.starttime = [Tool TimestampToDateStr:[[NSNumber numberWithLong:comment.starttimeStamp] stringValue] andFormatterStr:@"yyyy-MM-dd"];
                                               }
                                               [self.tableView reloadData];
                                           }
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally {
                                           
                                       }
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       NSLog(@"列表获取出错");
                                       
                                       if ([UserModel Instance].isNetworkRunning == NO) {
                                           return;
                                       }
                                       
                                       if ([UserModel Instance].isNetworkRunning) {
                                           [Tool showCustomHUD:@"网络不给力" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
                                       }
                                   }];
    }
}

- (void)initHeaderView
{
    [self.imageIv sd_setImageWithURL:[NSURL URLWithString:detail.imgFull] placeholderImage:[UIImage imageNamed:@"default_head"]];
    self.couponNameLb.text = detail.couponName;
    self.desLb.text = detail.des;
    self.phoneLb.text = [NSString stringWithFormat:@"咨询电话:%@", detail.phone];
    self.addressLb.text = [NSString stringWithFormat:@"使用期限:%@", detail.useLimit];
    self.convertCodeLb.text = [NSString stringWithFormat:@"优惠券兑换码:%@", detail.couponCode];
    heartCount = [detail.heartList count];
    [self.praiseBtn setTitle:[NSString stringWithFormat:@"打赏(%d)", [detail.heartList count]] forState:UIControlStateNormal];
    [self.commentBtn setTitle:[NSString stringWithFormat:@"评一评(%d)", [detail.commentList count]] forState:UIControlStateNormal];
    [self initContentDetail];
}

- (void)initContentDetail
{
    if(detail.content == nil)
    {
        detail.content = @"";
    }
    NSString *html = [NSString stringWithFormat:@"<body>%@<div id='web_body'>%@</div></body>", HTML_Style, detail.content];
    NSString *result = [Tool getHTMLString:html];
    //WebView的背景颜色去除
    [Tool clearWebViewBackground:self.contentWebView];
    [self.contentWebView sizeToFit];
    [self.contentWebView loadHTMLString:result baseURL:nil];
    self.contentWebView.delegate = self;
    
    self.contentWebView.opaque = YES;
    for (UIView *subView in [self.contentWebView subviews])
    {
        if ([subView isKindOfClass:[UIScrollView class]])
        {
            //            ((UIScrollView *)subView).bounces = YES;
            ((UIScrollView *)subView).scrollEnabled = NO;
        }
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webViewP
{
    NSArray *arr = [webViewP subviews];
    UIScrollView *webViewScroll = [arr objectAtIndex:0];
    [webViewP setFrame:CGRectMake(self.contentWebView.frame.origin.x, self.contentWebView.frame.origin.y, self.contentWebView.frame.size.width, [webViewScroll contentSize].height)];
    [self.headerView setFrame:CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, self.headerView.bounds.size.width, self.headerView.bounds.size.height + self.contentWebView.frame.size.height)];
    self.tableView.tableHeaderView = self.headerView;
}

#pragma TableView的处理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return comments.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 87.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    cell.backgroundColor = [Tool getBackgroundColor];
}

//列表数据渲染
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupBuyCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupBuyCommentCellIdentifier];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"GroupBuyCommentCell" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[GroupBuyCommentCell class]]) {
                cell = (GroupBuyCommentCell *)o;
                break;
            }
        }
    }
    NSInteger row = [indexPath row];
    GroupBuyComment *comment = [comments objectAtIndex:row];
    cell.photoIv.layer.masksToBounds=YES;
    [cell.photoIv sd_setImageWithURL:[NSURL URLWithString:comment.photoFull] placeholderImage:[UIImage imageNamed:@"default_head"]];
    cell.photoIv.layer.cornerRadius=cell.photoIv.frame.size.height/2;
    cell.nickNameLb.text = comment.regUserName;
    cell.contentTv.text = comment.content;
    cell.timeLb.text = comment.starttime;
    return cell;
}

//表格行点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

- (IBAction)praiseAction:(id)sender {
    if ([UserModel Instance].isLogin == NO) {
        [Tool noticeLogin:self.view andDelegate:self andTitle:@""];
        return;
    }
    //团购打赏
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:detail.couponId forKey:@"couponId"];
    [param setValue:userInfo.regUserId forKey:@"regUserId"];
    NSString *heartUrl =[Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_addCouponCancelInHeart] params:param];
    [[AFOSCClient sharedClient]getPath:heartUrl parameters:Nil
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   @try {
                                       NSLog(@"%@", operation.responseString);
                                       NSData *data = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                                       NSError *error;
                                       NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                       
                                       NSString *state = [[json objectForKey:@"header"] objectForKey:@"state"];
                                       NSString *msg = [[json objectForKey:@"header"] objectForKey:@"msg"];
                                       [Tool showCustomHUD:msg andView:self.view andImage:@"37x-Failure.png" andAfterDelay:2];
                                       if ([state isEqualToString:@"0004"]) {
                                           heartCount -= 1;
                                           [self.praiseBtn setTitle:[NSString stringWithFormat:@"打赏(%d)", heartCount] forState:UIControlStateNormal];
                                       }
                                       else if ([state isEqualToString:@"0005"]) {
                                           heartCount += 1;
                                           [self.praiseBtn setTitle:[NSString stringWithFormat:@"打赏(%d)", heartCount] forState:UIControlStateNormal];
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
}

- (IBAction)commentAction:(id)sender {
    [self.textField becomeFirstResponder];
    [self.textFieldOnToolbar becomeFirstResponder];
}

- (IBAction)convertAction:(id)sender {
    if ([UserModel Instance].isLogin == NO) {
        [Tool noticeLogin:self.view andDelegate:self andTitle:@""];
        return;
    }
    //团购，取消团购
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:detail.couponId forKey:@"couponId"];
    [param setValue:userInfo.regUserId forKey:@"regUserId"];
    NSString *receivingCouponUrl =[Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_receivingCoupon] params:param];
    [[AFOSCClient sharedClient]getPath:receivingCouponUrl parameters:Nil
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   @try {
                                       NSLog(@"%@", operation.responseString);
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
                                       }
                                       else
                                       {
                                           NSString *msg = [[json objectForKey:@"header"] objectForKey:@"msg"];
                                           [Tool showCustomHUD:msg andView:self.view andImage:@"37x-Failure.png" andAfterDelay:2];
                                           if([msg isEqualToString:@"参与团购成功!"])
                                           {
                                               [self.convertBtn setTitle:@"已领取" forState:UIControlStateNormal];
                                           }
                                           else
                                           {
                                               [self.convertBtn setTitle:@"立即领券" forState:UIControlStateNormal];
                                           }
                                           
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
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [Tool processLoginNotice:actionSheet andButtonIndex:buttonIndex andNav:self.navigationController andParent:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    userInfo = [[UserModel Instance] getUserInfo];
    
    self.navigationController.navigationBar.hidden = NO;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

@end
