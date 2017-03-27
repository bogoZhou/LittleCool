//
//  BGScanQRCodeHelper.h
//  BGQRCode
//
//  Created by 周博 on 16/9/7.
//  Copyright © 2016年 BogoZhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol BGScanQRCodeHelperDelegate <NSObject>

/**
 *  设置代理,
 *
 *  @param resault 返回扫描结果
 */
- (void)resaultString:(NSString *)resault;

@end

@interface BGScanQRCodeHelper : NSObject

@property (nonatomic,assign) id <BGScanQRCodeHelperDelegate> delegate;

@property (nonatomic,assign) BOOL isRunning;

+(BGScanQRCodeHelper *)manager;

/**
 *  开始扫描
 */
- (void)startRunning;

/**
 *  停止扫描
 */
- (void)stopRunning;

/**
 *  设置根视图
 *
 *  @param superView 根视图
 */
- (void)setSupperView:(UIView *)superView;
/**
 *  设置扫描范围和大小
 *
 *  @param scanningFrame 扫描范围
 *  @param scanView      扫描框的大小
 */
- (void)setScanningRect:(CGRect)scanningFrame scanView:(UIView *)scanView;
@end
