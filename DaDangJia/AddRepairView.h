//
//  AddRepairView.h
//  DaDangJia
//
//  Created by Seven on 15/8/27.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddRepairView : UIViewController<UITextViewDelegate, UIActionSheetDelegate, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UITextView *contentTf;
@property (weak, nonatomic) IBOutlet UILabel *contentLengthLb;
@property (weak, nonatomic) IBOutlet UIButton *repairBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)repairAction:(id)sender;
- (IBAction)pushRepairCostView:(id)sender;

@end
