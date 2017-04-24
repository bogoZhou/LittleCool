//
//  SettingViewController.m
//  LittleCool
//
//  Created by 周博 on 17/3/20.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTableViewCell.h"
#import "HelperTableViewCell.h"

#define kCellName @"SettingTableViewCell"
#define kHelperCell @"HelperTableViewCell"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navBarTitle:@"设置"];
    [self navBarbackButton:@"        "];
}


- (void)exit{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否确定退出" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Id"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isVip"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sign" object:nil];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)clear{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定清除缓存吗?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:DocumentsPath];
        for (NSString *fileName in enumerator) {
            [[NSFileManager defaultManager] removeItemAtPath:[DocumentsPath stringByAppendingPathComponent:fileName] error:nil];
        }
        kAlert(@"清除完毕");
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(float)fileSize//计算文件夹下文件的总大小
{
    NSArray* myPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* path = [myPaths objectAtIndex:0];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    float size =0;
    float han = 0;
    NSArray* array = [fileManager contentsOfDirectoryAtPath:path error:nil];
    for(int i = 0; i<[array count]; i++)
    {
        NSString *fullPath = [path stringByAppendingPathComponent:[array objectAtIndex:i]];
        
        BOOL isDir;
        if ( !([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) )
        {
            NSDictionary *fileAttributeDic=[fileManager attributesOfItemAtPath:fullPath error:nil];
            size+= fileAttributeDic.fileSize/ 1024.0/1024.0;
        }
        else
        {
            [self fileSize];
        }
    }
    han = han + size;
    return size;
}

#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellName];
        NSString *sizeStr = [NSString stringWithFormat:@"%.2fMb",[self fileSize]];
        cell.labelSize.text = sizeStr;
        return cell;
    }else if (indexPath.section == 1){
        HelperTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHelperCell];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        cell.textLabel.text = @"退出登录";
        cell.textLabel.font = [UIFont systemFontOfSize:20];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {//清理缓存
        [self clear];
    }else if(indexPath.section == 2){
        [self exit];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        return 10;
    }else{
        return 200;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        return 1;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
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
