//
//  PublicExchangeView.h
//  DaDangJia
//
//  Created by Seven on 15/9/11.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublicExchangeView : UIViewController<UITextViewDelegate, UIActionSheetDelegate, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) NSString *typeId;
@property (weak, nonatomic) NSString *typeName;

@property (weak, nonatomic) IBOutlet UITextView *contentTf;
@property (weak, nonatomic) IBOutlet UILabel *contentLengthLb;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)submitAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *titleTf;
@property (weak, nonatomic) IBOutlet UITextField *telNumTf;

@end