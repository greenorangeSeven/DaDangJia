//
//  TopicDetailView.m
//  DaDangJia
//
//  Created by Seven on 15/9/7.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "TopicDetailView.h"
#import "UIImageView+WebCache.h"
#import "UploadImageCell.h"
#import "GroupBuyCommentCell.h"
#import "TopicReply.h"
#import "IQKeyboardManager/KeyboardManager.framework/Headers/IQKeyboardManager.h"

@interface TopicDetailView ()
{
    UserInfo *userInfo;
    NSMutableArray *replyData;
    NSString *isCollect;
}

@property(nonatomic, strong) IBOutlet UIToolbar *toolbar;
@property(nonatomic, strong) IBOutlet UITextField *textField;
@property(nonatomic, strong) IBOutlet UITextField *textFieldOnToolbar;

@end

@implementation TopicDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.typeName;
    
    userInfo = [[UserModel Instance] getUserInfo];
    
    isCollect = @"0";
    
    self.photoIv.layer.masksToBounds=YES;
    self.photoIv.layer.cornerRadius = self.photoIv.frame.size.width/2;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //    设置无分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.tableHeaderView = self.headerView;
    
    replyData = self.topic.replyList;
    
    [self initHeaderView];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[UploadImageCell class] forCellWithReuseIdentifier:UploadImageCellIdentifier];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(-10, 0, 0, 0)];
    [self.tableView addSubview:self.textField];
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.delegate = self;
    self.textFieldOnToolbar.delegate = self;
    self.textField.inputAccessoryView = [self keyboardToolBar];
}

- (void)isCollect
{
    //生成获取广告URL
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:userInfo.regUserId forKey:@"regUserId"];
    [param setValue:self.topic.topicId forKey:@"topicId"];
    NSString *findTopicCollectionUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_findTopicCollection] params:param];
    [[AFOSCClient sharedClient]getPath:findTopicCollectionUrl parameters:Nil
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   @try {
                                       NSLog(@"%@", operation.responseString);
                                       NSData *data = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                                       NSError *error;
                                       NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                       
                                       NSString *state = [[json objectForKey:@"header"] objectForKey:@"state"];
                                       
                                       if ([state isEqualToString:@"0000"]) {
                                           [self.collectBtn setTitle:@"已收藏" forState:UIControlStateNormal];
                                           [self.collectBtn setImage:[UIImage imageNamed:@"collect_pro"] forState:UIControlStateNormal];
                                           isCollect = @"1";
                                       }
                                       else
                                       {
                                           [self.collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
                                           [self.collectBtn setImage:[UIImage imageNamed:@"collect_nor"] forState:UIControlStateNormal];
                                           isCollect = @"0";
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
    [self.photoIv sd_setImageWithURL:[NSURL URLWithString:self.topic.photoFull] placeholderImage:[UIImage imageNamed:@"default_head"]];
    
    self.nickNameLb.text = self.topic.nickName;
    self.topicContentTv.text = self.topic.content;
    self.timeLb.text = [NSString stringWithFormat:@"%@  发起", self.topic.starttime];
    
    [self.praiseBtn setTitle:[NSString stringWithFormat:@"打赏(%d)", self.topic.heartCount] forState:UIControlStateNormal];
    [self.commentBtn setTitle:[NSString stringWithFormat:@"评一评(%d)", [self.topic.replyList count]] forState:UIControlStateNormal];
}

- (void)getReplyData
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        //生成获取广告URL
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:@"999" forKey:@"countPerPages"];
        [param setValue:@"1" forKey:@"pageNumbers"];
        [param setValue:self.topic.topicId forKey:@"topicId"];
        NSString *getTopicReplyUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_findTopicReplyPage] params:param];
        
        [[AFOSCClient sharedClient]getPath:getTopicReplyUrl parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       @try {
                                           replyData = [Tool readJsonStrToTopicReplyArray:operation.responseString];
                                           NSInteger length = [replyData count];
                                           
                                           if (length > 0)
                                           {
                                               [self.tableView reloadData];
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
                                           [Tool showCustomHUD:@"网络不给力" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
                                       }
                                   }];
    }
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.topic.imgUrlList count];
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UploadImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:UploadImageCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"UploadImageCell" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[UploadImageCell class]]) {
                cell = (UploadImageCell *)o;
                break;
            }
        }
    }
    NSInteger row = [indexPath row];
    NSString *imgurl = [self.topic.imgUrlList objectAtIndex:row];
    [cell.repairIv sd_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(85, 85);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.photos count] == 0) {
        NSMutableArray *photos = [[NSMutableArray alloc] init];
        for (NSString *d in self.topic.imgUrlList) {
            MWPhoto * photo = [MWPhoto photoWithURL:[NSURL URLWithString:d]];
            [photos addObject:photo];
        }
        self.photos = photos;
    }
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
    browser.displayNavArrows = NO;//左右分页切换,默认否
    browser.displaySelectionButtons = NO;//是否显示选择按钮在图片上,默认否
    browser.alwaysShowControls = YES;//控制条件控件 是否显示,默认否
    browser.zoomPhotosToFill = NO;//是否全屏,默认是
    //    browser.wantsFullScreenLayout = YES;//是否全屏
    [browser setCurrentPhotoIndex:[indexPath row]];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController pushViewController:browser animated:YES];
}

//MWPhotoBrowserDelegate委托事件
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma TableView的处理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return replyData.count;
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
    TopicReply *comment = [replyData objectAtIndex:row];
    cell.photoIv.layer.masksToBounds=YES;
    [cell.photoIv sd_setImageWithURL:[NSURL URLWithString:comment.photoFull] placeholderImage:[UIImage imageNamed:@"default_head"]];
    cell.photoIv.layer.cornerRadius=cell.photoIv.frame.size.height/2;
    cell.nickNameLb.text = comment.nickName;
    cell.contentTv.text = comment.replyContent;
    cell.timeLb.text = comment.replyTime;
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
    [self addTopicHeart];
}

- (void)addTopicHeart
{
    //打赏
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:self.topic.topicId forKey:@"topicId"];
    [param setValue:userInfo.regUserId forKey:@"userId"];
    NSString *heartUrl =[Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_addTopicHeart] params:param];
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
                                           self.topic.heartCount += 1;
                                           [self.praiseBtn setTitle:[NSString stringWithFormat:@"打赏(%d)", self.topic.heartCount] forState:UIControlStateNormal];
                                           [Tool showCustomHUD:@"打赏成功" andView:self.view andImage:@"37x-Failure.png" andAfterDelay:2];
                                           return;
                                       }
//                                       [Tool showCustomHUD:msg andView:self.view andImage:@"37x-Failure.png" andAfterDelay:2];
                                       [self delTopicHeart];
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

- (void)delTopicHeart
{
    //打赏
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:self.topic.topicId forKey:@"topicId"];
    [param setValue:userInfo.regUserId forKey:@"userId"];
    NSString *heartUrl =[Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_delTopicHeart] params:param];
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
                                           self.topic.heartCount -= 1;
                                           [self.praiseBtn setTitle:[NSString stringWithFormat:@"打赏(%d)", self.topic.heartCount] forState:UIControlStateNormal];
                                           [Tool showCustomHUD:@"取消打赏" andView:self.view andImage:@"37x-Failure.png" andAfterDelay:2];
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

- (IBAction)collectAction:(id)sender {
    if ([UserModel Instance].isLogin == NO) {
        [Tool noticeLogin:self.view andDelegate:self andTitle:@""];
        return;
    }
    if ([isCollect isEqualToString:@"0"]) {
        [self addTopicCollection];
    }
    else if ([isCollect isEqualToString:@"1"])
    {
        [self delTopicCollection];
    }
}

- (void)addTopicCollection
{
    //生成获取广告URL
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:userInfo.regUserId forKey:@"regUserId"];
    [param setValue:self.topic.topicId forKey:@"topicId"];
    NSString *addTopicCollectionUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_addTopicCollection] params:param];
    [[AFOSCClient sharedClient]getPath:addTopicCollectionUrl parameters:Nil
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   @try {
                                       NSLog(@"%@", operation.responseString);
                                       NSData *data = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                                       NSError *error;
                                       NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                       
                                       NSString *state = [[json objectForKey:@"header"] objectForKey:@"state"];
                                       NSString *msg = [[json objectForKey:@"header"] objectForKey:@"msg"];
                                       
                                       if ([state isEqualToString:@"0000"]) {
                                           [self.collectBtn setTitle:@"已收藏" forState:UIControlStateNormal];
                                           [self.collectBtn setImage:[UIImage imageNamed:@"collect_pro"] forState:UIControlStateNormal];
                                           isCollect = @"1";
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

- (void)delTopicCollection
{
    //生成获取广告URL
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:userInfo.regUserId forKey:@"regUserId"];
    [param setValue:self.topic.topicId forKey:@"topicId"];
    NSString *delTopicCollectionUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_delTopicCollection] params:param];
    [[AFOSCClient sharedClient]getPath:delTopicCollectionUrl parameters:Nil
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   @try {
                                       NSLog(@"%@", operation.responseString);
                                       NSData *data = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                                       NSError *error;
                                       NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                       
                                       NSString *state = [[json objectForKey:@"header"] objectForKey:@"state"];
                                       NSString *msg = [[json objectForKey:@"header"] objectForKey:@"msg"];
                                       
                                       if ([state isEqualToString:@"0000"]) {
                                           [self.collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
                                           [self.collectBtn setImage:[UIImage imageNamed:@"collect_nor"] forState:UIControlStateNormal];
                                           isCollect = @"0";
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
    [param setValue:self.topic.topicId forKey:@"topicId"];
    [param setValue:userInfo.regUserId forKey:@"regUserId"];
    [param setValue:commentContent forKey:@"replyContent"];
    
    NSString *addTopicReplySign = [Tool serializeSign:[NSString stringWithFormat:@"%@%@", api_base_url, api_addTopicReply] params:param];
    [param setValue:Appkey forKey:@"accessId"];
    [param setValue:addTopicReplySign forKey:@"sign"];
    
    NSString *addTopicReplyUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_addTopicReply];
    [[AFOSCClient sharedClient] postPath:addTopicReplyUrl parameters:param
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
                                             
                                             [self getReplyData];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    userInfo = [[UserModel Instance] getUserInfo];
    
    if (userInfo.regUserId != nil || [userInfo.regUserId length] > 0) {
        [self isCollect];
    }
    
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [Tool processLoginNotice:actionSheet andButtonIndex:buttonIndex andNav:self.navigationController andParent:nil];
}

@end
