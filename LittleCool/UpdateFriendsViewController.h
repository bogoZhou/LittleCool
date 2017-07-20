//
//  UpdateFriendsViewController.h
//  Qian
//
//  Created by 周博 on 17/2/28.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "BaseViewController.h"

@protocol ChooseFriendsDelegate <NSObject>
- (void)changeFrom:(NSString *)from content:(NSString *)content;
@end

@interface UpdateFriendsViewController : BaseViewController
@property(nonatomic,assign)id<ChooseFriendsDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *labelUser;

@property (weak, nonatomic) IBOutlet UILabel *labelDate;

@property (nonatomic,strong) NSString *from;

@property (nonatomic,strong) NSString *to;

@property (nonatomic,strong) NSString *friendsId;
@end
