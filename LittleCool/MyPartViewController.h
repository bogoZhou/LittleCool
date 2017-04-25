//
//  MyPartViewController.h
//  noteMan
//
//  Created by 周博 on 16/12/9.
//  Copyright © 2016年 BogoZhou. All rights reserved.
//

#import "BaseViewController.h"
#import "IBeaconModel.h"

@interface MyPartViewController : BaseViewController
@property (nonatomic,strong) NSString *message;
@property (nonatomic,strong) NSString *beaconId;

@property (nonatomic,strong) IBeaconModel *ibeaconModel;

//@property (weak, nonatomic) IBOutlet UIButton *buttonOK;

@property (weak, nonatomic) IBOutlet UITextField *textFieldCode;

@property (weak, nonatomic) IBOutlet UITextField *textFieldName;

@property (weak, nonatomic) IBOutlet UIButton *buttonChange;

@property (weak, nonatomic) IBOutlet UIView *viewName;
@end
