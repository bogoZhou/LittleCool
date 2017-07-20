//
//  PosterMainTableViewCellItems.m
//  LittleCool
//
//  Created by 周博 on 2017/5/15.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "PosterMainTableViewCellItems.h"
#import "PosterMainCollectionViewCell.h"
#import "PosterJumpViewController.h"

@interface PosterMainTableViewCellItems ()
{
    
}
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation PosterMainTableViewCellItems

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self DelegateSetting];
}

- (void)DelegateSetting{
    _myCollectionView.delegate = self;
    _myCollectionView.dataSource = self;
//    _myCollectionView.contentSize = CGSizeMake(320 *2, 568);
}

- (void)showDataWithModel:(PosterListModel *)model{
    _dataArray = [NSMutableArray array];
    for (NSDictionary *dic in model.muban_data) {
        MubanModel *mubanModel = [[MubanModel alloc] init];
        [mubanModel setValuesForKeysWithDictionary:dic];
        [_dataArray addObject:mubanModel];
    }
    [_myCollectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString * identifierCell =@"PosterMainCollectionViewCell";
    
    MubanModel *model = _dataArray[indexPath.row];
    
    PosterMainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCell forIndexPath:indexPath];
    [cell.imageViewHeader sd_setImageWithURL:[NSURL URLWithString:model.preview] placeholderImage:kDefaultHeadImage];
    
    return cell;
}

//设置cell大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    MubanModel *model = _dataArray[indexPath.row];
    if (model.scale.integerValue == 38) {
        return CGSizeMake(300, 300);
    }else{
        return CGSizeMake(155, 300);
    }
}

//设置间隔
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MubanModel *model = _dataArray[indexPath.row];

    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            UIViewController *superVC = (UIViewController *)nextResponder;
            
            UIStoryboard *storyboard = kPosterStoryboard;
            
            PosterJumpViewController * posterJumpVC = [storyboard instantiateViewControllerWithIdentifier:@"PosterJumpViewController"];
            posterJumpVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
            posterJumpVC.mubanModel = model;
            [superVC presentViewController:posterJumpVC animated:YES completion:nil];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
