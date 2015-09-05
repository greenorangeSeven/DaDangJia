//
//  ReadilyView.m
//  DaDangJia
//
//  Created by Seven on 15/8/30.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "ReadilyView.h"
#import "UploadImageCell.h"
#import "UIImageView+WebCache.h"

#define ORIGINAL_MAX_WIDTH 640.0f

@interface ReadilyView ()
{
    UserInfo *userInfo;
    NSMutableArray *topicImageArray;
    int selectCaremaIndex;
    NSString *typeId;
}

@end

@implementation ReadilyView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, self.view.frame.size.height);
    
    CGRect viewFrame = self.view.frame;
    viewFrame.size.height = self.frameView.frame.size.height;
    viewFrame.size.width = self.frameView.frame.size.width;
    self.view.frame = viewFrame;
    
    CGRect scrollFrame = self.scrollView.frame;
    scrollFrame.size.height = self.frameView.frame.size.height;
    scrollFrame.size.width = self.frameView.frame.size.width;
    self.scrollView.frame = viewFrame;
    
    self.submitBtn.layer.cornerRadius=self.submitBtn.frame.size.height/2;
    
    typeId = @"1";
    [self.type6Btn setBackgroundColor:[Tool getColorForMain]];
    
    self.contentTf.delegate = self;
    
    userInfo = [[UserModel Instance] getUserInfo];
    
    topicImageArray = [[NSMutableArray alloc] initWithCapacity:4];
    UIImage *myImage = [UIImage imageNamed:@"addrepairimg"];
    [topicImageArray addObject:myImage];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[UploadImageCell class] forCellWithReuseIdentifier:UploadImageCellIdentifier];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView == self.contentTf) {
        int number = [textView.text length];
        self.contentLengthLb.text = [NSString stringWithFormat:@"%d", number];
        if (number > 140) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"内容字数不能大于140" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            textView.text = [textView.text substringToIndex:140];
        }
    }
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [topicImageArray count];
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
    int row = [indexPath row];
    UIImage *repairImage = [topicImageArray objectAtIndex:row];
    cell.repairIv.image = repairImage;
    
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
    int row = [indexPath row];
    if (row == [topicImageArray count] -1) {
        UIActionSheet *cameraSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"拍照", @"从相册中选取", nil];
        cameraSheet.tag = 0;
        [cameraSheet showInView:self.view];
    }
    else
    {
        UIActionSheet *delSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                              delegate:self
                                                     cancelButtonTitle:@"取消"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:@"删除", nil];
        delSheet.tag = 2;
        selectCaremaIndex = row;
        [delSheet showInView:self.view];
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

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 0) {
        if (buttonIndex == 0) {
            // 拍照
            if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
                controller.delegate = self;
                [self presentViewController:controller
                                   animated:YES
                                 completion:^(void){
                                     NSLog(@"Picker View Controller is presented");
                                 }];
            }
        }
        else if (buttonIndex == 1) {
            // 从相册中选取
            if ([self isPhotoLibraryAvailable]) {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
                controller.delegate = self;
                [self presentViewController:controller
                                   animated:YES
                                 completion:^(void){
                                     NSLog(@"Picker View Controller is presented");
                                 }];
            }
        }
    }
    if (actionSheet.tag == 2) {
        if (buttonIndex == 0) {
            [topicImageArray removeObjectAtIndex:selectCaremaIndex];
            [self.collectionView reloadData];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        UIImage *smallImage = [self imageByScalingToMaxSize:portraitImg];
        [topicImageArray insertObject:smallImage atIndex:[topicImageArray count] -1];
        [self.collectionView reloadData];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}
//拍照处理

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)type1Action:(id)sender {
    NSArray *typeBtns = [self.typeView subviews];
    for (UIView *btn in typeBtns) {
        if ([btn isKindOfClass:[UIButton class]])
        {
            [btn setBackgroundColor:nil];
        }
    }
    typeId = @"5";
    [self.type1Btn setBackgroundColor:[Tool getColorForMain]];
}

- (IBAction)type2Action:(id)sender {
    NSArray *typeBtns = [self.typeView subviews];
    for (UIView *btn in typeBtns) {
        if ([btn isKindOfClass:[UIButton class]])
        {
            [btn setBackgroundColor:nil];
        }
    }
    typeId = @"4";
    [self.type2Btn setBackgroundColor:[Tool getColorForMain]];
}

- (IBAction)type3Action:(id)sender {
    NSArray *typeBtns = [self.typeView subviews];
    for (UIView *btn in typeBtns) {
        if ([btn isKindOfClass:[UIButton class]])
        {
            [btn setBackgroundColor:nil];
        }
    }
    typeId = @"0";
    [self.type3Btn setBackgroundColor:[Tool getColorForMain]];
}

- (IBAction)type4Action:(id)sender {
    NSArray *typeBtns = [self.typeView subviews];
    for (UIView *btn in typeBtns) {
        if ([btn isKindOfClass:[UIButton class]])
        {
            [btn setBackgroundColor:nil];
        }
    }
    typeId = @"3";
    [self.type4Btn setBackgroundColor:[Tool getColorForMain]];
}

- (IBAction)type5Action:(id)sender {
    NSArray *typeBtns = [self.typeView subviews];
    for (UIView *btn in typeBtns) {
        if ([btn isKindOfClass:[UIButton class]])
        {
            [btn setBackgroundColor:nil];
        }
    }
    typeId = @"2";
    [self.type5Btn setBackgroundColor:[Tool getColorForMain]];
}

- (IBAction)type6Action:(id)sender {
    NSArray *typeBtns = [self.typeView subviews];
    for (UIView *btn in typeBtns) {
        if ([btn isKindOfClass:[UIButton class]])
        {
            [btn setBackgroundColor:nil];
        }
    }
    typeId = @"0";
    [self.type6Btn setBackgroundColor:[Tool getColorForMain]];
}

- (IBAction)submitAction:(id)sender {
    NSString *contentStr = self.contentTf.text;
    if (contentStr == nil || [contentStr length] == 0) {
        [Tool showCustomHUD:@"请填写内容" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    //生成新增报修Sign
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:typeId forKey:@"typeId"];
    [param setValue:contentStr forKey:@"content"];
    [param setValue:userInfo.regUserId forKey:@"userId"];
    [param setValue:userInfo.defaultUserHouse.cellId forKey:@"cellId"];
    NSString *addTopicSign = [Tool serializeSign:[NSString stringWithFormat:@"%@%@", api_base_url, api_addTopicInfo] params:param];
    
    NSString *addTopicUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_addTopicInfo];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:addTopicUrl]];
    [request setUseCookiePersistence:[[UserModel Instance] isLogin]];
    [request setTimeOutSeconds:30];
    [request setPostValue:Appkey forKey:@"accessId"];
    [request setPostValue:addTopicSign forKey:@"sign"];
    [request setPostValue:typeId forKey:@"typeId"];
    [request setPostValue:contentStr forKey:@"content"];
    [request setPostValue:userInfo.regUserId forKey:@"userId"];
    [request setPostValue:userInfo.defaultUserHouse.cellId forKey:@"cellId"];
    for (int i = 0 ; i < [topicImageArray count] - 1; i++) {
        UIImage *topicImage = [topicImageArray objectAtIndex:i];
        [request addData:UIImageJPEGRepresentation(topicImage, 0.8f) withFileName:@"img.jpg" andContentType:@"image/jpeg" forKey:[NSString stringWithFormat:@"pic%d", i]];
    }
    request.tag = 1;
    
    request.delegate = self;
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestSubmit:)];
    [request startAsynchronous];
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"发布中..." andView:self.view andHUD:request.hud];
}

- (void)requestSubmit:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:YES];
    }
    
    [request setUseCookiePersistence:YES];
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
        self.navigationItem.rightBarButtonItem.enabled = YES;
        return;
    }
    else
    {
        self.contentTf.text = @"";
        self.contentLengthLb.text = @"0";
        [topicImageArray removeAllObjects];
        UIImage *myImage = [UIImage imageNamed:@"addrepairimg"];
        [topicImageArray addObject:myImage];
        [self.collectionView reloadData];
        [Tool showCustomHUD:@"发布完成" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
    }
}

@end
