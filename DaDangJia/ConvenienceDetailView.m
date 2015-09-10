//
//  ConvenienceDetailView.m
//  DaDangJia
//
//  Created by Seven on 15/8/23.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "ConvenienceDetailView.h"
#import "UIImageView+WebCache.h"
#import "IQKeyboardManager/KeyboardManager.framework/Headers/IQKeyboardManager.h"
#import "ShopDetail.h"
#import "GroupBuyComment.h"
#import "GroupBuyCommentCell.h"
#import "BMapKit.h"
#import "StoreMapPointView.h"

@interface ConvenienceDetailView ()
{
    ShopDetail *detail;
    NSArray *comments;
    UserInfo *userInfo;
    UIWebView *phoneCallWebView;
}

@property(nonatomic, strong) IBOutlet UIToolbar *toolbar;
@property(nonatomic, strong) IBOutlet UITextField *textField;
@property(nonatomic, strong) IBOutlet UITextField *textFieldOnToolbar;

@end

@implementation ConvenienceDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.shopInfo.shopName;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //    设置无分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.tableHeaderView = self.headerView;
    
    [self initHeaderView];
        
    self.callBtn.layer.cornerRadius=self.callBtn.frame.size.height/2;
    [self findShopDetail];
    
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
    [param setValue:self.shopInfo.shopId forKey:@"shopId"];
    [param setValue:userInfo.regUserId forKey:@"regUserId"];
    [param setValue:commentContent forKey:@"content"];
    
    NSString *shopCommentSign = [Tool serializeSign:[NSString stringWithFormat:@"%@%@", api_base_url, api_addShopComment] params:param];
    [param setValue:Appkey forKey:@"accessId"];
    [param setValue:shopCommentSign forKey:@"sign"];
    
    NSString *addShopCommentUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_addShopComment];
    [[AFOSCClient sharedClient] postPath:addShopCommentUrl parameters:param
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
                                             
                                             [self findShopDetail];
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

- (void)initHeaderView
{
    [self.shopImageIv sd_setImageWithURL:[NSURL URLWithString:self.shopInfo.imgUrlFull] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.shopNameLb.text = self.shopInfo.shopName;
    self.phoneLb.text = [NSString stringWithFormat:@"电       话:%@", self.shopInfo.phone];
    self.addressLb.text = [NSString stringWithFormat:@"地       址:%@", self.shopInfo.shopAddress];
    self.remarkTv.text = self.shopInfo.remark;
    [self.praiseBtn setTitle:[NSString stringWithFormat:@"打赏(%d)", detail.heartCount] forState:UIControlStateNormal];
    [self.commentBtn setTitle:[NSString stringWithFormat:@"评一评(%d)", [detail.commentList count]] forState:UIControlStateNormal];
}

- (void)findShopDetail
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        //查询指定房间所绑定的用户信息
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:self.shopInfo.shopId forKey:@"shopId"];
        
        NSString *findShopDetailUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_findShopInfoById] params:param];
        [[AFOSCClient sharedClient]getPath:findShopDetailUrl parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       @try {
                                           NSData *data = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                                           NSError *error;
                                           NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                           
                                           NSDictionary *datas = [json objectForKey:@"data"];
                                           detail = [Tool readJsonDicToObj:datas andObjClass:[ShopDetail class]];
                                           comments = detail.commentList;
//                                           [self initHeaderView];
                                           if ([comments count] > 0) {
                                               for (GroupBuyComment *comment in comments) {
                                                   comment.starttime = [Tool TimestampToDateStr:[[NSNumber numberWithLong:comment.starttimeStamp] stringValue] andFormatterStr:@"yyyy-MM-dd"];
                                               }
                                               [self initHeaderView];
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

- (IBAction)praiseAction:(id)sender
{
    if ([UserModel Instance].isLogin == NO) {
        [Tool noticeLogin:self.view andDelegate:self andTitle:@""];
        return;
    }
    //团购打赏
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:self.shopInfo.shopId forKey:@"shopId"];
//    [param setValue:userInfo.regUserId forKey:@"regUserId"];
    NSString *heartUrl =[Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_addShopHeartCount] params:param];
    [[AFOSCClient sharedClient]getPath:heartUrl parameters:Nil
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   @try {
                                       NSLog(@"%@", operation.responseString);
                                       NSData *data = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                                       NSError *error;
                                       NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                       
                                       NSString *state = [[json objectForKey:@"header"] objectForKey:@"state"];
                                       NSString *msg = [[json objectForKey:@"header"] objectForKey:@"msg"];
                                       
                                       if ([state isEqualToString:@"0000"]) {
                                           detail.heartCount += 1;
                                           [self.praiseBtn setTitle:[NSString stringWithFormat:@"打赏(%d)", detail.heartCount] forState:UIControlStateNormal];
                                           [Tool showCustomHUD:@"打赏成功" andView:self.view andImage:@"37x-Failure.png" andAfterDelay:2];
                                           return;
                                       }
                                       [Tool showCustomHUD:msg andView:self.view andImage:@"37x-Failure.png" andAfterDelay:2];
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

- (IBAction)commentAction:(id)sender
{
    if ([UserModel Instance].isLogin == NO) {
        [Tool noticeLogin:self.view andDelegate:self andTitle:@""];
        return;
    }
    [self.textField becomeFirstResponder];
    [self.textFieldOnToolbar becomeFirstResponder];
}

- (IBAction)callAction:(id)sender {
    NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", detail.phone]];
    if (!phoneCallWebView) {
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneUrl]];
}

- (IBAction)mapPointAction:(id)sender {
    CLLocationCoordinate2D coor;
    coor.longitude = self.shopInfo.longitude ;
    coor.latitude = self.shopInfo.latitude;
    StoreMapPointView *pointView = [[StoreMapPointView alloc] init];
    pointView.storeCoor = coor;
    pointView.storeTitle = self.shopInfo.shopName;
    [self.navigationController pushViewController:pointView animated:YES];
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
