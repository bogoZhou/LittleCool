//
//  TakePicDelegate.m
//  SuperStudent_Teacher
//
//  Created by 周博 on 16/5/11.
//  Copyright © 2016年 BogoZhou. All rights reserved.
//

#import "TakePicDelegate.h"

static TakePicDelegate *defaultManager = nil;

@interface TakePicDelegate ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    NSData *_str;
    NSString *_notiName;
}
@end

@implementation TakePicDelegate

+ (TakePicDelegate *)defaultManager{
    if (!defaultManager)
        defaultManager = [[self allocWithZone:NULL] init];
    return defaultManager;
}

- (void)jumpAlarmInViewController:(UIViewController *)VC notiName:(NSString *)notiName{
    _mainController = VC;
    _notiName = notiName;
    [self creatAlertView];
}

- (void)setMainController:(UIViewController *)mainController notiName:(NSString *)notiName{
    _notiName = notiName;
    _mainController = mainController;
}

- (void)creatAlertView{
    if (kSystemNo < 8.0) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"修改头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"本地相册上传", nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        [actionSheet showInView:_mainController.view];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *takePic = [UIAlertAction actionWithTitle:@"拍照上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //照相动作
            [self takePhoto];
        }];
        UIAlertAction *locationPic = [UIAlertAction actionWithTitle:@"本地相册上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //读取本地照片动作
            [self LocalPhoto];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //取消按钮
        }];
        [alert addAction:takePic];
        [alert addAction:locationPic];
        [alert addAction:cancel];
        
        [_mainController presentViewController:alert animated:YES completion:nil];
    }
}

/**
 *  在iOS8.0以下使用actionSheet
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {//拍照上传
        [self takePhoto];
    }else if (buttonIndex == 1){//本地相册上传
        [self LocalPhoto];
    }
}

#pragma mark - 照相
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
    picker.allowsEditing = NO;
    [_mainController presentViewController:picker animated:YES completion:nil];
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
        picker.allowsEditing = NO;
        //资源类型为照相机
        picker.sourceType = sourceType;
        [_mainController presentViewController:picker animated:YES completion:nil];
    }else {
        [BGControl creatAlertWithString:@"该设备无摄像头" controller:_mainController autoHiddenTime:0];
    }
}

#pragma mark - 保存图片
/**
 *  获取图片地址
 *
 *  @param currentImage
 *  @param imageName
 */
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    UIImage *image = [BGControlHelper fixOrientation:currentImage];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    _str=imageData;
    //    NSLog(@"图pian:%@",self.str);
    // 将图片写入文件
    
    [imageData writeToFile:fullPath atomically:NO];
    
    [self uploadPicture];
}

/**
 *  从相册选择图片
 *
 *  @param picker 相册选择器
 *  @param info   选择的图片信息
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self saveImage:image withName:@"headPic.png"];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"headPic.png"];
    
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    
    
//    [self.headImageView setImage:savedImage];
}

/**
 *  从document取得图片
 *
 *  @param urlStr 图片地址
 *
 *  @return 返回拼接好的图片路径
 */
- (UIImage *)getImage:(NSString *)urlStr
{
    return [UIImage imageWithContentsOfFile:urlStr];
}

/**
 *将图片路径提交后台
 */

- (void)uploadPicture{
//    [[AFClient shareInstance] postOneFileName:_str progressBlock:^(NSProgress *progress) {
//        
//    } success:^(id responseBody) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeHeadImage" object:(NSString *)responseBody];
//    } failure:^(NSError *error) {
//        
//    }] ;
    [[NSNotificationCenter defaultCenter] postNotificationName:_notiName object:_str];
}



@end
