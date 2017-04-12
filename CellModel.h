//
//  CellModel.h
//  瀑布流
//
//  Created by iMac on 16/12/26.
//  Copyright © 2016年 zws. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseModel.h"

@interface CellModel : BaseModel

@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *imgURL;
@property(nonatomic,assign)CGFloat imgWidth;
@property(nonatomic,assign)CGFloat imgHeight;
@property (nonatomic,strong) NSString *imageContent;
@end
