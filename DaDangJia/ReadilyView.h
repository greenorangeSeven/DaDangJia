//
//  ReadilyView.h
//  DaDangJia
//
//  Created by Seven on 15/8/30.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReadilyView : UIViewController<UITextViewDelegate, UIActionSheetDelegate, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UITextView *contentTf;
@property (weak, nonatomic) IBOutlet UILabel *contentLengthLb;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) UIView *frameView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *type1Btn;
@property (weak, nonatomic) IBOutlet UIButton *type2Btn;
@property (weak, nonatomic) IBOutlet UIButton *type3Btn;
@property (weak, nonatomic) IBOutlet UIButton *type4Btn;
@property (weak, nonatomic) IBOutlet UIButton *type5Btn;
@property (weak, nonatomic) IBOutlet UIButton *type6Btn;

@property (weak, nonatomic) IBOutlet UIView *typeView;
- (IBAction)type1Action:(id)sender;
- (IBAction)type2Action:(id)sender;
- (IBAction)type3Action:(id)sender;
- (IBAction)type4Action:(id)sender;
- (IBAction)type5Action:(id)sender;
- (IBAction)type6Action:(id)sender;

- (IBAction)submitAction:(id)sender;

@end
