//
//  ModifyHouseView.m
//  DaDangJia
//
//  Created by Seven on 15/8/24.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "ModifyHouseView.h"
#import "City.h"
#import "Community.h"
#import "Building.h"
#import "HouseNum.h"
#import "IQKeyboardManager/KeyboardManager.framework/Headers/IQKeyboardManager.h"

@interface ModifyHouseView ()
{
    NSString *houseNumId;
    UserInfo *userInfo;
    UIBarButtonItem *rightBtn;
}

@property NSInteger pickerSelectRow;

@property (nonatomic, strong) NSArray *fieldArray;

@property (nonatomic, strong) UIPickerView *cityPicker;
@property (nonatomic, strong) UIPickerView *communityPicker;
@property (nonatomic, strong) UIPickerView *buildingPicker;
@property (nonatomic, strong) UIPickerView *houseNumPicker;

@property (nonatomic, strong) NSArray *cityArray;
@property (nonatomic, strong) NSArray *communityArray;
@property (nonatomic, strong) NSArray *buildingArray;
@property (nonatomic, strong) NSArray *houseNumArray;

@end

@implementation ModifyHouseView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置地址";
    
    houseNumId = @"";
    
    rightBtn = [[UIBarButtonItem alloc] initWithTitle: @"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(saveAction:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    userInfo = [[UserModel Instance] getUserInfo];
    
    self.fieldArray = @[self.cityTf, self.communityTf, self.buildingTf, self.houseNumTf];
    
    self.cityTf.tag = 1;
    self.cityTf.delegate = self;
    
    self.communityTf.tag = 2;
    self.communityTf.delegate = self;
    
    self.buildingTf.tag = 3;
    self.buildingTf.delegate = self;
    
    self.houseNumTf.tag = 4;
    self.houseNumTf.delegate = self;
    
    [self initCityArrayData];
}

- (void)saveAction:(id)sender
{
    if (houseNumId == nil || [houseNumId length] == 0) {
        [Tool showCustomHUD:@"请选择房间" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:2];
        return;
    }
    rightBtn.enabled = NO;
    //生成登陆URL
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:userInfo.regUserId forKey:@"regUserId"];
    [param setValue:houseNumId forKey:@"numberId"];
    NSString *changeUserHouseUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_changeUserHouse] params:param];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:changeUserHouseUrl]];
    [request setUseCookiePersistence:NO];
    [request setTimeOutSeconds:30];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestChange:)];
    [request startAsynchronous];
    
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"修改中..." andView:self.view andHUD:request.hud];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:NO];
    }
    [Tool showCustomHUD:@"网络连接超时" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
    if(rightBtn.enabled == NO)
    {
        rightBtn.enabled = YES;
    }
}

- (void)requestChange:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:YES];
    }
    
    [request setUseCookiePersistence:YES];
    NSLog(@"%@", request.responseString);
    NSData *data = [request.responseString dataUsingEncoding:NSUTF8StringEncoding];
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
        rightBtn.enabled = YES;
        return;
    }
    else
    {
        
        [Tool showCustomHUD:@"修改成功" andView:self.view andImage:nil andAfterDelay:1.1f];
        [self performSelector:@selector(back) withObject:self afterDelay:1.2f];
    }
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initCityArrayData
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        //生成获取城市URL
        NSString *allCityUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_findAllCity] params:nil];
        
        [[AFOSCClient sharedClient]getPath:allCityUrl parameters:Nil
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
                                           self.cityArray = [Tool readJsonStrToCityArray:operation.responseString];
                                           
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

- (void)getCommunityArrayData:(NSString *)cityId
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        //生成获取城市下小区URL
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:cityId forKey:@"cityId"];
        NSString *cellListUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_findCellListByCity] params:param];
        
        [[AFOSCClient sharedClient]getPath:cellListUrl parameters:Nil
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
                                           self.communityArray = [Tool readJsonStrToCommunityArray:operation.responseString];
                                           [self.communityPicker reloadAllComponents];
                                           if ([self.communityArray count] > 0) {
                                               self.communityTf.enabled = YES;
                                           }
                                           else
                                           {
                                               self.communityTf.enabled = NO;
                                               self.communityTf.text = @"暂无楼盘";
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

- (void)getBuildingArrayData:(NSString *)cellId
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        //生成获取城市下小区URL
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:cellId forKey:@"cellId"];
        NSString *cellListUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_findBuildingInfoAll] params:param];
        
        [[AFOSCClient sharedClient]getPath:cellListUrl parameters:Nil
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
                                           self.buildingArray = [Tool readJsonStrToBuildingArray:operation.responseString];
                                           [self.buildingPicker reloadAllComponents];
                                           if ([self.buildingArray count] > 0) {
                                               self.buildingTf.enabled = YES;
                                           }
                                           else
                                           {
                                               self.buildingTf.enabled = NO;
                                               self.buildingTf.text = @"暂无楼栋";
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

- (void)getHouseArrayData:(NSString *)buildingId
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        //生成获取城市下小区URL
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:buildingId forKey:@"buildingId"];
        NSString *houseListUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_findHouseNumberAll] params:param];
        
        [[AFOSCClient sharedClient]getPath:houseListUrl parameters:Nil
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
                                           self.houseNumArray = [Tool readJsonStrToHouseArray:operation.responseString];
                                           [self.houseNumPicker reloadAllComponents];
                                           if ([self.houseNumArray count] > 0) {
                                               self.houseNumTf.enabled = YES;
                                           }
                                           else
                                           {
                                               self.houseNumTf.enabled = NO;
                                               self.houseNumTf.text = @"暂无房间";
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

#pragma mark -
#pragma mark Picker Data Source Methods

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 1)
    {
        return [self.cityArray count];
    }
    else if (pickerView.tag == 2)
    {
        return [self.communityArray count];
    }
    else if (pickerView.tag == 3)
    {
        return [self.buildingArray count];
    }
    else if (pickerView.tag == 4)
    {
        return [self.houseNumArray count];
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
        City *city = (City *)[self.cityArray objectAtIndex:row];
        return city.cityName;
    }
    else if (pickerView.tag == 2)
    {
        Community *community = (Community *)[self.communityArray objectAtIndex:row];
        return community.cellName;
    }
    else if (pickerView.tag == 3)
    {
        Building *building = (Building *)[self.buildingArray objectAtIndex:row];
        return building.buildingName;
    }
    else if (pickerView.tag == 4)
    {
        HouseNum *houseNum = (HouseNum *)[self.houseNumArray objectAtIndex:row];
        return houseNum.numberName;
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
        self.pickerSelectRow = row;
    }
    else if (thePickerView.tag == 2)
    {
        self.pickerSelectRow = row;
    }
    else if (thePickerView.tag == 3)
    {
        self.pickerSelectRow = row;
    }
    else if (thePickerView.tag == 4)
    {
        self.pickerSelectRow = row;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.inputAccessoryView == nil)
    {
        textField.inputAccessoryView = [self keyboardToolBar:textField.tag];
    }
    if (textField.tag == 1)
    {
        self.cityPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
        self.cityPicker.showsSelectionIndicator = YES;
        self.cityPicker.delegate = self;
        self.cityPicker.dataSource = self;
        self.cityPicker.tag = 1;
        textField.inputView = self.cityPicker;
        
        City *city = (City *)[self.cityArray objectAtIndex:0];
        self.cityTf.text = city.cityName;
        self.communityTf.enabled = NO;
        self.buildingTf.enabled = NO;
        self.houseNumTf.enabled = NO;
        self.communityTf.text = @"";
        self.buildingTf.text = @"";
        self.houseNumTf.text = @"";
    }
    else if (textField.tag == 2)
    {
        self.communityPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
        self.communityPicker.showsSelectionIndicator = YES;
        self.communityPicker.delegate = self;
        self.communityPicker.dataSource = self;
        self.communityPicker.tag = 2;
        textField.inputView = self.communityPicker;
        
        Community *community = (Community *)[self.communityArray objectAtIndex:0];
        self.communityTf.text = community.cellName;
        self.buildingTf.enabled = NO;
        self.houseNumTf.enabled = NO;
        self.buildingTf.text = @"";
        self.houseNumTf.text = @"";
    }
    else if (textField.tag == 3)
    {
        self.buildingPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
        self.buildingPicker.showsSelectionIndicator = YES;
        self.buildingPicker.delegate = self;
        self.buildingPicker.dataSource = self;
        self.buildingPicker.tag = 3;
        textField.inputView = self.buildingPicker;
        
        Building *building = (Building *)[self.buildingArray objectAtIndex:0];
        self.buildingTf.text = building.buildingName;
        self.houseNumTf.enabled = NO;
        self.houseNumTf.text = @"";
    }
    else if (textField.tag == 4)
    {
        self.houseNumPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
        self.houseNumPicker.showsSelectionIndicator = YES;
        self.houseNumPicker.delegate = self;
        self.houseNumPicker.dataSource = self;
        self.houseNumPicker.tag = 4;
        textField.inputView = self.houseNumPicker;
        
        HouseNum *houseNum = (HouseNum *)[self.houseNumArray objectAtIndex:0];
        self.houseNumTf.text = houseNum.numberName;
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

//用户不滑动UIPickerView控件及滑动操作过快解决方法，不滑动默认选定数组第一个，滑动过快由于先处理doneClicked事件才会触发UIPickerView选定事件，所有还判断了当前选定全局变量是否大于控件数组长度处理
- (void)doneClicked:(UITextField *)sender
{
    houseNumId = @"";
    if (sender.tag == 1)
    {
        City *city = (City *)[self.cityArray objectAtIndex:self.pickerSelectRow];
        self.cityTf.text = city.cityName;
        [self getCommunityArrayData:city.cityId];
    }
    else if (sender.tag == 2)
    {
        if([self.communityArray count] - 1 < self.pickerSelectRow)
        {
            self.pickerSelectRow = 0;
        }
        Community *community = (Community *)[self.communityArray objectAtIndex:self.pickerSelectRow];
        self.communityTf.text = community.cellName;
        [self getBuildingArrayData:community.cellId];
    }
    else if (sender.tag == 3)
    {
        if([self.buildingArray count] - 1 < self.pickerSelectRow)
        {
            self.pickerSelectRow = 0;
        }
        Building *building = [self.buildingArray objectAtIndex:self.pickerSelectRow];
        self.buildingTf.text = building.buildingName;
        [self getHouseArrayData:building.buildingId];
    }
    else if (sender.tag == 4)
    {
        if([self.houseNumArray count] - 1 < self.pickerSelectRow)
        {
            self.pickerSelectRow = 0;
        }
        HouseNum *houseNum = (HouseNum *)[self.houseNumArray objectAtIndex:self.pickerSelectRow];
        self.houseNumTf.text = houseNum.numberName;
        houseNumId = houseNum.numberId;
    }
    self.pickerSelectRow = 0;
    for (UITextField *field in self.fieldArray)
    {
        [field resignFirstResponder];
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

@end
