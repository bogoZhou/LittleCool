//
//  BGScanQRCodeHelper.m
//  BGQRCode
//
//  Created by 周博 on 16/9/7.
//  Copyright © 2016年 BogoZhou. All rights reserved.
//

#import "BGScanQRCodeHelper.h"
#import <AVFoundation/AVFoundation.h>

static BGScanQRCodeHelper *manager = nil;
static dispatch_once_t once;
@interface BGScanQRCodeHelper ()<AVCaptureMetadataOutputObjectsDelegate>
{
    //输入输出中间池
    AVCaptureSession * _avSession;
    
    //捕捉视频采集预览层
    AVCaptureVideoPreviewLayer * _avPreviewLayer;
    
    //捕捉元数据输出
    AVCaptureMetadataOutput * _avOutput;
    
    //捕捉设备输入
    AVCaptureDeviceInput * _avInput;
    
    //图层的父视图
    UIView * _superView;
}
@end

@implementation BGScanQRCodeHelper

+(BGScanQRCodeHelper *)manager{
    dispatch_once(&once, ^{
        manager = [BGScanQRCodeHelper new];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //初始化链接对象
        _avSession = [AVCaptureSession new];
        //设置高采集率
        [_avSession setSessionPreset:AVCaptureSessionPresetHigh];
        //判断是否是模拟器
        if (!TARGET_IPHONE_SIMULATOR) {
            //获取摄像设备
            AVCaptureDevice * deviece = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            //创建输入流
            _avInput = [AVCaptureDeviceInput deviceInputWithDevice:deviece error:nil];
            [_avSession addInput:_avInput];
            
            //创建输出流
            _avOutput = [AVCaptureMetadataOutput new];
            //设置代理,在主线程刷新
            [_avOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            [_avSession addOutput:_avOutput];
            
            //设置扫码支持的编码格式 ->二维码和条形码
            _avOutput.metadataObjectTypes = @[
                                              AVMetadataObjectTypeQRCode,
                                              AVMetadataObjectTypeCode128Code,
                                              AVMetadataObjectTypeEAN8Code,
                                              AVMetadataObjectTypeEAN13Code,
                                              AVMetadataObjectTypeCode39Mod43Code,
                                              AVMetadataObjectTypeCode39Code,
                                              AVMetadataObjectTypeUPCECode,
                                              AVMetadataObjectTypeCode93Code,
                                              AVMetadataObjectTypePDF417Code,
                                              AVMetadataObjectTypeAztecCode,
                                              AVMetadataObjectTypeInterleaved2of5Code,
                                              AVMetadataObjectTypeITF14Code,
                                              AVMetadataObjectTypeDataMatrixCode];
        }
        _avPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_avSession];
        _avPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return self;
}

- (void)startRunning{
    //开始捕获
    _isRunning = YES;
    [_avSession startRunning];
}

- (void)stopRunning{
    //停止捕获
    _isRunning = NO;
    [_avSession stopRunning];
}

- (void)setSupperView:(UIView *)superView{
    _superView = superView;
    _avPreviewLayer.frame = superView.frame;
    [superView.layer insertSublayer:_avPreviewLayer atIndex:0];
}

/**
 *  设置扫描范围和大小
 *
 *  @param scanningFrame 扫描范围
 *  @param scanView      扫描框的大小
 */
- (void)setScanningRect:(CGRect)scanningFrame scanView:(UIView *)scanView{
    CGFloat x,y,height,width;
    x = scanningFrame.origin.y / _avPreviewLayer.frame.size.height;
    y = scanningFrame.origin.x / _avPreviewLayer.frame.size.width;
    height = scanningFrame.size.width / _avPreviewLayer.frame.size.width;
    width = scanningFrame.size.height / _avPreviewLayer.frame.size.height;
    
    _avOutput.rectOfInterest  = CGRectMake(x, y, width, height);
    
    if (scanView) {
        scanView.frame = scanningFrame;
        if (_superView) {
            [_superView addSubview:scanView];
        }
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject * metadataObj = metadataObjects.firstObject;
        [_delegate resaultString:metadataObj.stringValue];
        NSLog(@"%@",metadataObj.stringValue);
    }
}


@end
