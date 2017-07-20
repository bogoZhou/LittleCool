//
//  PosterMainTableViewCellItems.h
//  LittleCool
//
//  Created by 周博 on 2017/5/15.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PosterListModel.h"
#import "MubanModel.h"

@interface PosterMainTableViewCellItems : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;


- (void)showDataWithModel:(PosterListModel *)model;

@end
