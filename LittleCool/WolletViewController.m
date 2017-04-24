//
//  WolletViewController.m
//  Qian
//
//  Created by 周博 on 17/2/8.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "WolletViewController.h"
#import "WolletView.h"
#import "LooseChangeViewController.h"

static float plas = 3.5/5;
static float other = 4.0/5;

@interface WolletViewController ()
{
}
@property (nonatomic,strong) WolletView *wolletView;
@property (nonatomic,strong) NSArray *imageArray0;
@property (nonatomic,strong) NSArray *imageArray1;

@property (nonatomic,strong) NSArray *nameArray0;
@property (nonatomic,strong) NSArray *nameArray1;

@end

@implementation WolletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navBarbackButton:@"我"];

    [self firstStept];
    [self UISetting];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self UISetting];
}

- (void)firstStept{
    _imageArray0 = @[@"mianduimianhongbao.png",@"shoujichongzhi",@"licaitong",@"Qbichongzhi",@"shenghuojiaofei",@"chengshifuwu",@"xinyongkahuandai",@"tengxungongyi",@""];
    _imageArray1 = @[@"didichuxing",@"huochepiaojipiao",@"jiudian",@"meituanwaimai",@"58daojia",@"meilishuo",@"jingdongyouxuan",@"dianyingyanchusaishi",@"chihewanle"];
    
    _nameArray0 = @[@"面对面红包",@"手机充值",@"理财通",@"Q币充值",@"生活缴费",@"城市服务",@"信用卡还款",@"腾讯公益",@""];
    _nameArray1 = @[@"滴滴出行",@"火车票机票",@"酒店",@"美团外卖",@"58到家",@"美丽说",@"京东优选",@"电影演出赛事",@"吃喝玩乐"];
}

- (void)UISetting{
    _layoutWidth.constant = kScreenSize.width;
    
    [self creatWolletView:_view0 images:_imageArray0 titles:_nameArray0];
    _layoutView0.constant = kScreenSize.width * 4/5 ;
    
    [self creatWolletView:_view1 images:_imageArray1 titles:_nameArray1];
    _layoutView1.constant = kScreenSize.width * 4/5 ;
    

    [[FMDBHelper fmManger] getFMDBBySQLName:kCreatSQL];
    [[FMDBHelper fmManger] createTableByTableName:kOthreUserTable];
    
    UserInfoModel *model = [[[FMDBHelper fmManger] selectDataByTableName:kOthreUserTable] firstObject];
    
    _labelMoney.text = [NSString stringWithFormat:@"¥%.2lf",model.money.doubleValue];
    
    NSLog(@"%f",kScreenSize.width);
    _viewTop.frame = CGRectMake(_viewTop.orginX, _viewTop.orginY, _viewTop.sizeWidth, _viewTop.sizeHeight + (kScreenSize.width > 375 ? _viewTop.sizeHeight*0.3 + 2 : 0));
    
    _viewShoufukuan.center = CGPointMake(_viewShoufukuan.center.x, _viewTop.sizeHeight/2);
    _viewLingqian.center = CGPointMake(_viewLingqian.center.x, _viewTop.sizeHeight/2);
    _viewYinhangka.center = CGPointMake(_viewYinhangka.center.x, _viewTop.sizeHeight/2);
    
    _labelMoney.frame = CGRectMake(_labelMoney.orginX, _labelMoney.orginY, _labelMoney.sizeWidth, _labelMoney.sizeHeight * (kScreenSize.width > 375 ?  1.5: 1));
    _viewTengxunfuwu.frame = CGRectMake(_viewTengxunfuwu.orginX, _viewTop.allHeight, _viewTengxunfuwu.sizeWidth, _viewTengxunfuwu.sizeHeight);
    
    _view0.frame = CGRectMake(_view0.orginX, _viewTengxunfuwu.allHeight, _view0.sizeWidth, kScreenSize.width > 375 ?kScreenSize.width * plas : kScreenSize.width * other);
    
    _viewDisanfang.frame = CGRectMake(_viewDisanfang.orginX, _view0.allHeight, _viewDisanfang.sizeWidth, _viewDisanfang.sizeHeight);
    
    _view1.frame = CGRectMake(_view1.orginX, _viewDisanfang.allHeight, _view1.sizeWidth, kScreenSize.width > 375 ?kScreenSize.width * plas : kScreenSize.width * other);
    
    _layoutHeight.constant = _view1.allHeight;

    [self updateViewConstraints];
}


- (void)creatWolletView:(UIView * )superView images:(NSArray *)imageArray titles:(NSArray *)titleArray{
    CGFloat wolletWidth = kScreenSize.width/3;
    CGFloat wolletHeight = kScreenSize.width > 375 ? wolletWidth *plas : wolletWidth * other;
    for (int i = 0; i < 3; i ++) {
        for (int j = 0 ; j < 3; j ++ ) {
            _wolletView = [[WolletView alloc] initWithFrame:CGRectMake((wolletWidth) * j, (wolletHeight) * i, (wolletWidth - 0.5), (wolletHeight - 0.5)) image:[UIImage imageNamed:imageArray[i*3+j]] title:titleArray[i*3+j]];
            _wolletView.backgroundColor = kWhiteColor;
            [superView addSubview:_wolletView];
        }
    }
}


- (void)rightNavButtonClick{
}

- (IBAction)lingqianButtonClick:(UIButton *)sender {
    UIStoryboard *storyboard = kWechatStroyboard;
    LooseChangeViewController * looseChangeVC = [storyboard instantiateViewControllerWithIdentifier:@"LooseChangeViewController"];
    [looseChangeVC navBarTitle:@"零钱"];
    [looseChangeVC wechatRightButtonClick:@"零钱明细"];
    [self.navigationController pushViewController:looseChangeVC animated:YES];
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
