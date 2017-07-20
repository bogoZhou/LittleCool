//
//  PosterMainTableViewCellTitle.m
//  LittleCool
//
//  Created by 周博 on 2017/5/15.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "PosterMainTableViewCellTitle.h"

@implementation PosterMainTableViewCellTitle

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

//- (void)creatTopLabels{
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, kScreenSize.width - 40, 20)];
//    titleLabel.text = @"微商都在用";
//    titleLabel.font = [UIFont systemFontOfSize:17];
//    titleLabel.textColor = kBlueColor;
//    
//    [self addSubview:titleLabel];
//    
//    
//    
//    CGFloat width = 0;
//    CGFloat lines = 0;
//    for (NSInteger i = 0; i < _labelsArray.count; i ++) {
//        LabelsModel *model = _labelsArray[i];
//        NSString *nameStr = [NSString stringWithFormat:@"  %@  ",model.name];
//        CGSize titleSize = [nameStr boundingRectWithSize:CGSizeMake(kScreenSize.width - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
//        
//        if (width + 15 + titleSize.width + 5 >= kScreenSize.width) {
//            lines ++;
//            width = 0;
//        }
//        
//        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15 + width, titleLabel.allHeight +20+ (20 + 30) *lines,titleSize.width, 30)];
//        width += 15 + titleSize.width;
//        button.backgroundColor = kWhiteColor;
//        button.layer.masksToBounds = YES;
//        button.layer.borderWidth = 1;
//        button.layer.borderColor = [kBlueColor CGColor];
//        button.layer.cornerRadius = 15;
//        [button setTitle:model.name forState:UIControlStateNormal];
//        [button setTitleColor:kBlueColor forState:UIControlStateNormal];
//        button.titleLabel.font = [UIFont systemFontOfSize:16];
//        button.tag = 1000 + i;
//        [button addTarget:self action:@selector(itemsCellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [self addSubview:button];
//    }
//    self.frame = CGRectMake(0, 0, kScreenSize.width,50 + lines * 50 +titleLabel.allHeight + 10);
//}
//
//- (void)itemsCellButtonClick:(UIButton *)button{
//    kAlert(@"点击标签");
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
