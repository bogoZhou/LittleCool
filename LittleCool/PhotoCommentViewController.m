//
//  PhotoCommentViewController.m
//  Qian
//
//  Created by 周博 on 17/2/19.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "PhotoCommentViewController.h"
#import "JTSTextView.h"
#import "BGDatePickerViewController.h"
#import "ChooseAnyUsersViewController.h"
#import "TakePicDelegate.h"

@interface PhotoCommentViewController ()
{
    
}
@property (nonatomic,strong) JTSTextView *textView;
@property (nonatomic, strong) NSMutableArray *chosenImages;
@property (nonatomic,strong) UIImageView *imageview;
@property (nonatomic,strong) NSMutableArray *array;
@property (nonatomic,strong) UIView *BJView;
@property (nonatomic,strong) UserInfoModel *user;

@end

@implementation PhotoCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self UISetting];
    [self getNoti];
    [self creatImgScr];
}

- (void)UISetting{
    _chosenImages = [NSMutableArray array];
    [self rightButtonClick:@"发送" width:50 color:kWechatTabBarColor];
    
    _textView = [[JTSTextView alloc] initWithFrame:CGRectMake(5, 5, kScreenSize.width - 10, _viewText.frame.size.height) fontSize:16];
    [_viewText addSubview:_textView];
    _textView.tintColor = kWechatBlack;
    //    _textView.textViewDelegate = self;
    [self.textView setText:@""];
    
    _labelTime.text  = @"";
}

- (void)rightButtonClick:(NSString *)string width:(CGFloat)width color:(UIColor *)color{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, width, 30)];
    [button setTitle:string forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentRight;
    [button addTarget:self action:@selector(rightNavButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -20;
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,leftItem, nil];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)getNoti{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(choosePerson:) name:@"fashuoshuo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takePicFun:) name:@"pengyouquanTP" object:nil];
}

- (void)takePicFun:(NSNotification *)noti{
    UIImage *image = [UIImage imageWithData:noti.object];
    [self.chosenImages addObject:image];
    [self creatImgScr];
}

#pragma mark - 点击事件
- (void)choosePerson:(NSNotification *)noti{
    _user = [noti.object lastObject];
    _labelName.text = _user.name;
}

- (void)rightNavButtonClick{
//    kAlert(@"发送");
    
    if ([BGFunctionHelper isNULLOfString:_user.name]) {
        kAlert(@"请选择发送人");
        return;
    }
    if ([BGFunctionHelper isNULLOfString:_labelTime.text]) {
        kAlert(@"请选择时间");
        return;
    }
    
    
    
    [[FMDBHelper fmManger] createFriendsTable];
    [[FMDBHelper fmManger] createImagesTable];
    if ([BGFunctionHelper isNULLOfString:_user.Id]) {
        _user = [[[FMDBHelper fmManger] selectDataByTableName:kOthreUserTable] firstObject];
    }
    [[FMDBHelper fmManger] insertFriendsDataByUserId:_user.Id textContent:_textView.text date:_labelTime.text];
    
    FriendsModel *model = [[[FMDBHelper fmManger] selectFriendsWhereValue1:@"" value2:@"" isNeed:NO] lastObject];
    
    for (UIImage *image in self.chosenImages) {
        NSData *imageData = [[NSData alloc] init];
        imageData = UIImagePNGRepresentation(image);
        [[FMDBHelper fmManger] insertFriendsImagesDataByFriendsId:model.Id image:imageData];
    }
    NSArray *array = [[FMDBHelper fmManger] selectFriendsImageWhereValue1:@"friendsId" value2:model.Id isNeed:YES];

    NSLog(@"%@",array);
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)chooseAddressButtonClick:(UIButton *)sender {
    kAlert(@"正在开发中...");
    [self.view endEditing:YES];
}

- (IBAction)choosePersonButtonClick:(UIButton *)sender {
    [self.view endEditing:YES];
//    kAlert(@"选择发送人");
    UIStoryboard *storyboard = kWechatStroyboard;
    ChooseAnyUsersViewController *chooseAnyOneVC = [storyboard instantiateViewControllerWithIdentifier:@"ChooseAnyUsersViewController"];
    chooseAnyOneVC.chooseNum = @"1";
    chooseAnyOneVC.notiName = @"fashuoshuo";
    [self.navigationController pushViewController:chooseAnyOneVC animated:YES];
}

- (IBAction)chooseDateButtonClick:(UIButton *)sender {
    [self.view endEditing:YES];
//    kAlert(@"选择发送时间");
    BGDatePickerViewController * picker = [[BGDatePickerViewController alloc] init];
    BGDatePickerAction * action = [BGDatePickerAction actionWithTitle:@"" handler:^(BGDatePickerAction *action) {
        _labelTime.text = action.titleS;
    }];
    [picker addAction:action];
    [self presentViewController:picker animated:NO completion:nil];
}


#pragma mark - UIActionSheetDelegate

/**
 *  从相册选择
 */
-(void)LocalPhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //资源类型为图片库
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

/**
 *  拍照
 */
-(void)takePhoto{
    //资源类型为照相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        //资源类型为照相机
        picker.sourceType = sourceType;
        
        picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:picker animated:YES completion:nil];
    }else {
        kAlert(@"该设备无摄像头");
    }
}


- (void)creatImgScr {
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%ld",9-self.chosenImages.count] forKey:@"CHOSENUM"];
    
    UIView *BJView = [[UIView alloc] init];
    BJView.tag = 500;
    CGRect workingFrame = CGRectMake(self.view.center.x-35, self.view.center.y-35, 70, 70);
    workingFrame.origin.x = 5;
    workingFrame.origin.y = 5;
    for (int i = 0; i<self.chosenImages.count; i++) {
        UIImage *image = self.chosenImages[i];
        
//        NSURL *url = [NSURL URLWithString:self.chosenImages[i]];
//        UIImage *image = [UIImage imageWithContentsOfFile:self.chosenImages[i]];
//        UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:url]];
        _imageview = [[UIImageView alloc] initWithImage:image];
        _imageview.tag = 200+i;
        _imageview.layer.masksToBounds = YES;
        [_imageview setContentMode:UIViewContentModeScaleToFill];
        _imageview.frame = workingFrame;
        
        UIButton *deleteButton = [BGControl creatButtonWithFrame:CGRectMake(_imageview.frame.origin.x + 62 - 8, _imageview.frame.origin.y, 16, 16) target:self sel:@selector(deletImg:) tag:100+i image:@"delete_member_tip.png" isBackgroundImage:NO title:nil isLayer:NO cornerRadius:0];
        //        deleteButton.backgroundColor = kBlackColor;
        [BJView addSubview:_imageview];
        
        [BJView addSubview:deleteButton];
        
        
        workingFrame.origin.x = workingFrame.origin.x + 5 + workingFrame.size.width;
    }
    
    UIButton *addButton = [BGControl creatButtonWithFrame:CGRectMake(workingFrame.origin.x, 5, 70, 70) target:self sel:@selector(addPicButtonClick:) tag:0 image:@"actionbar_add_icon.png" isBackgroundImage:NO title:nil isLayer:YES cornerRadius:kButtonCornerRadius];
    [BJView addSubview:addButton];
    
    BJView.frame = CGRectMake(0, 0, (self.chosenImages.count + 1)*75, workingFrame.size.height);
    if (self.chosenImages.count >= 9) {
        [_scrollViewImage setContentSize:CGSizeMake(BJView.frame.size.width - 75, workingFrame.size.height)];
    }else{
        [_scrollViewImage setContentSize:CGSizeMake(BJView.frame.size.width, workingFrame.size.height)];
    }
    [_scrollViewImage addSubview:BJView];
}

/**
 *  添加图片
 */
- (void)addPicButtonClick:(UIButton *)sender {
    //    [self Alert:@"点击添加图片按钮"];
    [self.view endEditing:YES];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"使用相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self takePhoto];
        [[TakePicDelegate defaultManager] jumpAlarmInViewController:self notiName:@"pengyouquanTP"];
    }];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"打开相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] init];
        
        elcPicker.maximumImagesCount = 9; //Set the maximum number of images to select to 100
//        elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
//        elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
//        elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
//        elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]; //Supports image and movie types
        
        elcPicker.imagePickerDelegate = self;
        [self presentViewController:elcPicker animated:YES completion:nil];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:cameraAction];
    [alert addAction:photoAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}


- (void)deletImg:(UIButton *)button {
    NSInteger viewTag = button.tag - 100;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您确定要删除图片吗?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction  = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sureAction  = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _array =  [NSMutableArray arrayWithArray:self.chosenImages];
        [_array removeObjectAtIndex:viewTag];
        [self deletImgView];
    }];
    [alert addAction:cancelAction];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)deletImgView {
    self.chosenImages = [NSMutableArray arrayWithArray:_array];
    for (UIView *view in [self.scrollViewImage subviews]) {
        if (view.tag ==500) {
            [view removeFromSuperview];
        }
    }
    [self creatImgScr];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info{
    NSLog(@"%@",info);
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    
    UIImage *image;
    if (self.chosenImages.count > 8) {
        kAlert(@"图片最多只能发送9张哦!");
    }
    else{
        for (NSDictionary *dict in info) {
            image  = [dict objectForKey:UIImagePickerControllerOriginalImage];
//            NSString *image = [dict objectForKey:UIImagePickerControllerReferenceURL];
            [self.chosenImages addObject:image];
            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%ld",9-self.chosenImages.count] forKey:@"CHOSENUM"];
        }
    }
    [self creatImgScr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
