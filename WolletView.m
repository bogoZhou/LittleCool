//
//  WolletView.m
//  Qian
//
//  Created by 周博 on 17/2/8.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "WolletView.h"

@implementation WolletView

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatViewWithImage:image title:title];
    }
    return self;
}

- (void)creatViewWithImage:(UIImage *)image title:(NSString *)title{
    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 12.5, self.sizeHeight/2 - 25, 25, 25)];
    headImageView.image = image;
    headImageView.layer.masksToBounds = YES;
    headImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:headImageView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, headImageView.frame.size.height + headImageView.frame.origin.y + 15, self.frame.size.width, 15)];
    nameLabel.text = title;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:nameLabel];
}

@end
