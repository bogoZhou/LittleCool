//
//  HelperTableViewCell.m
//  LittleCool
//
//  Created by 周博 on 2017/4/20.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "HelperTableViewCell.h"

@implementation HelperTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    NSString *helperValue = kShowHelper;
    if (helperValue.integerValue == 0) {
        _switchButton.on = YES;
    }else{
        _switchButton.on = NO;
    }
}

- (IBAction)switchButtonClick:(UISwitch *)sender {
    if (sender.isOn) {
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"helper"];
        
    }else{
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"helper"];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
