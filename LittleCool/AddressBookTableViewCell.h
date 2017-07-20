//
//  AddressBookTableViewCell.h
//  Qian
//
//  Created by 周博 on 17/2/10.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressBookTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViewUnderLine;

@property (weak, nonatomic) IBOutlet UILabel *labelName;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewheader;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewSelect;

- (void)showImageSelect:(UIImage *)image;
@end
