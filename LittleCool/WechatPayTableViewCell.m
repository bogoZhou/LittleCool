//
//  WechatPayTableViewCell.m
//  Qian
//
//  Created by 周博 on 17/3/11.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "WechatPayTableViewCell.h"

@interface WechatPayTableViewCell ()
{
    
}
@property (nonatomic,strong) UIView *contentV;

@property (nonatomic,strong) UILabel *topDateLabel;

@property (nonatomic,strong) WechatPayModel *myModel;

@end

@implementation WechatPayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)showDataWithModel:(WechatPayModel *)model{
    
    _myModel = model;
    
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_topDateLabel removeFromSuperview];
    [_contentV removeFromSuperview];
    _topDateLabel = nil;
    _contentV = nil;
    
    //顶部时间
    _topDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, kScreenSize.width, 20)];
//    _topDateLabel.text = @"  19:50  ";
    _topDateLabel.text = [NSString stringWithFormat:@"%@",[BGDateHelper getTimeArrayByTimeString:model.startDate][5]];
    _topDateLabel.font = [UIFont systemFontOfSize:12];
    
    CGSize titleSize = [_topDateLabel.text boundingRectWithSize:CGSizeMake(kScreenSize.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_topDateLabel.font} context:nil].size;
    titleSize.width += 14;
    _topDateLabel.textColor = kWhiteColor;
    _topDateLabel.backgroundColor = kColorFrom0x(0xd9d9d9);
    _topDateLabel.layer.masksToBounds = YES;
    _topDateLabel.layer.cornerRadius = 5;
    _topDateLabel.textAlignment = NSTextAlignmentCenter;
    _topDateLabel.tintColor = kClearColor;
    _topDateLabel.frame = CGRectMake((kScreenSize.width - titleSize.width)/2, _topDateLabel.frame.origin.y, titleSize.width, _topDateLabel.frame.size.height);
    [self addSubview:_topDateLabel];
    
    
    //中间内容View
    _contentV = [[UIView alloc] initWithFrame:CGRectMake(10, 50, kScreenSize.width - 20, 0)];
    _contentV.backgroundColor = kWhiteColor;
    _contentV.layer.masksToBounds = YES;
    _contentV.layer.cornerRadius = kButtonCornerRadius *2;
    
    //顶部标题
    UILabel *topTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, kScreenSize.width, 20)];
    NSString *typeString ;
    if (model.type.integerValue == 1) {
        typeString = @"零钱提现发起";
    }else if (model.type.integerValue == 2){
        typeString = @"零钱提现到账";
    }else if (model.type.integerValue == 3){
        typeString = @"转账过期退还通知";
    }else if (model.type.integerValue == 4){
        typeString = @"红包退还通知";
    }
    topTitleLabel.text = typeString;
    topTitleLabel.font = [UIFont systemFontOfSize:16];
    titleSize = [topTitleLabel.text boundingRectWithSize:CGSizeMake(kScreenSize.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:topTitleLabel.font} context:nil].size;
    topTitleLabel.frame = CGRectMake(topTitleLabel.frame.origin.x, topTitleLabel.frame.origin.y, titleSize.width, titleSize.height);
    [_contentV addSubview:topTitleLabel];
    
    //第二行时间
    UILabel *secondTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, topTitleLabel.allHeight + 5, 0, 0 )];
    secondTimeLabel.text = [NSString stringWithFormat:@"%ld月%ld日",[[BGDateHelper getTimeArrayByTimeString:model.startDate][2] integerValue],[[BGDateHelper getTimeArrayByTimeString:model.startDate][3] integerValue]];
    secondTimeLabel.font = [UIFont systemFontOfSize:12];
    secondTimeLabel.textColor = kColorFrom0x(0x666666);
    titleSize = [secondTimeLabel.text boundingRectWithSize:CGSizeMake(kScreenSize.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:secondTimeLabel.font} context:nil].size;
    secondTimeLabel.frame = CGRectMake(secondTimeLabel.orginX, secondTimeLabel.orginY, titleSize.width, titleSize.height);
    [_contentV addSubview:secondTimeLabel];
    
    //支付金额/退款金额/提现金额
    UILabel *typeAboutMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, secondTimeLabel.allHeight + 30, 0, 0)];
    if (model.type.integerValue == 3) {
        typeAboutMoneyLabel.text = @"退还金额:";
    }else{
        typeAboutMoneyLabel.text = @"提现金额:";
    }
    
    typeAboutMoneyLabel.font = [UIFont systemFontOfSize:14];
    typeAboutMoneyLabel.textColor = kColorFrom0x(0x666666);
    titleSize = [typeAboutMoneyLabel.text boundingRectWithSize:CGSizeMake(kScreenSize.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:typeAboutMoneyLabel.font} context:nil].size;
    typeAboutMoneyLabel.frame = CGRectMake((_contentV.sizeWidth - titleSize.width)/2, typeAboutMoneyLabel.orginY, titleSize.width, titleSize.height);
    [_contentV addSubview:typeAboutMoneyLabel];
    
    //金额
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, typeAboutMoneyLabel.allHeight + 10, 0, 0)];
    moneyLabel.text = [NSString stringWithFormat:@"¥%.2lf",model.money.doubleValue];
    moneyLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:28];
    titleSize = [moneyLabel.text boundingRectWithSize:CGSizeMake(kScreenSize.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:moneyLabel.font} context:nil].size;
    moneyLabel.frame = CGRectMake((_contentV.sizeWidth - titleSize.width)/2, moneyLabel.orginY, titleSize.width, titleSize.height);
    [_contentV addSubview:moneyLabel];
    
    //虚线
    UIImageView *dashLine = [[UIImageView alloc] initWithFrame:CGRectMake(15, moneyLabel.allHeight + 15, _contentV.sizeWidth - 30, 0.5)];
    [self drawDashLine:dashLine lineLength:4 lineSpacing:4 lineColor:kColorFrom0x(0xd6d6d6)];
    [_contentV addSubview:dashLine];
    
    //记录左边最宽的宽度
    NSString *lenthStr ;
    if (model.type.integerValue == 1) {
        lenthStr = @"预计到账时间:";
    }else{
        lenthStr = @"退款原因:";
    }
    titleSize = [lenthStr boundingRectWithSize:CGSizeMake(kScreenSize.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
    CGFloat lengthestWidth = titleSize.width + 15;
    
    //支付方式/退款方式/提现银行
    UILabel *typeWayLabelLeft = [[UILabel alloc] initWithFrame:CGRectMake(15, dashLine.allHeight + 15, 0, 0)];
    if (model.type.integerValue == 3) {
        typeWayLabelLeft.text = @"退款原因:";
    }else{
        typeWayLabelLeft.text = @"提现银行:";
    }
    
    typeWayLabelLeft.font = [UIFont systemFontOfSize:14];
    typeWayLabelLeft.textColor = kColorFrom0x(0x666666);
    titleSize = [typeWayLabelLeft.text boundingRectWithSize:CGSizeMake(kScreenSize.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:typeWayLabelLeft.font} context:nil].size;
    typeWayLabelLeft.frame = CGRectMake(typeWayLabelLeft.orginX, typeWayLabelLeft.orginY, titleSize.width, titleSize.height);
    [_contentV addSubview:typeWayLabelLeft];
    
    UILabel *typeWayLabelRight = [[UILabel alloc] initWithFrame:CGRectMake(lengthestWidth+ 15, typeWayLabelLeft.orginY, 0, 0)];
    if (model.type.integerValue == 3) {
        typeWayLabelRight.text = [NSString stringWithFormat:@"你未在24小时内接收%@的转账",model.userName];
    }else{
        typeWayLabelRight.text = [NSString stringWithFormat:@"%@(%@)",model.remark,model.userName];
    }
    typeWayLabelRight.numberOfLines = 0;
    typeWayLabelRight.font = [UIFont systemFontOfSize:14];
    titleSize = [typeWayLabelRight.text boundingRectWithSize:CGSizeMake(_contentV.sizeWidth - typeWayLabelRight.orginX - 15, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:typeWayLabelRight.font} context:nil].size;
    typeWayLabelRight.frame = CGRectMake(typeWayLabelRight.orginX, typeWayLabelRight.orginY, titleSize.width, titleSize.height);
    [_contentV addSubview:typeWayLabelRight];
    
    //提现时间/商品详情
    UILabel *secondLineLabelLeft = [[UILabel alloc] initWithFrame:CGRectMake(15, typeWayLabelRight.allHeight + 10, 0, 0)];
    if (model.type.integerValue == 3) {
        secondLineLabelLeft.text = @"退还时间:";
    }else{
        secondLineLabelLeft.text = @"提现时间:";
    }
    
    secondLineLabelLeft.font = [UIFont systemFontOfSize:14];
    secondLineLabelLeft.textColor = kColorFrom0x(0x666666);
    titleSize = [secondLineLabelLeft.text boundingRectWithSize:CGSizeMake(kScreenSize.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:secondLineLabelLeft.font} context:nil].size;
    secondLineLabelLeft.frame = CGRectMake(secondLineLabelLeft.orginX, secondLineLabelLeft.orginY, titleSize.width, titleSize.height);
    [_contentV addSubview:secondLineLabelLeft];
    
    UILabel *secondLineLabelRight = [[UILabel alloc] initWithFrame:CGRectMake(lengthestWidth + 15, secondLineLabelLeft.orginY, 0, 0)];
    secondLineLabelRight.numberOfLines = 0;
    secondLineLabelRight.text = [BGDateHelper getTimeArrayByTimeString:model.startDate][6];
    secondLineLabelRight.font = [UIFont systemFontOfSize:14];
    titleSize = [secondLineLabelRight.text boundingRectWithSize:CGSizeMake(_contentV.sizeWidth - secondLineLabelRight.orginX - 15, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:secondLineLabelRight.font} context:nil].size;
    secondLineLabelRight.frame = CGRectMake(secondLineLabelRight.orginX, secondLineLabelRight.orginY, titleSize.width, titleSize.height);
    [_contentV addSubview:secondLineLabelRight];
    
    //退款原因/预计到账时间/到账时间/交易状态
    UILabel *thirdLineLabelLeft = [[UILabel alloc] initWithFrame:CGRectMake(15, secondLineLabelRight.allHeight + 10, 0, 0)];
    if (model.type.integerValue == 3) {
        thirdLineLabelLeft.text = @"转账时间:";
    }else if(model.type.integerValue == 2){
        thirdLineLabelLeft.text = @"到账时间:";
    }else{
        thirdLineLabelLeft.text = @"预计到账时间:";
    }
    
    thirdLineLabelLeft.font = [UIFont systemFontOfSize:14];
    thirdLineLabelLeft.textColor = kColorFrom0x(0x666666);
    titleSize = [thirdLineLabelLeft.text boundingRectWithSize:CGSizeMake(kScreenSize.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:thirdLineLabelLeft.font} context:nil].size;
    thirdLineLabelLeft.frame = CGRectMake(thirdLineLabelLeft.orginX, thirdLineLabelLeft.orginY, titleSize.width, titleSize.height);
    [_contentV addSubview:thirdLineLabelLeft];
    
    UILabel *thirdLineLabelRight = [[UILabel alloc] initWithFrame:CGRectMake(lengthestWidth + 15, thirdLineLabelLeft.orginY, 0, 0)];
    thirdLineLabelRight.numberOfLines = 0;
    thirdLineLabelRight.text = [BGDateHelper getTimeArrayByTimeString:model.endDate][6];
    thirdLineLabelRight.font = [UIFont systemFontOfSize:14];
    titleSize = [thirdLineLabelRight.text boundingRectWithSize:CGSizeMake(_contentV.sizeWidth - thirdLineLabelRight.orginX - 15, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:thirdLineLabelRight.font} context:nil].size;
    thirdLineLabelRight.frame = CGRectMake(thirdLineLabelRight.orginX, thirdLineLabelRight.orginY, titleSize.width, titleSize.height);
    [_contentV addSubview:thirdLineLabelRight];
    
    //交易单号
    UILabel *fourLineLabelLeft = [[UILabel alloc] initWithFrame:CGRectMake(15, thirdLineLabelRight.allHeight + 10, 0, 0)];
//    fourLineLabelLeft.text = @"退款原因:";
//    fourLineLabelLeft.font = [UIFont systemFontOfSize:14];
//    fourLineLabelLeft.textColor = kColorFrom0x(0x666666);
//    titleSize = [fourLineLabelLeft.text boundingRectWithSize:CGSizeMake(kScreenSize.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:fourLineLabelLeft.font} context:nil].size;
//    fourLineLabelLeft.frame = CGRectMake(fourLineLabelLeft.orginX, fourLineLabelLeft.orginY, titleSize.width, titleSize.height);
//    [_contentV addSubview:fourLineLabelLeft];
    
    UILabel *fourLineLabelRight = [[UILabel alloc] initWithFrame:CGRectMake(lengthestWidth + 15, fourLineLabelLeft.orginY, 0, 0)];
//    fourLineLabelRight.text = @"微信红包超过24小时未被领取";
//    fourLineLabelRight.font = [UIFont systemFontOfSize:14];
//    titleSize = [fourLineLabelRight.text boundingRectWithSize:CGSizeMake(_contentV.sizeWidth - fourLineLabelRight.orginX - 15, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:fourLineLabelRight.font} context:nil].size;
//    fourLineLabelRight.frame = CGRectMake(fourLineLabelRight.orginX, fourLineLabelRight.orginY, titleSize.width, titleSize.height);
//    [_contentV addSubview:fourLineLabelRight];
    
    //备注
    UILabel *fiveLineLabelLeft = [[UILabel alloc] initWithFrame:CGRectMake(15, fourLineLabelRight.allHeight, 0, 0)];
    UILabel *fiveLineLabelRight = [[UILabel alloc] initWithFrame:CGRectMake(lengthestWidth + 15, fiveLineLabelLeft.orginY, 0, 0)];
    fiveLineLabelRight.numberOfLines = 0;
    NSInteger lineImageHeightSpace = 15;
    if (model.type.integerValue == 3) {
        fiveLineLabelLeft.text = @"备注:";
        fiveLineLabelLeft.font = [UIFont systemFontOfSize:14];
        fiveLineLabelLeft.textColor = kColorFrom0x(0x666666);
        titleSize = [fiveLineLabelLeft.text boundingRectWithSize:CGSizeMake(kScreenSize.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:fiveLineLabelLeft.font} context:nil].size;
        fiveLineLabelLeft.frame = CGRectMake(fiveLineLabelLeft.orginX, fiveLineLabelLeft.orginY, titleSize.width, titleSize.height);
        [_contentV addSubview:fiveLineLabelLeft];
        
        
        fiveLineLabelRight.text = @"了解完整零钱收支明细，可点击查看详情";
        fiveLineLabelRight.font = [UIFont systemFontOfSize:14];
        titleSize = [fiveLineLabelRight.text boundingRectWithSize:CGSizeMake(_contentV.sizeWidth - fiveLineLabelRight.orginX - 15, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:fiveLineLabelRight.font} context:nil].size;
        fiveLineLabelRight.frame = CGRectMake(fiveLineLabelRight.orginX, fiveLineLabelRight.orginY, titleSize.width, titleSize.height);
        [_contentV addSubview:fiveLineLabelRight];
    }else if (model.type.integerValue == 2){
        fiveLineLabelLeft.text = @"备注:";
        fiveLineLabelLeft.font = [UIFont systemFontOfSize:14];
        fiveLineLabelLeft.textColor = kColorFrom0x(0x666666);
        titleSize = [fiveLineLabelLeft.text boundingRectWithSize:CGSizeMake(kScreenSize.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:fiveLineLabelLeft.font} context:nil].size;
        fiveLineLabelLeft.frame = CGRectMake(fiveLineLabelLeft.orginX, fiveLineLabelLeft.orginY, titleSize.width, titleSize.height);
        [_contentV addSubview:fiveLineLabelLeft];
        
        
        fiveLineLabelRight.text = @"你的零钱提现已到账至银行卡";
        fiveLineLabelRight.font = [UIFont systemFontOfSize:14];
        titleSize = [fiveLineLabelRight.text boundingRectWithSize:CGSizeMake(_contentV.sizeWidth - fiveLineLabelRight.orginX - 15, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:fiveLineLabelRight.font} context:nil].size;
        fiveLineLabelRight.frame = CGRectMake(fiveLineLabelRight.orginX, fiveLineLabelRight.orginY, titleSize.width, titleSize.height);
        [_contentV addSubview:fiveLineLabelRight];
    }else{
        lineImageHeightSpace = 5;
    }

    
    //分割线
    UIImageView *underLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, fiveLineLabelRight.allHeight + lineImageHeightSpace, _contentV.allWidth, 0.5)];
    underLine.backgroundColor = kColorFrom0x(0xd6d6d6);
    [_contentV addSubview:underLine];
    
    //查看详情
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, underLine.allHeight + 10, 0, 0)];
    detailLabel.text = @"查看详情";
    detailLabel.font = [UIFont systemFontOfSize:15];
    titleSize = [detailLabel.text boundingRectWithSize:CGSizeMake(kScreenSize.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:detailLabel.font} context:nil].size;
    detailLabel.frame = CGRectMake(detailLabel.orginX, detailLabel.orginY, titleSize.width, titleSize.height);
    [_contentV addSubview:detailLabel];
    
    UIImageView *singleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_contentV.allWidth - 20 - 16, detailLabel.orginY + 2, 8, 12)];
    singleImageView.image = [UIImage imageNamed:@"youkuohao.png"];
    [_contentV addSubview:singleImageView];
    
    //设置内容view高度
    _contentV.frame = CGRectMake(_contentV.orginX, _contentV.orginY, _contentV.sizeWidth, detailLabel.allHeight + 10);
    [self addSubview:_contentV];
}

- (CGFloat)cellHeight{
    return _contentV.allHeight;
}

/**
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
- (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
