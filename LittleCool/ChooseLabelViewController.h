//
//  ChooseLabelViewController.h
//  LittleCool
//
//  Created by 周博 on 17/3/14.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseLabelViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *viewContent;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSString *buttonTag;

@end
