//
//  FeeTableView.m
//  DaDangJia
//
//  Created by Seven on 15/8/28.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "FeeTableView.h"
#import "FeeItemCell.h"
#import "SSCheckBoxView.h"
#import "PayedFeeView.h"
#import "IQKeyboardManager/KeyboardManager.framework/Headers/IQKeyboardManager.h"
#import <AlipaySDK/AlipaySDK.h>

@interface FeeTableView ()
{
    NSMutableArray *billData;
    UserInfo *userInfo;
    double totalMoney;
    NSString *payTypeId;
}

@property (nonatomic, strong) UIPickerView *payTypePicker;

@property (nonatomic, strong) NSArray *payTypeNameArray;
@property (nonatomic, strong) NSArray *payTypeIdArray;

@end

@implementation FeeTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.payTypeNameArray = @[@"支付宝支付"];
    self.payTypeIdArray = @[@"0"];
    
    userInfo = [[UserModel Instance] getUserInfo];
    
    payTypeId = @"0";
    
    self.payTypePicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    self.payTypePicker.showsSelectionIndicator = YES;
    self.payTypePicker.delegate = self;
    self.payTypePicker.dataSource = self;
    self.payTypePicker.tag = 1;
    self.payTypeTf.inputView = self.payTypePicker;
    self.payTypeTf.delegate = self;
    
    totalMoney = 0.00;
    
    self.payfeeBtn.layer.cornerRadius=self.payfeeBtn.frame.size.height/2;
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle: @"已缴查询" style:UIBarButtonItemStyleBordered target:self action:@selector(queryPayedAction:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //    设置无分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    SSCheckBoxView *cb = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(12, 59, 30, 30) style:kSSCheckBoxViewStyleGreen checked:NO];
    [cb setStateChangedBlock:^(SSCheckBoxView *cbv) {
        if (cbv.checked) {
            for (Bill *bill in billData) {
                bill.ischeck = YES;
            }
        }
        else
        {
            for (Bill *bill in billData) {
                bill.ischeck = NO;
            }
        }
        [self totalSelectMoney];
        [self.tableView reloadData];
    }];
    [self.operationView addSubview:cb];
    
    [self findMyBill];
}

- (void)queryPayedAction:(id)sender
{
    PayedFeeView *payedView = [[PayedFeeView alloc] init];
    payedView.typeId = self.typeId;
    [self.navigationController pushViewController:payedView animated:YES];
}

#pragma mark -
#pragma mark Picker Data Source Methods

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 1)
    {
        return [self.payTypeNameArray count];
    }
    else
    {
        return 0;
    }
}

#pragma mark Picker Delegate Methods
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 1)
    {
        return [self.payTypeNameArray objectAtIndex:row];;
    }
    else
    {
        return nil;
    }
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (thePickerView.tag == 1)
    {
        self.payTypeTf.text = [self.payTypeNameArray objectAtIndex:row];
        payTypeId = [self.payTypeIdArray objectAtIndex:row];
    }
}

- (UIToolbar *)keyboardToolBar:(NSInteger)fieldIndex
{
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    [toolBar sizeToFit];
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] init];
    doneButton.tag = fieldIndex;
    doneButton.title = @"完成";
    doneButton.style = UIBarButtonItemStyleDone;
    doneButton.action = @selector(doneClicked:);
    doneButton.target = self;
    
    
    [toolBar setItems:[NSArray arrayWithObjects:spacer, doneButton, nil]];
    return toolBar;
}

- (void)doneClicked:(UITextField *)sender
{
    [self.payTypeTf resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.inputAccessoryView = [self keyboardToolBar:textField.tag];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

- (void)totalSelectMoney
{
    totalMoney = 0.00;
    for (Bill *bill in billData) {
        if (bill.ischeck) {
            totalMoney += bill.totalMoney;
        }
    }
    self.totalMoneyLb.text = [NSString stringWithFormat:@"本次合计：%0.2f元", totalMoney];
}

- (void)findMyBill
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        //查询指定房间所绑定的用户信息
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:userInfo.defaultUserHouse.numberId forKey:@"numberId"];
        [param setValue:self.typeId forKey:@"typeId"];
        [param setValue:@"1000" forKey:@"countPerPages"];
        [param setValue:@"1" forKey:@"pageNumbers"];
        [param setValue:@"0" forKey:@"stateId"];
        
        NSString *findBillDetailsUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_findBillDetailsByPage] params:param];
        [[AFOSCClient sharedClient]getPath:findBillDetailsUrl parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       @try {
                                           [billData removeAllObjects];
                                           billData = [Tool readJsonStrToBillArray:operation.responseString];
                                           [self.tableView reloadData];
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
    return billData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 85.0;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    cell.backgroundColor = [Tool getBackgroundColor];
}

//列表数据渲染
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeeItemCell *cell = [tableView dequeueReusableCellWithIdentifier:FeeItemCellIdentifier];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"FeeItemCell" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[FeeItemCell class]]) {
                cell = (FeeItemCell *)o;
                break;
            }
        }
    }
    NSInteger row = [indexPath row];
    Bill *bill = [billData objectAtIndex:row];
    
    cell.stateLb.layer.masksToBounds=YES;
    cell.stateLb.layer.cornerRadius=cell.stateLb.frame.size.height/2;
    
    cell.titleLb.text = bill.billName;
    cell.totalMoneyLb.text = [NSString stringWithFormat:@"%0.2f", bill.totalMoney];
    
    SSCheckBoxView *cb = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(12, 2, 30, 30) style:kSSCheckBoxViewStyleGreen checked:bill.ischeck];
    cb.tag = row;
    [cb setStateChangedBlock:^(SSCheckBoxView *cbv) {
        if (cbv.checked) {
            Bill *bill = [billData objectAtIndex:cbv.tag];
            bill.ischeck = YES;
        }
        else
        {
            Bill *bill = [billData objectAtIndex:cbv.tag];
            bill.ischeck = NO;
            
        }
        [self totalSelectMoney];
    }];
    [cell addSubview:cb];
    return cell;
}

//表格行点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    Bill *bill = [fees objectAtIndex:row];
//    if (bill && bill.stateId == 0) {
//        PayFeeDetailView *payDetail = [[PayFeeDetailView alloc] init];
//        payDetail.bill = bill;
//        [self.navigationController pushViewController:payDetail animated:YES];
//    }
    
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

- (IBAction)payfeeAction:(id)sender {
    NSMutableArray *selectBill = [[NSMutableArray alloc] init];
    
    for (Bill *bill in billData) {
        if (bill.ischeck) {
            [selectBill addObject:bill.detailsId];
        }
    }
    
    if ([selectBill count] == 0) {
        [Tool showCustomHUD:@"请选择支付账单" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    
    NSString *billDetailsId = [selectBill componentsJoinedByString:@"-"];
    
    //生成获取广告URL
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
//    [param setValue:(NSString *)selectBill[0] forKey:@"billDetailsId"];
    [param setValue:billDetailsId forKey:@"billDetailsId"];

//    NSString *getADDataUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_createAlipayParams] params:param];
    
    //生成支付宝订单URL
    NSString *createOrderUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_createAlipayParams];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:createOrderUrl]];
    [request setUseCookiePersistence:NO];
    [request setTimeOutSeconds:30];
//    [request setPostValue:(NSString *)selectBill[0] forKey:@"billDetailsId"];
    [request setPostValue:billDetailsId forKey:@"billDetailsId"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestCreate:)];
    [request startAsynchronous];
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"正在支付..." andView:self.view andHUD:request.hud];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud)
    {
        [request.hud hide:NO];
    }
    [Tool showCustomHUD:@"网络连接超时" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
}

- (void)requestCreate:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:YES];
    }
    
    [request setUseCookiePersistence:YES];
    NSData *data = [request.responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    NSString *state = [json objectForKey:@"state"];
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
        NSString *orderStr = [json objectForKey:@"msg"];
        [[AlipaySDK defaultService] payOrder:orderStr fromScheme:@"DaDangJiaAlipay" callback:^(NSDictionary *resultDic)
         {
             NSString *resultState = resultDic[@"resultStatus"];
             if([resultState isEqualToString:ORDER_PAY_OK])
             {
                 [self updatePayedTable];
             }
         }];
    }
}

- (void)updatePayedTable
{
    [Tool showCustomHUD:@"支付成功" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:2];
    [self findMyBill];
}

@end
