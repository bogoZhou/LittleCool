//
//  NewUserViewController.m
//  Qian
//
//  Created by 周博 on 17/2/8.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "NewUserViewController.h"
#import "TakePicDelegate.h"

@interface NewUserViewController ()
{
    
}
@property (nonatomic,strong) NSString *imageStr;

@property (nonatomic,strong) NSMutableDictionary *dictionary;
@end

@implementation NewUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dictionary = [[NSMutableDictionary alloc] init];
    _imageViewHeader.backgroundColor = kClearColor;
    [self wechatRightButtonClick:@"保存"];
    [self getNoti];
    [self chackIsChange];
}

- (void)getNoti{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHeadImage:) name:@"changeNewUserHeaderImage" object:nil];
}

- (void)chackIsChange{
    if (_willChange.integerValue > 0) {
        [self reSettingUI];
    }
}

- (void)reSettingUI{
    [[FMDBHelper fmManger] getFMDBBySQLName:kCreatSQL];
    [[FMDBHelper fmManger] createTableByTableName:kOthreUserTable];
    UserInfoModel *model = [[UserInfoModel alloc] init];
    
    model = [[[FMDBHelper fmManger] selectDataByTableName:kOthreUserTable] firstObject];
//    _imageViewHeader.image = [UIImage imageWithData:model.headImage];
    _imageViewHeader.image = [BGFunctionHelper getImageFromSandBoxByImagePath:model.headImage];
    _textFieldNickName.text = model.name;
    _textFieldWechatNum.text = model.wechatNum;
}

#pragma mark - 点击选择图片按钮

- (void)changeHeadImage:(NSNotification *)noti{
//    _imageStr = noti.object;
    _imageStr = [BGFunctionHelper saveImageToSandBoxByImage:noti.object];
    _imageViewHeader.image = noti.object;
}

- (IBAction)changeHeadImageButtonClick:(UIButton *)sender {
//    kAlert(@"选择图片");
    [[TakePicDelegate defaultManager] jumpAlarmInViewController:self notiName:@"changeNewUserHeaderImage"];
}

- (void)rightNavButtonClick{
    
    if ([BGFunctionHelper isNULLOfString:_textFieldNickName.text]) {
        kAlert(@"请输入昵称");
        return;
    }
    if ([BGFunctionHelper isNULLOfString:_textFieldWechatNum.text]) {
        kAlert(@"请输入微信号");
        return;
    }
    if (!_imageViewHeader.image) {
        kAlert(@"请选择头像");
        return;
    }
    
    [[FMDBHelper fmManger] getFMDBBySQLName:kCreatSQL];
//    [[FMDBHelper fmManger] createTableByTableName:kUserTable];
    [[FMDBHelper fmManger] createTableByTableName:kOthreUserTable];


    
    if (_willChange.integerValue > 0) {//更改用户信息
        [[FMDBHelper fmManger] updateDataByTableName:kOthreUserTable TypeName:@"name" typeValue0:_textFieldNickName.text typeValue1:@"Id" typeValue2:@"1"];
        
        [[FMDBHelper fmManger] updateDataByTableName:kOthreUserTable TypeName:@"wechatNum" typeValue0:_textFieldWechatNum.text typeValue1:@"Id" typeValue2:@"1"];
        
        [[FMDBHelper fmManger] updateDataByTableName:kOthreUserTable TypeName:@"headImage" typeValue0:[BGFunctionHelper saveImageToSandBoxByImage:_imageViewHeader.image] typeValue1:@"Id" typeValue2:@"1"];
        
        
        [[FMDBHelper fmManger] updateDataByTableName:kOthreUserTable TypeName:@"name" typeValue0:_textFieldNickName.text typeValue1:@"Id" typeValue2:@"1"];
        
        [[FMDBHelper fmManger] updateDataByTableName:kOthreUserTable TypeName:@"wechatNum" typeValue0:_textFieldWechatNum.text typeValue1:@"Id" typeValue2:@"1"];
        
        [[FMDBHelper fmManger] updateDataByTableName:kOthreUserTable TypeName:@"headImage" typeValue0:[BGFunctionHelper saveImageToSandBoxByImage:_imageViewHeader.image] typeValue1:@"Id" typeValue2:@"1"];
        
//        UserInfoModel *user = [[[FMDBHelper fmManger] selectDataByTableName:kOthreUserTable] firstObject];
//        NSLog(@"%@",user.name);
//        NSMutableArray *array = [[FMDBHelper fmManger] selectDataByTableName:kUserTable];
//        NSLog(@"%@",array);
        [self.navigationController popViewControllerAnimated:YES];
    }else{//创建新用户 -> 添加到所有用户表
        [[FMDBHelper fmManger] insertOtherUserInfoDataByTableName:kOthreUserTable Id:@"1" name:_textFieldNickName.text headImage:[BGFunctionHelper saveImageToSandBoxByImage:_imageViewHeader.image] wechatNum:_textFieldWechatNum.text money:@"0"];
        NSMutableArray *array = [[FMDBHelper fmManger] selectDataByTableName:kOthreUserTable];
        NSLog(@"%@",array);
        kAlert(@"新用户已添加");
    }
}

-(void)setImage:(UIImage *)image forKey:(NSString *)key{
    
    [self.dictionary setObject:image forKey:key];
    //获取保存图片的全路径
    NSString *path = [self imagePathForKey:key];
    //从图片提取JPEG格式的数据,第二个参数为图片压缩参数
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    //以PNG格式提取图片数据
    //NSData *data = UIImagePNGRepresentation(image);
    
    //将图片数据写入文件
    [data writeToFile:path atomically:YES];
}

-(UIImage *)imageForKey:(NSString *)key{
    //return [self.dictionary objectForKey:key];
    UIImage *image = [self.dictionary objectForKey:key];
    if (!image) {
        NSString *path = [self imagePathForKey:key];
        image = [UIImage imageWithContentsOfFile:path];
        if (image) {
            
            [self.dictionary setObject:image forKey:key];
        }else{
            
            NSLog(@"Error: unable to find %@", [self imagePathForKey:key]);
        }
    }
    return image;
}

-(NSString *)imagePathForKey:(NSString *)key{
    
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:key];
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
