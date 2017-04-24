//
//  PhotoCommentViewController.h
//  Qian
//
//  Created by 周博 on 17/2/19.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "BaseViewController.h"

@interface PhotoCommentViewController : BaseViewController<ELCImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewText;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewImage;

@property (weak, nonatomic) IBOutlet UILabel *labelName;

@property (weak, nonatomic) IBOutlet UILabel *labelTime;

@end
