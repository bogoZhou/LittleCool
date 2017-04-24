//
//  AllChatTableViewCell.m
//  Qian
//
//  Created by 周博 on 17/2/20.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//


//对象类型
//1- >自己文字;2 -> 对方文字;3->我转账;4->对方转账;5->我发红包;
//6->对方发红包;7->我图片;8->对方图片;9->我语音;10->对方语音;
//11->我撤回;12->对方撤回;13->我领取红包;14->对方领取红包
//15-> 我收取微信转账 16 -> 对方收取转账
//17 -> 创建新用户message1 ; 18 -> message2 ; 19 -> message3
#import "AllChatTableViewCell.h"
#define kSpace 13

@interface AllChatTableViewCell ()
{
    
}
@property (nonatomic,strong) UIView *myContentView;
@property (nonatomic,strong) ChatModel *chatModel;
@property (nonatomic,strong) NSString *myMoney;
@property (nonatomic,strong) NSString *myContent;
@property (nonatomic,strong) NSString *mySend;
@property (nonatomic,strong) NSString *myGet;
@property (nonatomic,strong) NSString *myName;
@end

@implementation AllChatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)showDataWithModel:(ChatModel *)model{
    [_myContentView removeFromSuperview];
    _myContentView = nil;
    _myContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 60)];
    _myContentView.userInteractionEnabled = YES;
    
    UILongPressGestureRecognizer *longPressGestureRecognizer  = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestures:)];
    
    longPressGestureRecognizer.numberOfTouchesRequired = 1;
    /* Maximum 100 pixels of movement allowed before the gesture is recognized */
    /*最大100像素的运动是手势识别所允许的*/
    longPressGestureRecognizer.allowableMovement = 100.0f;
    /*这个参数表示,两次点击之间间隔的时间长度。*/
    longPressGestureRecognizer.minimumPressDuration = 1.0;
    [_myContentView addGestureRecognizer:longPressGestureRecognizer];
    
    [self addSubview:_myContentView];
    _chatModel = model;
    switch (model.type.integerValue) {
        case 1://自己文字;
        {
            [self textCells:model];
        }
            break;
        case 2://对方文字
        {
            [self textCells:model];
        }
            break;
        case 3://我转账
        {
            [self transferAccountCells:model];
        }
            break;
        case 4://对方转账
        {
            [self transferAccountCells:model];
        }
            break;
        case 5://我发红包
        {
            [self redPacketCells:model];
        }
            break;
        case 6://对方发红包
        {
            [self redPacketCells:model];
        }
            break;
        case 7://我的图片
        {
            [self showImageCells:model];
        }
            break;
        case 8://对方图片
        {
            [self showImageCells:model];
        }
            break;
        case 9://我语音
        {
            [self showSoundsCells:model];
        }
            break;
        case 10://对方语音
        {
            [self showSoundsCells:model];
        }
            break;
        case 11://我撤回
        {
            [self cancelMessageCells:model];
        }
            break;
        case 12://对方撤回
        {
            [self cancelMessageCells:model];
        }
            break;
        case 13://我领取红包
        {
            [self getRedPacketCells:model];
        }
            break;
        case 14://对方领取红包
        {
            [self getRedPacketCells:model];
        }
            break;
        case 15:
        {
            [self transferAccountCells:model];
        }
            break;
        case 16:
        {
            [self transferAccountCells:model];
        }
            break;
        case 17:
        case 18:
        case 19:{
            [self newGuyCells:model];
        }
            break;
            default:
            break;
    }
}

- (void)newGuyCells:(ChatModel *)model{
    UIView * textContentView;
    
    textContentView = [[UIView alloc] init];
    textContentView.backgroundColor = kColorFrom0x(0xcecece);
    //    textContentView.alpha = 0.2f;
    textContentView.layer.masksToBounds = YES;
    textContentView.layer.cornerRadius = 5;
    CGFloat textFontSize = 14;
    CGFloat maxWidth;
    if (model.type.integerValue == 17) {//message1
        maxWidth = kScreenSize.width;
    }else if (model.type.integerValue == 18) {//message2
        maxWidth = kScreenSize.width - 100;
    }else{//message3
        maxWidth = kScreenSize.width - 65;
    }
    
    CGSize titleSize = [model.content boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:textFontSize]} context:nil].size;
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, titleSize.width, titleSize.height)];
    contentLabel.text = model.content;
    contentLabel.backgroundColor = kClearColor;
    contentLabel.textColor = kWhiteColor;
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.numberOfLines = 0;
    contentLabel.font =[UIFont systemFontOfSize:textFontSize];
    
    [textContentView addSubview:contentLabel];
    
    textContentView.frame = CGRectMake(0, 0, contentLabel.frame.size.width + 20, titleSize.height + 8);
    
    _myContentView.frame = CGRectMake(0, 0, kScreenSize.width, titleSize.height + kSpace);
    
    textContentView.center = _myContentView.center;
    
    [_myContentView addSubview:textContentView];
}

//发送语音
- (void)showSoundsCells:(ChatModel *)model{
    UIImageView *imageView;
    UIView *textContentView;
    
    if (model.type.integerValue == 9) {//我发的文字
        //设置头像
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenSize.width - 60, 10, 40, 40)];
                imageView.backgroundColor = kWhiteColor;
        imageView.image = [UIImage imageWithData:model.userImage];
        [_myContentView addSubview:imageView];
        
        //设置内容View
        textContentView = [[UIView alloc] initWithFrame:CGRectMake(60, 10, kScreenSize.width - 120, 40)];
        textContentView.backgroundColor = kChatGreen;
        textContentView.layer.cornerRadius = 5;
        textContentView.layer.borderWidth = 0.5;
        textContentView.layer.borderColor = [kChatGreenBorder CGColor];
        [_myContentView addSubview:textContentView];
        
        //设置内容的绿三角
        UIImageView *singleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenSize.width - 40 - 10 -20-1, 25, 6, 12)];
        singleImageView.image = kGreenSingle;
        [_myContentView addSubview:singleImageView];
        //设置内容
        UIImage *soundsImage = [UIImage imageNamed:@"Voice Message.png"];
        
        
        
        double ratio;
        int unit = 10;
        if (model.content.integerValue < 3) {
            ratio = 60;
        }else if (model.content.integerValue >= 3 && model.content.integerValue < 11){
            ratio = 60 + (model.content.integerValue - 2)*unit;
        }else if (model.content.integerValue >= 11){
            ratio = 60 + 8*unit + (model.content.integerValue - 10)/10 * unit;
        }
        
        textContentView.frame = CGRectMake(kScreenSize.width - 60 - ratio - 10, textContentView.frame.origin.y, ratio, 40);
        UIImageView *soundsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(textContentView.frame.size.width - 20, 11.5, 12, 17)];
        soundsImageView.image = soundsImage;
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(textContentView.frame.origin.x - 80, 0, 74, 70)];
        timeLabel.text = [NSString stringWithFormat:@"%@\'\'",model.content];
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.textColor = kColorFrom0x(0x999999);
        timeLabel.font = [UIFont systemFontOfSize:13];
        timeLabel.backgroundColor = kClearColor;
        
        [_myContentView addSubview:timeLabel];
        
        [textContentView addSubview:soundsImageView];
        
    }else if (model.type.integerValue == 10){//对方发文字
        //设置头像
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        imageView.image = [UIImage imageWithData:model.userImage];
        imageView.backgroundColor = kWhiteColor;
        [_myContentView addSubview:imageView];
        
        //设置内容View
        textContentView = [[UIView alloc] initWithFrame:CGRectMake(60, 10, kScreenSize.width - 120, 40)];
        textContentView.backgroundColor = kWhiteColor;
        textContentView.layer.cornerRadius = 5;
        textContentView.layer.borderWidth = 0.5;
        textContentView.layer.borderColor = [kChatWhiteBorder CGColor];
        [_myContentView addSubview:textContentView];
        
        //设置内容的白三角
        UIImageView *singleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(55.5, 25, 6, 12)];
        singleImageView.image = kWhiteSingle;
        [_myContentView addSubview:singleImageView];
        //设置内容label
        //设置内容
        UIImage *soundsImage = [UIImage imageNamed:@"yuyin002.png"];
        
        UIImageView *soundsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,  11.5, 12, 17)];
        soundsImageView.image = soundsImage;
        
        double ratio;
        int unit = 10;
        if (model.content.integerValue < 3) {
            ratio = 60;
        }else if (model.content.integerValue >= 3 && model.content.integerValue < 11){
            ratio = 60 + (model.content.integerValue - 2)*unit;
        }else if (model.content.integerValue >= 11){
            ratio = 60 + 8*unit + (model.content.integerValue - 10)/10 * unit;
        }
        
        textContentView.frame = CGRectMake(60, textContentView.frame.origin.y, ratio, 40);
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(textContentView.frame.origin.x + textContentView.frame.size.width + 5, 0, 74, 70)];
        timeLabel.text = [NSString stringWithFormat:@"%@\'\'",model.content];
        timeLabel.textAlignment = NSTextAlignmentLeft;
        timeLabel.textColor = kColorFrom0x(0x999999);
        timeLabel.font = [UIFont systemFontOfSize:13];
        timeLabel.backgroundColor = kClearColor;
        
        [_myContentView addSubview:timeLabel];
        
        [textContentView addSubview:soundsImageView];
        
    }
    
    _myContentView.frame = CGRectMake(_myContentView.frame.origin.x, _myContentView.frame.origin.y, _myContentView.frame.size.width, textContentView.frame.size.height + kSpace);
}


//显示图片
- (void)showImageCells:(ChatModel *)model{
    
    UIImage *img = [UIImage imageWithData:model.contentImage];
    CGSize imgSize = img.size;
    CGSize ruleSize = CGSizeMake(145, 145);
    if (img.size.width >= img.size.height) {//宽图
        imgSize.width = ruleSize.width;
        imgSize = CGSizeMake(imgSize.width, imgSize.width/img.size.width*imgSize.height);
    }else{
        imgSize.height = ruleSize.height;
        imgSize = CGSizeMake(imgSize.height/img.size.height * imgSize.width,imgSize.height);
    }
    CGRect frame;
    UIImage *tukuangImage;
    UIImageView *imageView;
    
    //        imageView.backgroundColor = kRandomColor;
    
    if (model.type.integerValue == 7) {//我的图
        frame = CGRectMake(kScreenSize.width - 40 - 10 - imgSize.width - 13, 10, imgSize.width, imgSize.height);
        tukuangImage = [UIImage imageNamed:@"tukuang.png"];
        //设置头像
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenSize.width - 40 - 20, 10, 40, 40)];
    }else{
        frame = CGRectMake(58, 10, imgSize.width, imgSize.height);
        tukuangImage = [UIImage imageNamed:@"tukuang_left.png"];
        //设置头像
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    }
    
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:frame];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    layer.frame = image.bounds;
    layer.contents = (id)tukuangImage.CGImage;
    layer.contentsCenter = CGRectMake(0.7, 0.7, 0.1, 0.1);
    layer.contentsScale = [UIScreen mainScreen].scale;
    
    image.layer.mask = layer;
    image.layer.frame = image.frame;
    image.image = [UIImage imageWithData:model.contentImage];
    
    _myContentView.frame = CGRectMake(_myContentView.frame.origin.x, _myContentView.frame.origin.y, _myContentView.frame.size.width, imgSize.height + kSpace);
    
    imageView.image = [UIImage imageWithData:model.userImage];
    imageView.userInteractionEnabled = YES;
    imageView.backgroundColor = kWhiteColor;
    [_myContentView addSubview:imageView];
    
    [_myContentView addSubview:image];
}


//领取红包
- (void)getRedPacketCells:(ChatModel *)model{
    UIView *textContentView;
    textContentView = [[UIView alloc] init];
    textContentView.backgroundColor = kClearColor;
    textContentView.layer.masksToBounds = YES;
    textContentView.layer.cornerRadius = 5;

    NSArray *textArray = [model.content componentsSeparatedByString:@"红包"];
    NSMutableAttributedString * firstPart;
    NSMutableAttributedString * secondPart;
    NSMutableAttributedString * thirdPart;
    if (textArray.count > 2) {
        //attribute
        firstPart = [[NSMutableAttributedString alloc] initWithString:textArray[0]];
        NSDictionary * firstAttributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:kWhiteColor};
        [firstPart setAttributes:firstAttributes range:NSMakeRange(0,firstPart.length)];
        
        secondPart = [[NSMutableAttributedString alloc] initWithString:@"红包"];
        NSDictionary * secondAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:kChatYellow};
        [secondPart setAttributes:secondAttributes range:NSMakeRange(0,secondPart.length)];
        
        thirdPart = [[NSMutableAttributedString alloc] initWithString:@"，你的红包已被领完"];
        NSDictionary * thirdAttributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:kWhiteColor};
        [thirdPart setAttributes:thirdAttributes range:NSMakeRange(0,thirdPart.length)];
        
        [firstPart appendAttributedString:secondPart];
        [firstPart appendAttributedString:thirdPart];
    }else{
        firstPart = [[NSMutableAttributedString alloc] initWithString:textArray[0]];
        NSDictionary * firstAttributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:kWhiteColor};
        [firstPart setAttributes:firstAttributes range:NSMakeRange(0,firstPart.length)];
        
        secondPart = [[NSMutableAttributedString alloc] initWithString:@"红包"];
        NSDictionary * secondAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:kChatYellow};
        [secondPart setAttributes:secondAttributes range:NSMakeRange(0,secondPart.length)];
        
        [firstPart appendAttributedString:secondPart];
    }
    
    CGSize titleSize0 = [firstPart.string boundingRectWithSize:CGSizeMake(kScreenSize.width - 65, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
//    NSString *contentsize = [NSString stringWithFormat:@"%@%@",model.content,@"红包"];
//    CGSize titleSize = [model.content boundingRectWithSize:CGSizeMake(kScreenSize.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
//    CGSize titleSize2 = [@"红包" boundingRectWithSize:CGSizeMake(kScreenSize.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
    UIImageView *picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 4, 14, 16)];
    picImageView.image = [UIImage imageNamed:@"hongbao(1).png"];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(picImageView.frame.origin.x, 3, titleSize0.width,titleSize0.height)];
    label1.textColor = kWhiteColor;
    label1.attributedText = firstPart;
    label1.backgroundColor = kClearColor;
    label1.numberOfLines = 0;
    label1.font = [UIFont systemFontOfSize:14];
    
//    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(label1.frame.origin.x+label1.frame.size.width, 0, titleSize2.width, 23)];
//    label2.textColor = kChatYellow;
//    label2.text = @"红包";
//    label2.backgroundColor = kClearColor;
//    label2.font = [UIFont systemFontOfSize:14];
    
    textContentView.frame = CGRectMake((_myContentView.frame.size.width - (label1.frame.origin.x + label1.frame.size.width + 5 + 4))/2, 10, label1.frame.origin.x + label1.frame.size.width + 5 + 4, label1.frame.size.height + 8 );
    _myContentView.frame = CGRectMake(0, 0, kScreenSize.width, textContentView.frame.size.height + 14 );
//    textContentView.center = _myContentView.center;

    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, textContentView.frame.size.width, textContentView.frame.size.height)];
    backImageView.backgroundColor = kColorFrom0x(0xcecece);
//    backImageView.alpha = 0.2f;
    backImageView.userInteractionEnabled = YES;
    
    [textContentView addSubview:backImageView];
    [textContentView addSubview:picImageView];
    [textContentView addSubview:label1];
//    [textContentView addSubview:label2];
    
//    label2.backgroundColor = kBlackColor;
    
    [_myContentView addSubview:textContentView];
    
    
}

//撤回消息
- (void)cancelMessageCells:(ChatModel *)model{
    UIView * textContentView;
    
    textContentView = [[UIView alloc] init];
    textContentView.backgroundColor = kColorFrom0x(0xcecece);
//    textContentView.alpha = 0.2f;
    textContentView.layer.masksToBounds = YES;
    textContentView.layer.cornerRadius = 5;
    CGFloat textFontSize;
    if (model.type.integerValue == 11 || model.type.integerValue == 12) {
        textFontSize = 13;
    }else{
        textFontSize = 12;
    }
    
    NSString *contentStr;
    if (model.content.longLongValue > 10000) {
        contentStr = [BGDateHelper getTimeArrayByTimeString:model.content][5];
        textFontSize = 12;
        _myContentView.frame = CGRectMake(0, 0, kScreenSize.width, 45);
    }else{
        contentStr = model.content;
        _myContentView.frame = CGRectMake(0, 0, kScreenSize.width, 40);
    }
    
    CGSize titleSize = [contentStr boundingRectWithSize:CGSizeMake(kScreenSize.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:textFontSize]} context:nil].size;
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 0, titleSize.width < 35 ? 35 : titleSize.width + 10, (model.content.longLongValue > 10000) ? 20: 22)];
    contentLabel.text = contentStr;
    contentLabel.backgroundColor = kClearColor;
    contentLabel.textColor = kWhiteColor;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.font =[UIFont systemFontOfSize:textFontSize];
    
    
    [textContentView addSubview:contentLabel];
    
    textContentView.frame = CGRectMake(0, 0, contentLabel.frame.size.width + 8, (model.content.longLongValue > 10000) ? 20: 22);
    
    
    
//    textContentView.center = _myContentView.center;
    textContentView.center = CGPointMake(_myContentView.center.x, _myContentView.sizeHeight - 10 - 3);
    
    [_myContentView addSubview:textContentView];
    
}


//发送红包
- (void)redPacketCells:(ChatModel *)model{
    UIImageView *imageView;
    UIView *textContentView;
    
    ChatRedPacketModel *redModel = [[[FMDBHelper fmManger] selectRedPacketWhereValue1:@"Id" value2:model.content isNeed:YES] lastObject];
    
    //设置头像
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenSize.width - 60, 10, 40, 40)];
    imageView.image = [UIImage imageWithData:model.userImage];
    imageView.userInteractionEnabled = YES;
    imageView.backgroundColor = kWhiteColor;
    [_myContentView addSubview:imageView];
    
    //设置内容View
    textContentView = [[UIView alloc] initWithFrame:CGRectMake(75, 10, kScreenSize.width - 145, 85)];
    textContentView.backgroundColor = kWhiteColor;
    textContentView.layer.masksToBounds = YES;
    textContentView.layer.cornerRadius = 5;
    textContentView.layer.borderWidth = 0.5;
    textContentView.layer.borderColor = [kChatWhiteBorder CGColor];
    [_myContentView addSubview:textContentView];
    
    
    
    UIView *contentTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, textContentView.frame.size.width, textContentView.frame.size.height - 20)];

    contentTopView.backgroundColor = kChatYellow;
    [textContentView addSubview:contentTopView];
    
    
    UIImageView *redPacketImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 33, 40)];
    redPacketImageView.image = [UIImage imageNamed:@"hongbao"];
    redPacketImageView.userInteractionEnabled = YES;
    [contentTopView addSubview:redPacketImageView];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(redPacketImageView.frame.origin.x + redPacketImageView.frame.size.width + 12, 12, contentTopView.frame.size.width - redPacketImageView.frame.origin.x - redPacketImageView.frame.size.width - 12 - 12, 20)];
    contentLabel.text = redModel.redContent;
    contentLabel.textColor = kWhiteColor;
    contentLabel.font = [UIFont systemFontOfSize:16];
    [contentTopView addSubview:contentLabel];
    
    UILabel *getRLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentLabel.frame.origin.x, contentLabel.frame.origin.y + contentLabel.frame.size.height + 5, 100, 12)];
    getRLabel.textColor = kWhiteColor;
    getRLabel.text = @"领取红包";
    getRLabel.font = [UIFont fontWithName:kFontName size:12];
    [contentTopView addSubview:getRLabel];
    
    UILabel *wechatRLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, contentTopView.frame.size.height + 4, 100, 12)];
    wechatRLabel.textColor = [UIColor grayColor];
    wechatRLabel.text = @"微信红包";
    wechatRLabel.font = [UIFont systemFontOfSize:10];
    [textContentView addSubview:wechatRLabel];
    
    //设置内容的黄色三角
    UIImageView *singleImageView;
    singleImageView.image = kYellowSingle;
    singleImageView.userInteractionEnabled = YES;
    
    if (model.type.integerValue == 5) {//我发红包
        singleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenSize.width - 40 - 10 -20-1, 25, 6, 12)];
        singleImageView.image = kYellowSingle;
        
    }else{
        singleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(55.5, 25, 6, 12)];
        singleImageView.image = [UIImage imageNamed:@"huangsanjiao_left.png"];
        imageView.frame = CGRectMake(10, 10, 40, 40);
        textContentView.frame = CGRectMake(60, 10, kScreenSize.width - 150, 85);
    }
    
    [_myContentView addSubview:singleImageView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, textContentView.frame.size.width, textContentView.frame.size.height)];
    _chatModel = model;
    [button setTitle:@"" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(redPacketButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [textContentView addSubview:button];
    _myContentView.frame = CGRectMake(_myContentView.frame.origin.x, _myContentView.frame.origin.y, _myContentView.frame.size.width, textContentView.frame.size.height + kSpace);
}

//微信转账
- (void)transferAccountCells:(ChatModel *)model{
    
    NSArray * array = [model.content componentsSeparatedByString:@"$"];
    
    _myMoney = array[0];
    _myContent = array[1];
    _mySend = array[2];
    _myGet = array[3];
    _myName = array[4];
    
    UIImageView *imageView;
    UIView *textContentView;
    
    //设置头像
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenSize.width - 60, 10, 40, 40)];
    imageView.image = [UIImage imageWithData:model.userImage];
    imageView.backgroundColor = kWhiteColor;
    [_myContentView addSubview:imageView];
    
    //设置内容View
    textContentView = [[UIView alloc] initWithFrame:CGRectMake(80, 10, kScreenSize.width - 150, 85)];
    textContentView.backgroundColor = kWhiteColor;
    textContentView.layer.masksToBounds = YES;
    textContentView.layer.cornerRadius = 5;
    textContentView.layer.borderWidth = 0.5;
    textContentView.layer.borderColor = [kChatWhiteBorder CGColor];
    [_myContentView addSubview:textContentView];
    
    
    
    UIView *contentTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, textContentView.frame.size.width, textContentView.frame.size.height - 20)];
    
    contentTopView.backgroundColor = kChatYellow;
    [textContentView addSubview:contentTopView];
    
    
    UIImageView *redPacketImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 40, 40)];
    
    [contentTopView addSubview:redPacketImageView];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(redPacketImageView.frame.origin.x + redPacketImageView.frame.size.width + 12, 12, contentTopView.frame.size.width - redPacketImageView.frame.origin.x - redPacketImageView.frame.size.width - 12 - 12, 20)];
    if (model.type.integerValue == 3) {//我
        contentLabel.text = [NSString stringWithFormat:@"转账给%@",_myName];
    }else if (model.type.integerValue == 4){
        contentLabel.text = [NSString stringWithFormat:@"转账给你"];
    }else{//对方收取转账
        contentLabel.text = [NSString stringWithFormat:@"已收钱"];
    }
    
    contentLabel.textColor = kWhiteColor;
    contentLabel.font = [UIFont systemFontOfSize:16];
    [contentTopView addSubview:contentLabel];
    
    UILabel *getRLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentLabel.frame.origin.x, contentLabel.frame.origin.y + contentLabel.frame.size.height + 5, 100, 12)];
    getRLabel.textColor = kWhiteColor;
    getRLabel.text = [NSString stringWithFormat:@"¥%.2lf",_myMoney.doubleValue];
    getRLabel.font = [UIFont fontWithName:kFontName size:12];
    [contentTopView addSubview:getRLabel];
    
    UILabel *wechatRLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, contentTopView.frame.size.height + 4, 100, 12)];
    wechatRLabel.textColor = [UIColor grayColor];
    wechatRLabel.text = @"微信转账";
    wechatRLabel.font = [UIFont systemFontOfSize:10];
    [textContentView addSubview:wechatRLabel];
    
    //设置内容的黄色三角
    UIImageView *singleImageView;
    singleImageView.image = kYellowSingle;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, textContentView.frame.size.width, textContentView.frame.size.height)];
    _chatModel = model;
    [button setTitle:@"" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(zhuanzhangButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    if (model.type.integerValue == 3) {//我转账
        singleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenSize.width - 40 - 10 -20-1, 25, 6, 12)];
        singleImageView.image = kYellowSingle;
        redPacketImageView.image = [UIImage imageNamed:@"zhuanzhang(3)"];
        [textContentView addSubview:button];
    }else if(model.type.integerValue == 4){
        singleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(55.5, 25, 6, 12)];
        singleImageView.image = [UIImage imageNamed:@"huangsanjiao_left.png"];
        imageView.frame = CGRectMake(10, 10, 40, 40);
        textContentView.frame = CGRectMake(60, 10, kScreenSize.width - 150, 85);
        redPacketImageView.image = [UIImage imageNamed:@"zhuanzhang(3)"];
        [textContentView addSubview:button];
    }else if (model.type.integerValue == 15){//我收账
        singleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenSize.width - 40 - 10 -20-1, 25, 6, 12)];
        singleImageView.image = kYellowSingle;
        redPacketImageView.image = [UIImage imageNamed:@"yishouqian(4)"];
    }else{//对方收账
        singleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(55.5, 25, 6, 12)];
        singleImageView.image = [UIImage imageNamed:@"huangsanjiao_left.png"];
        imageView.frame = CGRectMake(10, 10, 40, 40);
        redPacketImageView.image = [UIImage imageNamed:@"yishouqian(4)"];
        textContentView.frame = CGRectMake(60, 10, kScreenSize.width - 150, 85);
    }
    
    [_myContentView addSubview:singleImageView];
    
    _myContentView.frame = CGRectMake(_myContentView.frame.origin.x, _myContentView.frame.origin.y, _myContentView.frame.size.width, textContentView.frame.size.height + kSpace);
}

//发送文字
- (void)textCells:(ChatModel *)model{
    
    UIImageView *imageView;
    UIView *textContentView;
    CGSize titleSize;
    
    if (model.type.integerValue == 1) {//我发的文字
        //设置头像
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenSize.width - 60, 10, 40, 40)];
        imageView.backgroundColor = kWhiteColor;
        imageView.image = [UIImage imageWithData:model.userImage];
        [_myContentView addSubview:imageView];
        
        //设置内容View
        textContentView = [[UIView alloc] initWithFrame:CGRectMake(60, 10, kScreenSize.width - 132, 40)];
        textContentView.backgroundColor = kChatGreen;
        textContentView.layer.cornerRadius = 5;
        textContentView.layer.borderWidth = 0.5;
        textContentView.layer.borderColor = [kChatGreenBorder CGColor];
        [_myContentView addSubview:textContentView];

        //设置内容的绿三角
        UIImageView *singleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenSize.width - 40 - 10 -20-1, 25, 6, 12)];
        singleImageView.image = kGreenSingle;
        [_myContentView addSubview:singleImageView];
        //设置内容label
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.text = model.content;
//        contentLabel.font = [UIFont systemFontOfSize:16];
        contentLabel.font = [UIFont fontWithName:kChatFont size:16];
        contentLabel.numberOfLines = 0;
        contentLabel.backgroundColor = kClearColor;
        titleSize = [contentLabel.text boundingRectWithSize:CGSizeMake(textContentView.frame.size.width-12, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:contentLabel.font} context:nil].size;
        contentLabel.frame = CGRectMake(11, 11, titleSize.width, titleSize.height);
        
        textContentView.frame = CGRectMake(kScreenSize.width - 60 - 40 - ((titleSize.width) < 30 ? 30 : (titleSize.width)) + 10, textContentView.frame.origin.y + (titleSize.height + 20 > 40 ? 0 : 40 - titleSize.height - 20), (titleSize.width + 20) < 50 ? 50 : (titleSize.width + 20), titleSize.height + 20 > 40?titleSize.height + 20 : 40);
        [textContentView addSubview:contentLabel];

    }else if (model.type.integerValue == 2){//对方发文字
        //设置头像
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        imageView.image = [UIImage imageWithData:model.userImage];
        imageView.backgroundColor = kWhiteColor;
        [_myContentView addSubview:imageView];
        
        //设置内容View
        textContentView = [[UIView alloc] initWithFrame:CGRectMake(60, 10, kScreenSize.width - 132, 40)];
        textContentView.backgroundColor = kWhiteColor;
        textContentView.layer.cornerRadius = 5;
        textContentView.layer.borderWidth = 0.5;
        textContentView.layer.borderColor = [kChatWhiteBorder CGColor];
        [_myContentView addSubview:textContentView];
        
        //设置内容的白三角
        UIImageView *singleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(55.5, 25, 6, 12)];
        singleImageView.image = kWhiteSingle;
        [_myContentView addSubview:singleImageView];
        //设置内容label
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.text = model.content;
//        contentLabel.font = [UIFont systemFontOfSize:16];
        contentLabel.font = [UIFont fontWithName:kChatFont size:16];
        contentLabel.numberOfLines = 0;
        contentLabel.backgroundColor = kClearColor;
        titleSize = [contentLabel.text boundingRectWithSize:CGSizeMake(textContentView.frame.size.width-12, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:contentLabel.font} context:nil].size;
        contentLabel.frame = CGRectMake(11, 11, titleSize.width, titleSize.height);
        
        textContentView.frame = CGRectMake(60, textContentView.frame.origin.y, (titleSize.width + 20) < 50 ? 50 : (titleSize.width + 20), titleSize.height + 20 > 40 ? titleSize.height + 20 : 40);
        
        [textContentView addSubview:contentLabel];

    }

    
    
    _myContentView.frame = CGRectMake(_myContentView.frame.origin.x, _myContentView.frame.origin.y, _myContentView.frame.size.width, textContentView.frame.size.height + kSpace);
}


- (CGFloat)height{
    CGFloat cellHeight = _myContentView.frame.size.height;
    return cellHeight;
}

- (UIImage *)normalizedImage:(UIImage*)image{
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [image drawInRect:(CGRect){0, 0, image.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}

#pragma mark - 点击事件
- (void)redPacketButtonClick:(UIButton *)button{
    NSDictionary *dict = @{
                           @"type" : _chatModel.type,
                           @"redId" : _chatModel.content
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"clickRedPacket" object:dict];
}

- (void)zhuanzhangButtonClick:(UIButton *)button{
    NSString *type = _chatModel.type;
    if (_chatModel.type.integerValue == 3) {
        type = @"16";
    }else if (_chatModel.type.integerValue == 4){
        type = @"15";
    }
    NSDictionary *dict = @{
                           @"money" : _myMoney,
                           @"content" : _myContent,
                           @"send" : _mySend,
                           @"get" : _myGet,
                           @"type" : type
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"clickZhuanZhang" object:dict];
}

- (void) handleLongPressGestures:(UILongPressGestureRecognizer *)paramSender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"longPress" object:_chatModel.chatDetailId];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
