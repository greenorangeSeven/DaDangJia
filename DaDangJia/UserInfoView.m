//
//  UserInfoView.m
//  DaDangJia
//
//  Created by Seven on 15/8/24.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "UserInfoView.h"
#import "UIImageView+WebCache.h"
#import "ModifyHouseView.h"
#import "ChangePasswordView.h"

#define ORIGINAL_MAX_WIDTH 640.0f

@interface UserInfoView ()
{
    UserInfo *userInfo;
    UIImage *userFace;
    UIBarButtonItem *rightBtn;
}

@end

@implementation UserInfoView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人中心";
    
    [Tool roundTextView:self.uodateFaceBtn andBorderWidth:1.0 andCornerRadius:self.uodateFaceBtn.frame.size.height / 2];
    
    //图片圆形处理
    self.faceBg1View.layer.masksToBounds = YES;
    self.faceBg1View.layer.cornerRadius = self.faceBg1View.frame.size.height / 2;    //最重要的是这个地方要设成imgview高的一半
    
    self.faceBg2View.layer.masksToBounds = YES;
    self.faceBg2View.layer.cornerRadius = self.faceBg2View.frame.size.height / 2;    //最重要的是这个地方要设成imgview高的一半
    
    self.faceIv.layer.masksToBounds = YES;
    self.faceIv.layer.cornerRadius = self.faceIv.frame.size.height / 2;    //最重要的是这个地方要设成imgview高的一半
    
    userInfo = [[UserModel Instance] getUserInfo];
    [self.faceIv sd_setImageWithURL:[NSURL URLWithString:userInfo.photoFull] placeholderImage:[UIImage imageNamed:@"default_head.png"]];
    
    self.nickNameTf.text = userInfo.nickName;
    self.mobileNoLb.text = userInfo.mobileNo;

    rightBtn = [[UIBarButtonItem alloc] initWithTitle: @"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(saveAction:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    //修改密码点击
    UITapGestureRecognizer *changePwdTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePwdTapClick)];
    [self.changePwdView addGestureRecognizer:changePwdTap];
}

- (void)changePwdTapClick
{
    ChangePasswordView *changePwdView = [[ChangePasswordView alloc] init];
    [self.navigationController pushViewController:changePwdView animated:YES];
}

- (void)saveAction:(id)sender
{
    NSString *nickNameStr = self.nickNameTf.text;
    if (nickNameStr == nil || [nickNameStr length] == 0) {
        [Tool showCustomHUD:@"请输入您的昵称" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    rightBtn.enabled = NO;
    //生成修改昵称URL
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:userInfo.regUserId forKey:@"regUserId"];
    [param setValue:nickNameStr forKey:@"nickName"];
    NSString *changeNickNameSign = [Tool serializeSign:[NSString stringWithFormat:@"%@%@", api_base_url, api_modiUserNick] params:param];
    
    NSString *changeNickNameUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_modiUserNick];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:changeNickNameUrl]];
    [request setUseCookiePersistence:[[UserModel Instance] isLogin]];
    [request setTimeOutSeconds:30];
    [request setPostValue:Appkey forKey:@"accessId"];
    [request setPostValue:changeNickNameSign forKey:@"sign"];
    [request setPostValue:userInfo.regUserId forKey:@"regUserId"];
    [request setPostValue:nickNameStr forKey:@"nickName"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestChangeUserNick:)];
    [request startAsynchronous];
    
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"昵称修改..." andView:self.view andHUD:request.hud];
}

- (void)requestChangeUserNick:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:YES];
    }
    rightBtn.enabled = YES;
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
        return;
    }
    else
    {
        userInfo.nickName = self.nickNameTf.text;
        UserModel *userModel = [UserModel Instance];
        [userModel saveUserInfo:userInfo];
        [Tool showCustomHUD:@"修改成功" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    
    [self.addressBtn setTitle:[NSString stringWithFormat:@"%@%@%@", userInfo.defaultUserHouse.cellName, userInfo.defaultUserHouse.buildingName, userInfo.defaultUserHouse.numberName] forState:UIControlStateNormal];
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

- (IBAction)updateFaceAction:(id)sender {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
}

- (IBAction)modifyHouseAction:(id)sender {
    ModifyHouseView *modifyHouse = [[ModifyHouseView alloc] init];
    [self.navigationController pushViewController:modifyHouse animated:YES];
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    self.faceIv.image = editedImage;
    userFace = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        //生成更换头像URL
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:userInfo.regUserId forKey:@"regUserId"];
        NSString *changePhotoSign = [Tool serializeSign:[NSString stringWithFormat:@"%@%@", api_base_url, api_changeUserPhoto] params:param];
        
        NSString *changePhotoUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_changeUserPhoto] params:param];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:changePhotoUrl]];
        [request setUseCookiePersistence:[[UserModel Instance] isLogin]];
        [request setTimeOutSeconds:30];
        [request setPostValue:Appkey forKey:@"accessId"];
        [request setPostValue:changePhotoSign forKey:@"sign"];
        [request setPostValue:userInfo.regUserId forKey:@"regUserId"];
        if (userFace != nil) {
            [request addData:UIImageJPEGRepresentation(userFace, 0.8f) withFileName:@"img.jpg" andContentType:@"image/jpeg" forKey:@"pic"];
        }
        [request setDelegate:self];
        [request setDidFailSelector:@selector(requestFailed:)];
        [request setDidFinishSelector:@selector(requestChangeUserPhoto:)];
        [request startAsynchronous];
        
        request.hud = [[MBProgressHUD alloc] initWithView:self.view];
        [Tool showHUD:@"头像更新..." andView:self.view andHUD:request.hud];
    }];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:NO];
    }
    rightBtn.enabled = YES;
    [Tool showCustomHUD:@"网络连接超时" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
}

- (void)requestChangeUserPhoto:(ASIHTTPRequest *)request
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
        return;
    }
    else
    {
        userFace = nil;
        NSString *userPhoto = [json objectForKey:@"data"];
        [self.faceIv sd_setImageWithURL:[NSURL URLWithString:userPhoto] placeholderImage:[UIImage imageNamed:@"default_head.png"]];
        //        [[UserModel Instance] saveValue:userPhoto ForKey:@"photoFull"];
        userInfo.photoFull = userPhoto;
        UserModel *userModel = [UserModel Instance];
        [userModel saveUserInfo:userInfo];
    }
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 0) {
        if (buttonIndex == 0) {
            // 拍照
            if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
                //使用前置摄像头
                //                if ([self isFrontCameraAvailable]) {
                //                    controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                //                }
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
            
        } else if (buttonIndex == 1) {
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
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
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
@end
