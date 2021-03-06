//
//  ExChangeDetailView.h
//  DaDangJia
//
//  Created by Seven on 15/9/11.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicFull.h"
#import "MWPhotoBrowser.h"

@interface ExChangeDetailView : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UITextFieldDelegate,MWPhotoBrowserDelegate>
{
    NSMutableArray *_photos;
}

@property (nonatomic, retain) NSMutableArray *photos;

@property (weak, nonatomic) TopicFull *topic;
@property (weak, nonatomic) NSString *typeName;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *photoIv;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLb;
@property (weak, nonatomic) IBOutlet UITextView *topicContentTv;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;

@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
- (IBAction)praiseAction:(id)sender;
- (IBAction)commentAction:(id)sender;
- (IBAction)collectAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *phoneLb;

@end