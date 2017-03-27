//
//  BGCollectionView.h
//  LittleCool
//
//  Created by 周博 on 17/3/13.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGCollectionView : UIView

@property (nonatomic,strong) NSMutableArray *dataArray;

- (instancetype)initWithFrame:(CGRect)frame withDataArray:(NSMutableArray *)dataArray;

- (void)reloadDataByArray:(NSMutableArray *)array;

@end
