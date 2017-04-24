//
//  AddressBookTableViewCell.m
//  Qian
//
//  Created by 周博 on 17/2/10.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "AddressBookTableViewCell.h"
#import "AddressBookViewController.h"

@implementation AddressBookTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    if ([[self viewController] isKindOfClass:[AddressBookViewController class]]) {
        _imageViewSelect.hidden = YES;
    }else{
        _imageViewSelect.hidden = NO;
    }
    
}

- (UIViewController *)viewController {
    UIResponder *next = self.nextResponder;
    do {
        //判断响应者是否为视图控制器
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    } while (next != nil);
    
    return nil;
}

- (void)showImageSelect:(UIImage *)image{
    _imageViewSelect.image = image;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
