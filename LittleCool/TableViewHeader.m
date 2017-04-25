




/********************* 有任何问题欢迎反馈给我 liuweiself@126.com ****************************************/
/***************  https://github.com/waynezxcv/Gallop 持续更新 ***************************/
/******************** 正在不断完善中，谢谢~  Enjoy ******************************************************/



#import "TableViewHeader.h"
#import "Gallop.h"
#import "UserInfoModel.h"


@interface TableViewHeader ()

@property (nonatomic,strong) UIImageView* loadingView;
@property (nonatomic,strong)  LWImageStorage*bgImage;
@end

@implementation TableViewHeader

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self creatHeader:nil];
    }
    return self;
}

- (void)creatHeader:(UIImage *)bgImage{
    self.backgroundColor = [UIColor whiteColor];
    
    LWAsyncDisplayView* displayView =
    [[LWAsyncDisplayView alloc] initWithFrame:CGRectMake(0.0f,-40.0f,SCREEN_WIDTH,400.0f)];
    [self addSubview:displayView];
    [self addSubview:self.loadingView];
    
    [[FMDBHelper fmManger] getFMDBBySQLName:kCreatSQL];
    [[FMDBHelper fmManger] createTableByTableName:kOthreUserTable];
    UserInfoModel *model = [[UserInfoModel alloc] init];
    
    model = [[[FMDBHelper fmManger] selectDataByTableName:kOthreUserTable] firstObject];
    
//    UIImage *image = [UIImage imageWithData:model.headImage];
    UIImage *image = [UIImage imageNamed:@"pengyouquan_bg.jpg"];
    NSData *bgImageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"bgImage"];
    
    if (bgImageData) {
        image = [UIImage imageWithData:bgImageData];
    }
    
    LWLayout* layout = [[LWLayout alloc] init];
    _bgImage = [[LWImageStorage alloc] init];
    _bgImage.contents = bgImage ? bgImage : image;
    _bgImage.frame = CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, displayView.bounds.size.height-40);
    _bgImage.clipsToBounds = YES;
    [layout addStorage:_bgImage];
    
    LWImageStorage* avtar = [[LWImageStorage alloc] init];
    avtar.contents = [UIImage imageWithData:model.headImage];
    avtar.frame = CGRectMake(SCREEN_WIDTH - 90.0f, displayView.bounds.size.height - 95.0f, 80.0f, 80.0f);
    //        avtar.cornerRadius = 0.01f;
    avtar.backgroundColor = kWhiteColor;
    avtar.cornerBorderColor = kWhiteColor;
    avtar.cornerBorderWidth = 2.f;
    [layout addStorage:avtar];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 350 - 70, kScreenSize.width - 110, 20)];
    nameLabel.text = model.name;
    nameLabel.textAlignment = NSTextAlignmentRight;
    nameLabel.textColor = kWhiteColor;
    nameLabel.font = [UIFont boldSystemFontOfSize:17];
    [self addSubview:nameLabel];
    
    displayView.layout = layout;
}

- (void)setBGImage:(UIImage *)image{
    [self creatHeader:image];
}


- (UIImageView *)loadingView {
    if (_loadingView) {
        return _loadingView;
    }
    _loadingView = [[UIImageView alloc] initWithFrame:CGRectMake(20.0f,30.0f,25.0f,25.0f)];
    _loadingView.contentMode = UIViewContentModeScaleAspectFill;
    _loadingView.image = [UIImage imageNamed:@"loading"];
    _loadingView.clipsToBounds = YES;
    _loadingView.backgroundColor = [UIColor clearColor];
    return _loadingView;
}

- (void)loadingViewAnimateWithScrollViewContentOffset:(CGFloat)offset {
    if (offset <= 0 && offset > - 200.0f) {
        self.loadingView.transform = CGAffineTransformMakeRotation(offset* 0.1);
    }
}

- (void)refreshingAnimateBegin {
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.duration = 0.5f;
    rotationAnimation.autoreverses = NO;
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    rotationAnimation.toValue = [NSNumber numberWithFloat:2 * M_PI];
    [self.loadingView.layer addAnimation:rotationAnimation forKey:@"rotationAnimations"];
}

- (void)refreshingAnimateStop {
    [self.loadingView.layer removeAllAnimations];
}


@end
