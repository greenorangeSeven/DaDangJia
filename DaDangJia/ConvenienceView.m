//
//  ConvenienceView.m
//  DaDangJia
//
//  Created by Seven on 15/8/19.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "ConvenienceView.h"
#import "ConvenienceTypeCell.h"
#import "ConvenienceShopView.h"
#import "UIImageView+WebCache.h"

@interface ConvenienceView ()

@end

@implementation ConvenienceView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect viewFrame = self.view.frame;
    viewFrame.size.height = self.frameView.frame.size.height;
    viewFrame.size.width = self.frameView.frame.size.width;
    self.view.frame = viewFrame;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[ConvenienceTypeCell class] forCellWithReuseIdentifier:ConvenienceTypeCellIdentifier];
    
    [self findShopTypeAll];
}

//取数方法
- (void)findShopTypeAll
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        [Tool showHUD:@"加载中..." andView:self.view andHUD:hud];
        //生成获取便民服务类型URL
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:@"1" forKey:@"classType"];
        NSString *findShopTypeAllUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_findShopType] params:param];
        
        [[AFOSCClient sharedClient]getPath:findShopTypeAllUrl parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       @try {
                                           types = [Tool readJsonStrToShopTypeArray:operation.responseString];
                                           int n = [types count] % 4;
                                           if(n > 0)
                                           {
                                               for (int i = 0; i < 4 - n; i++) {
                                                   ShopType *r = [[ShopType alloc] init];
                                                   r.shopTypeId = @"-1";
                                                   [types addObject:r];
                                               }
                                           }
                                           [self.collectionView reloadData];
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally {
                                           if (hud != nil) {
                                               [hud hide:YES];
                                           }
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
    return [types count];
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ConvenienceTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ConvenienceTypeCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"ConvenienceTypeCell" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[ConvenienceTypeCell class]]) {
                cell = (ConvenienceTypeCell *)o;
                break;
            }
        }
    }
    NSInteger row = [indexPath row];
    ShopType *type = [types objectAtIndex:row];

    cell.titleLb.text = type.shopTypeName;
    [cell.imageIv sd_setImageWithURL:[NSURL URLWithString:type.imgUrlFull] placeholderImage:[UIImage imageNamed:@"default_head.png"]];
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
        return CGSizeMake(width/3-1, 130);
   
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
    ShopType *shopType = [types objectAtIndex:[indexPath row]];
    if (shopType != nil) {
        if ([shopType.shopTypeId isEqualToString:@"-1"]) {
            return;
        }
        ConvenienceShopView *shopView = [[ConvenienceShopView alloc] init];
        shopView.type = shopType;
        [self.navigationController pushViewController:shopView animated:YES];
    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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
