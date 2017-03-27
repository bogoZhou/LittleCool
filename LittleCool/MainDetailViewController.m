//
//  MainDetailViewController.m
//  LittleCool
//
//  Created by 周博 on 17/3/13.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "MainDetailViewController.h"
#import "TYVideoPlayerController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MBProgressHUD+MJ.h"
#import "lame.h"
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "VideoService.h"
#import <AVFoundation/AVVideoCompositing.h>

#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )


@interface MainDetailViewController ()<TYVideoPlayerControllerDelegate,AVAudioRecorderDelegate>
{
    BOOL _beginRecording;
    CGFloat _longTime;
    NSString *localUrlString;
    float _yuansheng;
    float _luyin;
}
@property (nonatomic, weak) TYVideoPlayerController *playerController;
@property (nonatomic,strong) AVAudioRecorder *audioRecorder;//音频录音机
@property (nonatomic,copy) NSString *cafPathStr;
@property (nonatomic,copy) NSString *mp3PathStr;

@property(nonatomic, strong) AVAsset *videoAsset;
@property (nonatomic,strong) AVAsset *audioAsset;

@property (nonatomic,strong) NSMutableArray *audioMixParams;

@property(nonatomic,copy)NSURL * videoUrl;
@property (nonatomic,strong) MBProgressHUD *hud;

@property (nonatomic,strong) NSString *fileUrl;

@property AVMutableComposition *mutableComposition;
@property AVMutableVideoComposition *mutableVideoComposition;
@property AVMutableAudioMix *mutableAudioMix;
@property CALayer *watermarkLayer;


@end

@implementation MainDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = NO;
    [self navBarTitle:@"配音"];
    [self navBarbackButton:@"        "];
    [self upDateUI];
    [self addVideoPlayerController];
    if ([BGFunctionHelper isNULLOfString:_model.video_url]) {
        [self loadLocalVideo:_model.url];
    }else{
        [self loadVodVideo];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _beginRecording = NO;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGRect frame = self.viewAudio.frame;
    if (_playerController.isFullScreen) {
        _playerController.view.frame = CGRectMake(0, 0, MAX(CGRectGetHeight(frame), CGRectGetWidth(frame)), MIN(CGRectGetHeight(frame), CGRectGetWidth(frame)));
    }else {
//        _playerController.view.frame = CGRectMake(0, 0, MIN(CGRectGetHeight(frame), CGRectGetWidth(frame)), MIN(CGRectGetHeight(frame), CGRectGetWidth(frame))*9/16);
        _playerController.view.frame = CGRectMake(0, 0, frame.size.width,frame.size.height);

    }
}

- (BOOL)prefersStatusBarHidden
{
    if (!_playerController || !_playerController.isFullScreen) {
        return NO;
    }
    return [_playerController isControlViewHidden];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (UIStatusBarAnimation )preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationFade;
}

#pragma mark - 初始化UI
- (void)upDateUI{
    _yuansheng = 0.5;
    _luyin = 0.5;
    _audioMixParams = [NSMutableArray array];
    
    _labelAudioName.text = _model.title;
    _labelAudioContent.text = _model.introduce;
    _labelAudioContent.numberOfLines = 0;
    CGSize titleSize = [_labelAudioContent.text boundingRectWithSize:CGSizeMake(_labelAudioContent.sizeWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_labelAudioContent.font} context:nil].size;
    
    _labelAudioContent.frame = CGRectMake(_labelAudioContent.orginX, _labelAudioContent.orginY, _labelAudioContent.sizeWidth, titleSize.height);
    
    _viewIWantoP.layer.masksToBounds = YES;
    _viewIWantoP.layer.cornerRadius = _viewIWantoP.sizeWidth/2;
    
    UIImage *thumbImageNormal = [UIImage imageNamed:@"play-point"];
    
    [_sliderOne setThumbImage:[BGControlHelper originImage:thumbImageNormal scaleToSize:CGSizeMake(20, 20)] forState:UIControlStateNormal];
    [_sliderTwo setThumbImage:[BGControlHelper originImage:thumbImageNormal scaleToSize:CGSizeMake(20, 20)] forState:UIControlStateNormal];
    
}

#pragma mark - 播放视频

- (void)addVideoPlayerController
{
    TYVideoPlayerController *playerController = [[TYVideoPlayerController alloc]init];
    //playerController.shouldAutoplayVideo = NO;
    playerController.delegate = self;
    [self addChildViewController:playerController];
    [self.viewAudio addSubview:playerController.view];
    _playerController = playerController;
}

    // 点播
- (void)loadVodVideo
{

    NSURL *streamURL = [NSURL URLWithString:_model.video_url];

    [_playerController loadVideoWithStreamURL:streamURL];
}

    // 本地播放
- (void)loadLocalVideo:(NSString *)path
{
    
//    NSString* path = [[NSBundle mainBundle] pathForResource:@"test_264" ofType:@"mp4"];
    if (!path) {
        UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"本地文件不存在！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alerView show];
        return;
    }
    NSURL* streamURL = [NSURL fileURLWithPath:path];
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    //设置为播放
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];

    
    [_playerController loadVideoWithStreamURL:streamURL];
}

// 本地播放
- (void)loadLocalmy:(NSURL *)path
{

    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    //设置为播放
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    [_playerController loadVideoWithStreamURL:path];
}

#pragma mark - delegate

- (void)videoPlayerController:(TYVideoPlayerController *)videoPlayerController readyToPlayURL:(NSURL *)streamURL
{
    if (_beginRecording) {
        [self startRecordNotice];
    }
}

- (void)videoPlayerController:(TYVideoPlayerController *)videoPlayerController endToPlayURL:(NSURL *)streamURL
{
//    kAlert(@"播放完毕");
    _beginRecording = NO;

    
}

- (void)videoPlayerController:(TYVideoPlayerController *)videoPlayerController handleEvent:(TYVideoPlayerControllerEvent)event
{
    switch (event) {
        case TYVideoPlayerControllerEventTapScreen:
            [self setNeedsStatusBarAppearanceUpdate];
            break;
        default:
            break;
    }
}

#pragma mark - rotate

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //发生在翻转开始之前
    CGRect bounds = self.view.frame;
    [UIView animateWithDuration:duration animations:^{
        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
            _playerController.view.frame = CGRectMake(0, 0, MAX(CGRectGetHeight(bounds), CGRectGetWidth(bounds)), MIN(CGRectGetHeight(bounds), CGRectGetWidth(bounds)));
        }else {
            _playerController.view.frame = CGRectMake(0, 0, MIN(CGRectGetHeight(bounds), CGRectGetWidth(bounds)), MIN(CGRectGetHeight(bounds), CGRectGetWidth(bounds))*9/16);
        }
    }];
}

#pragma mark - 点击事件
//试听
- (IBAction)listenButtonClick:(UIButton *)sender {
//    NSArray* myPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString* myDocPath = [myPaths objectAtIndex:0];
//    NSString *name = [NSString stringWithFormat:@"%@_%@.mp4",_model.id,@"final"];
//    NSString* outPutFilePath = [myDocPath stringByAppendingPathComponent:name];
//    
    NSString *name = [NSString stringWithFormat:@"%@_%@.mp4",_model.id,@"final"];
    //    NSString* outPutFilePath = [myDocPath stringByAppendingPathComponent:name];
    
    NSString *outPutFilePath = [BGFunctionHelper filePath:name];
    
    [self loadLocalVideo:outPutFilePath];
}

//删除
- (IBAction)deleteButtonClick:(UIButton *)sender {
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否要删除视频" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray* myPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* myDocPath = [myPaths objectAtIndex:0];
        NSString *name = [NSString stringWithFormat:@"%@_%@.mp4",_model.id,@"final"];
        NSString* outPutFilePath = [myDocPath stringByAppendingPathComponent:name];


        [self deleteOldRecordFile:outPutFilePath];
        
        [_beginButton setImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
        _beginButton.tag = 99;
        _labelPeiyin.text = @"开始配音";
        _listenButton.hidden = YES;
        _deleteButton.hidden = YES;
        
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:nil];
}


//我要配音
- (IBAction)IWantoPButtonClick:(UIButton *)sender {
    _viewIWantoP.hidden = YES;
    [self loadAudioIntoLocal];

}

//开始配音
- (IBAction)beginPButtonClick:(UIButton *)sender {
//    kAlert(@"开始配音");
    
    if (sender.tag == 99) {//开始配音
        //在这里边播放视频,同时开始录音
        _beginRecording = YES;
        _longTime= _playerController.videoPlayer.duration;
//        _longTime = 5;
        
        self.cafPathStr = [BGFunctionHelper filePath:[NSString stringWithFormat:@"%@_%@.caf",_model.id,@"audio"]];
        [self deleteOldRecordFile:_cafPathStr];
        
        
        
//        if ([BGFunctionHelper isNULLOfString:_model.video_url]) {
            [self loadLocalVideo:_fileUrl];
//            [self loadLocalmy:_model.localUrl];
//        }else{
//            [self loadVodVideo];
//        }
        [self Progress];
    }else{//保存到相册
        [self save];
    }
}

//混音比例
- (IBAction)sliderOneChangedFun:(UISlider *)sender {
    NSLog(@"原音%.0f/配音%.0f",sender.value * 100,(1-sender.value) *100);
    _yuansheng =sender.value;
    _luyin =1- sender.value;
    [self merge];
}




//配音声调
- (IBAction)sliderTwoChangedFun:(UISlider *)sender {
    NSLog(@"slider -> %f",sender.value);
}

//点击添加水印
- (IBAction)waterMarkButtonClick:(UIButton *)sender {
    kAlert(@"添加水印");
}



#pragma mark - 存储方法

- (void)save{
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    
    
    NSArray* myPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* myDocPath = [myPaths objectAtIndex:0];
    NSString *name = [NSString stringWithFormat:@"%@_%@.mp4",_model.id,@"final"];
    NSString* outPutFilePath = [myDocPath stringByAppendingPathComponent:name];
    NSURL *url = [NSURL URLWithString:outPutFilePath];
    
    [library saveVideo:url toAlbum:@"有点逗" completion:^(NSURL *assetURL, NSError *error) {
        kAlert(@"保存成功");
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        kAlert(@"保存失败");
    }];
    
//    if(UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(outPutFilePath))
//    {
//        UISaveVideoAtPathToSavedPhotosAlbum(outPutFilePath,self,nil,NULL);
//        kAlert(@"保存成功");
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//    
//    else {
//        NSLog(@"no available");
//        kAlert(@"保存失败");
//    }
}
#pragma mark - 开始录音
#pragma mark -  Getter
/**
 *  获得录音机对象
 *
 *  @return 录音机对象
 */
-(AVAudioRecorder *)audioRecorder{
    if (!_audioRecorder) {
        //创建录音文件保存路径
        
        self.cafPathStr = [BGFunctionHelper filePath:[NSString stringWithFormat:@"%@_%@.caf",_model.id,@"audio"]];
        self.mp3PathStr = [BGFunctionHelper filePath:[NSString stringWithFormat:@"%@_%@.mp3",_model.id,@"audio"]];
        
        NSURL *url=[NSURL URLWithString:_cafPathStr];
        //创建录音格式设置
        NSDictionary *setting=[self getAudioSetting];
        //创建录音机
        NSError *error=nil;
        
        _audioRecorder=[[AVAudioRecorder alloc]initWithURL:url settings:setting error:&error];
        _audioRecorder.delegate=self;
        _audioRecorder.meteringEnabled=YES;//如果要监控声波则必须设置为YES
        if (error) {
            NSLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioRecorder;
}

/**
 *  取得录音文件设置
 *
 *  @return 录音设置
 */
-(NSDictionary *)getAudioSetting{
    //LinearPCM 是iOS的一种无损编码格式,但是体积较为庞大
    //录音设置
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] init];
    //录音格式 无法使用
    [recordSettings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey: AVFormatIDKey];
    //采样率
    [recordSettings setValue :[NSNumber numberWithFloat:11025.0] forKey: AVSampleRateKey];//44100.0
    //通道数
    [recordSettings setValue :[NSNumber numberWithInt:2] forKey: AVNumberOfChannelsKey];
    //线性采样位数
    //[recordSettings setValue :[NSNumber numberWithInt:16] forKey: AVLinearPCMBitDepthKey];
    //音频质量,采样质量
    [recordSettings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
    
    return recordSettings;
}

#pragma mark - caf转mp3
- (void)audio_PCMtoMP3
{
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([self.cafPathStr cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([self.mp3PathStr cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        NSLog(@"MP3生成成功: %@",self.mp3PathStr);
    }
    
}

#pragma mark - 录音方法

- (void)startRecordNotice{
    
//    [self stopMusicWithUrl:[NSURL URLWithString:self.cafPathStr]];
//    
//    [self.voiceView.layer removeAllAnimations];
//    self.voiceView.image = [UIImage imageNamed:@"voice3"];
//    
//    if ([self.audioRecorder isRecording]) {
//        [self.audioRecorder stop];
//    }
    
    NSLog(@"----------开始录音----------");
//    [self deleteOldRecordFile:_mp3PathStr];  //如果不删掉，会在原文件基础上录制；虽然不会播放原来的声音，但是音频长度会是录制的最大长度。
    NSLog(@"检测caf文件是否存在");
    
    
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    
    if (![self.audioRecorder isRecording]) {//0--停止、暂停，1-录制中
        
        [self.audioRecorder record];//首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
    }
    
}

- (void)stopRecordNotice
{
    NSLog(@"----------结束录音----------");
    [self.audioRecorder pause];
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
//    [self.audioRecorder stop];
    

    
//    [self audio_PCMtoMP3];
 
}

-(void)deleteOldRecordFile:(NSString *)filePath{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (!blHave) {
        NSLog(@"不存在");
        return ;
    }else {
        NSLog(@"存在");
        BOOL blDele= [fileManager removeItemAtPath:filePath error:nil];
        if (blDele) {
            NSLog(@"删除成功");
        }else {
            NSLog(@"删除失败");
        }
    }
}
#pragma mark - 视频下载
/**
 * 下载文件
 */
- (void)loadAudioIntoLocal{
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    // Set the label text.
    _hud.label.text = NSLocalizedString(@"视频下载中...", @"HUD loading title");
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSArray* myPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* myDocPath = [myPaths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@.mp4",_model.id];
    NSString  *fullPath = [NSString stringWithFormat:@"%@/%@", myDocPath, fileName];
    NSURL *url = [NSURL URLWithString:_model.video_url];
    if ([BGFunctionHelper isNULLOfString:_model.video_url]) {
        url = [NSURL URLWithString:_model.url];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *task =
    [manager downloadTaskWithRequest:request
                            progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                return [NSURL fileURLWithPath:fullPath];
                                
                            }
                   completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                        NSString *fPath = [BGFunctionHelper filePath:fileName];
                       NSLog(@"filePath -> %@",fPath);
//                       kAlert(@"视频下载完成");
                       [_hud hideAnimated:YES];
                       _fileUrl = fPath;
                       [self loadLocalVideo:fPath];
                   }];
    [task resume];
}

#pragma 视频音频合成
// 混合音乐
- (void)merge{
    _audioMixParams = [NSMutableArray array];
    // 声音来源
    NSString *soundsStr = [BGFunctionHelper filePath:[NSString stringWithFormat:@"%@_%@.caf",_model.id,@"audio"]];
    NSURL *audioInputUrl = [NSURL fileURLWithPath:soundsStr];
    // 视频来源
    NSString *videoString = [BGFunctionHelper filePath:[NSString stringWithFormat:@"%@.mp4",_model.id]];
//    NSURL *videoInputUrl = [NSURL fileURLWithPath:videoString];
    NSURL *videoInputUrl;
    if ([BGFunctionHelper isNULLOfString:_model.video_url]) {
        videoInputUrl = _model.localUrl;
    }else{
        videoInputUrl = [NSURL fileURLWithPath:videoString];
    }
    

    NSString *name = [NSString stringWithFormat:@"%@_%@.mp4",_model.id,@"final"];
    
    
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:soundsStr];
    if (!blHave) {
        NSLog(@" soundsStr不存在- > %@",soundsStr);
        //        return ;
    }else {
        NSLog(@"soundsStr存在- > %@",soundsStr);
    }
    
    blHave=[[NSFileManager defaultManager] fileExistsAtPath:videoString];
    if (!blHave) {
        NSLog(@" videoString不存在- > %@",videoString);
        //        return ;
    }else {
        NSLog(@"videoString存在- > %@",videoString);
    }
    
    
        // 添加合成路径
    NSString *outPutFilePath = [BGFunctionHelper filePath:name];
            NSLog(@"录制位置");
    
    NSURL *outputFileUrl = [NSURL fileURLWithPath:outPutFilePath];
    [self deleteOldRecordFile:outPutFilePath];

    // 时间起点
    CMTime nextClistartTime = kCMTimeZero;
    // 创建可变的音视频组合
    AVMutableComposition *comosition = [AVMutableComposition composition];
    
    
    // 视频采集
    AVURLAsset *videoAsset = [[AVURLAsset alloc] initWithURL:videoInputUrl options:nil];
    // 视频时间范围
    CMTimeRange videoTimeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
    // 视频通道 枚举 kCMPersistentTrackID_Invalid = 0
    AVMutableCompositionTrack *videoTrack = [comosition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    // 视频采集通道
    AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoAssetTrack];
    //  把采集轨道数据加入到可变轨道之中
    [videoTrack insertTimeRange:videoTimeRange ofTrack:videoAssetTrack atTime:nextClistartTime error:nil];

 

    
//    [self applyVideoEffectsToComposition:self.mutableVideoComposition size:comosition.naturalSize];
    
    
    [videoTrack setPreferredTransform:videoAssetTrack.preferredTransform];
//    videoTrack.preferredTransform= CGAffineTransformMakeRotation(-1);
    
    // 声音采集
    AVURLAsset *audioAsset = [[AVURLAsset alloc] initWithURL:audioInputUrl options:nil];
    // 因为视频短这里就直接用视频长度了,如果自动化需要自己写判断
    CMTimeRange audioTimeRange = videoTimeRange;
    // 音频通道
    AVMutableCompositionTrack *audioTrack = [comosition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    // 音频采集通道
    AVAssetTrack *audioAssetTrack = [[audioAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    // 加入合成轨道之中
//    [audioTrack insertTimeRange:audioTimeRange ofTrack:audioAssetTrack atTime:nextClistartTime error:nil];
    [self setUpAndAddAudioBySoundAsset:audioAsset toComposition:audioTrack sourceAudioTrack:audioAssetTrack timeRange:videoTimeRange volumeNum:_luyin];
    
    // 声音采集
    AVURLAsset *videoAsset1 = [[AVURLAsset alloc] initWithURL:videoInputUrl options:nil];
    // 因为视频短这里就直接用视频长度了,如果自动化需要自己写判断
    CMTimeRange videoTimeRange1 = videoTimeRange;
    // 音频通道
    AVMutableCompositionTrack *videoTrack1 = [comosition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    // 音频采集通道
    AVAssetTrack *videoAssetTrack1 = [[videoAsset1 tracksWithMediaType:AVMediaTypeAudio] firstObject];
    // 加入合成轨道之中
//    [videoTrack1 insertTimeRange:videoTimeRange1 ofTrack:videoAssetTrack1 atTime:nextClistartTime error:nil];
    [self setUpAndAddAudioBySoundAsset:videoAsset1 toComposition:videoTrack1 sourceAudioTrack:videoAssetTrack1 timeRange:videoTimeRange volumeNum:_yuansheng];
    
    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
    audioMix.inputParameters = [NSArray arrayWithArray:_audioMixParams];

    // 创建一个输出
    AVAssetExportSession *assetExport = [[AVAssetExportSession alloc] initWithAsset:comosition presetName:AVAssetExportPresetMediumQuality];
    assetExport.audioMix = audioMix;
    // 输出类型
    assetExport.outputFileType = AVFileTypeQuickTimeMovie;
    // 优化
    assetExport.shouldOptimizeForNetworkUse = YES;
    
    //添加改变轨道的内容
    assetExport.videoComposition = self.mutableVideoComposition;
    
    // 输出地址
    assetExport.outputURL = outputFileUrl;
    // 合成完毕
    [assetExport exportAsynchronouslyWithCompletionHandler:^{
        // 回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:outputFileUrl.path];
            if (!blHave) {
                NSLog(@"不存在- > %@",outputFileUrl.path);
                //        return ;
            }else {
                NSLog(@"存在- > %@",outputFileUrl.path);
            }
            
//            [MBProgressHUD hideHUD];
//            [MBProgressHUD showSuccess:@"合成完成"];
//            // 调用播放方法
//            _listenButton.hidden = NO;
//            _deleteButton.hidden = NO;
//            [_beginButton setImage:[UIImage imageNamed:@"complete"] forState:UIControlStateNormal];
//            _beginButton.tag = 98;
//            _labelPeiyin.text = @"保存";
//            localUrlString = outPutFilePath;
//            [self loadLocalVideo:assetExport.outputURL.path];
            
            NSString *name1 = [NSString stringWithFormat:@"%@_%@_waterMark.mp4",_model.id,@"final"];
            NSString *outPutFilePath1 = [BGFunctionHelper filePath:name1];
//            [self addwater:assetExport.outputURL outPutUrl:outPutFilePath1];
            [self deleteOldRecordFile:outPutFilePath1];

            self.videoUrl = [NSURL fileURLWithPath:outPutFilePath1];
            [self testMark:[AVAsset assetWithURL:assetExport.outputURL]];
//           [VideoService loadVideoByUrl:assetExport.outputURL andOutputUrl:outPutFilePath1 andImage:[UIImage imageNamed:@"selecte"] andVideoSize:videoAssetTrack.naturalSize andImgRect:CGRectMake(0, 0, 50, 50) blockHandler:^(AVAssetExportSession *handle) {
//               [MBProgressHUD hideHUD];
//               [MBProgressHUD showSuccess:@"合成完成"];
//               // 调用播放方法
//               _listenButton.hidden = NO;
//               _deleteButton.hidden = NO;
//               [_beginButton setImage:[UIImage imageNamed:@"complete"] forState:UIControlStateNormal];
//               _beginButton.tag = 98;
//               _labelPeiyin.text = @"保存";
//               localUrlString = outPutFilePath;
//               [self loadLocalVideo:handle.outputURL.path];
//           }];
        });
    }];
}



#pragma mark - 改变音量
- (void)setUpAndAddAudioBySoundAsset:(AVURLAsset*)soundAsset toComposition:(AVMutableCompositionTrack *)track sourceAudioTrack:(AVAssetTrack *)sourceAudioTrack timeRange:(CMTimeRange)tRange volumeNum:(float)volumeNum{
    
    NSError *error = nil;
    
    CMTime startTime = tRange.start;
    
    //Set Volume
    AVMutableAudioMixInputParameters *trackMix = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:track];

    NSLog(@"timeValue -> %f",volumeNum);
    [trackMix setVolume:volumeNum*2 atTime:startTime];
    [_audioMixParams addObject:trackMix];
    
    //Insert audio into track  //offset CMTimeMake(0, 44100)
    [track insertTimeRange:tRange ofTrack:sourceAudioTrack atTime:kCMTimeZero error:&error];
}

#pragma mark - 改变音调
- (void)setUpAndAddAudioBySoundPitchAsset:(AVURLAsset*)soundAsset toComposition:(AVMutableCompositionTrack *)track sourceAudioTrack:(AVAssetTrack *)sourceAudioTrack timeRange:(CMTimeRange)tRange volumeNum:(float)volumeNum{
    
    NSError *error = nil;
    
    CMTime startTime = tRange.start;
    
    //Set Volume
    AVMutableAudioMixInputParameters *trackMix = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:track];
    

    NSLog(@"timeValue -> %f",volumeNum);
    [trackMix setVolume:volumeNum*2 atTime:startTime];
    [_audioMixParams addObject:trackMix];
    
    //Insert audio into track  //offset CMTimeMake(0, 44100)
    [track insertTimeRange:tRange ofTrack:sourceAudioTrack atTime:kCMTimeZero error:&error];
}


#pragma mark - 添加水印
- (void)applyVideoEffectsToComposition:(AVMutableVideoComposition *)composition size:(CGSize)size
{
//    AVAssetTrack *videoAssetTrack = [[self.videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];

    // 1 - Set up the text layer
    CATextLayer *titleLayer = [CATextLayer layer];
    titleLayer.string = @"AVSE";
    titleLayer.foregroundColor = [[UIColor whiteColor] CGColor];
    titleLayer.font = (__bridge void*)[UIFont fontWithName:@"Helvetica" size:size.height/4] ;
    titleLayer.shadowOpacity = 0.5;
    titleLayer.alignmentMode = kCAAlignmentCenter;
    titleLayer.bounds = CGRectMake(0, 0, size.width/2, size.height/2);
    
    // 2 - The usual overlay
    CALayer *overlayLayer = [CALayer layer];
    [overlayLayer addSublayer:titleLayer];
//    overlayLayer.frame = CGRectMake(0, 0, size.width, size.height);
//    [overlayLayer setMasksToBounds:YES];
//    overlayLayer.position = CGPointMake(size.width/2, size.height/2);
    overlayLayer.position = CGPointMake(size.width/2, size.height/4);
    
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, size.width, size.height);
    videoLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:overlayLayer];
    
    composition.animationTool = [AVVideoCompositionCoreAnimationTool
                                 videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];

//    composition.animationTool =  [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithAdditionalLayer:overlayLayer asTrackID:videoAssetTrack.trackID];
    
}


#pragma mark - 进度条
#pragma mark - 测试进度条
- (void)Progress{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = NSLocalizedString(@"正在录音", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        // Do something useful in the background and update the HUD periodically.
        [self doSomeWorkWithProgress];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //录音完毕
            [self stopRecordNotice];
            //合成
            [self merge];
//            [self testMixture];
            [hud hideAnimated:YES];
        });
    });
}
- (void)doSomeWorkWithProgress {
    // This just increases the progress indicator in a loop.
    float progress = 0.0f;
    while (progress < 1.0f) {
        progress += 0.01f;
        dispatch_async(dispatch_get_main_queue(), ^{
            // Instead we could have also passed a reference to the HUD
            // to the HUD to myProgressTask as a method parameter.
            [MBProgressHUD HUDForView:self.navigationController.view].progress = progress;
        });
        
        usleep(_longTime * 10000);
    }
}

#pragma mark - 从相册删除
- (void)creatVidioFromPhotos{
    //首先获取相册的集合
    PHFetchResult *collectonResuts = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:[PHFetchOptions new]] ;
    //对获取到集合进行遍历
    [collectonResuts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PHAssetCollection *assetCollection = obj;
        //Camera Roll是我们写入照片的相册
        if ([assetCollection.localizedTitle isEqualToString:@"Time-lapse"])  {
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                NSArray* myPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString* myDocPath = [myPaths objectAtIndex:0];
                NSString *name = [NSString stringWithFormat:@"%@_%@.mp4",_model.id,@"final"];
                NSString* outPutFilePath = [myDocPath stringByAppendingPathComponent:name];
                NSURL *url = [NSURL URLWithString:[BGFunctionHelper filePath:outPutFilePath]];
                //请求创建一个Asset
                PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:url];
                //请求编辑相册
                PHAssetCollectionChangeRequest *collectonRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
                //为Asset创建一个占位符，放到相册编辑请求中
                PHObjectPlaceholder *placeHolder = [assetRequest placeholderForCreatedAsset ];
                //相册中添加照片
                [collectonRequest addAssets:@[placeHolder]];
            } completionHandler:^(BOOL success, NSError *error) {
                NSLog(@"Error:%@", error);
            }];
        }
    }];
}

- (void)deleteVideoFromPhoto{
    PHFetchResult *collectonResuts = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:[PHFetchOptions new]] ;
    [collectonResuts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PHAssetCollection *assetCollection = obj;
        if ([assetCollection.localizedTitle isEqualToString:@"Time-lapse"])  {
            PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:[PHFetchOptions new]];
            [assetResult enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    //获取相册的最后一张照片
                    if (idx == [assetResult count] - 1) {
                        [PHAssetChangeRequest deleteAssets:@[obj]];
                    }
                } completionHandler:^(BOOL success, NSError *error) {
                    NSLog(@"Error: %@", error);
                }];
            }];
        }
    }];
}

#pragma mark - 测试水印
-(void)addwater:(NSURL *)videoUrl outPutUrl:(NSString *)outPutUrl{
    //1 创建AVAsset实例 AVAsset包含了video的所有信息 self.videoUrl输入视频的路径
//    NSURL *url = [NSURL fileURLWithPath:videoUrl];
    self.videoAsset = [AVAsset assetWithURL:videoUrl];
    //2 创建AVMutableComposition实例. apple developer 里边的解释 【AVMutableComposition is a mutable subclass of AVComposition you use when you want to create a new composition from existing assets. You can add and remove tracks, and you can add, remove, and scale time ranges.】
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    //3 视频通道  工程文件中的轨道，有音频轨、视频轨等，里面可以插入各种对应的素材
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    //把视频轨道数据加入到可变轨道中 这部分可以做视频裁剪TimeRange
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, self.videoAsset.duration)
                        ofTrack:[[self.videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                         atTime:kCMTimeZero error:nil];
    
    [videoTrack setPreferredTransform:[[self.videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0].preferredTransform];


    
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    //把视频轨道数据加入到可变轨道中 这部分可以做视频裁剪TimeRange
    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, self.videoAsset.duration)
                        ofTrack:[[self.videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                         atTime:kCMTimeZero error:nil];
    
    AVAssetTrack *videoAssetTrack = [[mixComposition tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    NSLog(@"videoAssetTrack -> %@",videoAssetTrack);
    
    //3.1 AVMutableVideoCompositionInstruction 视频轨道中的一个视频，可以缩放、旋转等
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, self.videoAsset.duration);
    
    // 3.2 AVMutableVideoCompositionLayerInstruction 一个视频轨道，包含了这个轨道上的所有视频素材
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoAssetTrack];
    
//    UIImageOrientation videoAssetOrientation_  = UIImageOrientationUp;
//    BOOL isVideoAssetPortrait_  = NO;
//    CGAffineTransform translateToCenter;
//    CGAffineTransform mixedTransform;
//    CGAffineTransform videoTransform = videoAssetTrack.preferredTransform;
//    if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
//        videoAssetOrientation_ = UIImageOrientationRight;
//        isVideoAssetPortrait_ = YES;
//        NSLog(@"UIImageOrientationRight");
//        translateToCenter = CGAffineTransformMakeTranslation(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width);
//        mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI_2);
//    }
//    if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
//        videoAssetOrientation_ =  UIImageOrientationLeft;
//        isVideoAssetPortrait_ = YES;
//        NSLog(@"UIImageOrientationLeft");
//        translateToCenter = CGAffineTransformMakeTranslation(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width);
//        mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI_2);
//    }
//    if (videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0) {
//        videoAssetOrientation_ =  UIImageOrientationUp;
//        NSLog(@"UIImageOrientationUp");
//        
//        translateToCenter = CGAffineTransformMakeTranslation(videoAssetTrack.naturalSize.width, videoAssetTrack.naturalSize.height);
//        mixedTransform = CGAffineTransformRotate(translateToCenter,0);
//        
//    }
//    if (videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {
//        videoAssetOrientation_ = UIImageOrientationDown;
//        NSLog(@"UIImageOrientationDown");
//        translateToCenter = CGAffineTransformMakeTranslation(videoAssetTrack.naturalSize.width, videoAssetTrack.naturalSize.height);
//        mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI);
//    }
//    [videolayerInstruction setTransform:videoAssetTrack.preferredTransform atTime:kCMTimeZero];
//    [videolayerInstruction setOpacity:0.0 atTime:self.videoAsset.duration];
    
    // 3.3 - Add instructions
//    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
    mainInstruction.layerInstructions = @[videolayerInstruction];
    //AVMutableVideoComposition：管理所有视频轨道，可以决定最终视频的尺寸，裁剪需要在这里进行
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    
    CGSize naturalSize;
//    if(isVideoAssetPortrait_){
//        naturalSize = CGSizeMake(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width);
//    } else {
        naturalSize = videoAssetTrack.naturalSize;
//    }
    float renderWidth, renderHeight;
    renderWidth = naturalSize.width;
    renderHeight = naturalSize.height;
    mainCompositionInst.renderSize = naturalSize;
    mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);
    [self applyVideoEffectsToComposition:mainCompositionInst size:mainCompositionInst.renderSize];
    // 4 - 输出路径
    self.videoUrl = [NSURL fileURLWithPath:outPutUrl];
    [self deleteOldRecordFile:outPutUrl];
    // 5 - 视频文件输出
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                      presetName:AVAssetExportPresetMediumQuality];
    exporter.outputURL=self.videoUrl;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = mainCompositionInst;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //这里是输出视频之后的操作，做你想做的

            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"合成完成"];
            // 调用播放方法
            _listenButton.hidden = NO;
            _deleteButton.hidden = NO;
            [_beginButton setImage:[UIImage imageNamed:@"complete"] forState:UIControlStateNormal];
            _beginButton.tag = 98;
            _labelPeiyin.text = @"保存";
            [self loadLocalVideo:exporter.outputURL.path];
            
        });
    }];
}

- (void)testMark:(AVAsset *)asset{
    self.watermarkLayer = nil;
    CGSize videoSize;
    
    AVAssetTrack *assetVideoTrack = nil;
    AVAssetTrack *assetAudioTrack = nil;
    // Check if the asset contains video and audio tracks
    if ([[asset tracksWithMediaType:AVMediaTypeVideo] count] != 0) {
        assetVideoTrack = [asset tracksWithMediaType:AVMediaTypeVideo][0];
    }
    if ([[asset tracksWithMediaType:AVMediaTypeAudio] count] != 0) {
        assetAudioTrack = [asset tracksWithMediaType:AVMediaTypeAudio][0];
    }
    
    CMTime insertionPoint = kCMTimeZero;
    NSError *error = nil;
    
    
    // Step 1
    // Create a composition with the given asset and insert audio and video tracks into it from the asset
    if(!self.mutableComposition) {
        
        // Check if a composition already exists, else create a composition using the input asset
        self.mutableComposition = [AVMutableComposition composition];
        
        // Insert the video and audio tracks from AVAsset
        if (assetVideoTrack != nil) {
            AVMutableCompositionTrack *compositionVideoTrack = [self.mutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
            [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, [asset duration]) ofTrack:assetVideoTrack atTime:insertionPoint error:&error];
            [compositionVideoTrack setPreferredTransform:asset.preferredTransform];
        }
        if (assetAudioTrack != nil) {
            AVMutableCompositionTrack *compositionAudioTrack = [self.mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
            [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, [asset duration]) ofTrack:assetAudioTrack atTime:insertionPoint error:&error];
        }
        
    }
    
    
    // Step 2
    // Create a water mark layer of the same size as that of a video frame from the asset
    if ([[self.mutableComposition tracksWithMediaType:AVMediaTypeVideo] count] != 0) {
        self.watermarkLayer = [CALayer layer];
        if(!self.mutableVideoComposition) {
            
            // build a pass through video composition
            self.mutableVideoComposition = [AVMutableVideoComposition videoComposition];
            self.mutableVideoComposition.frameDuration = CMTimeMake(1, 30); // 30 fps
            self.mutableVideoComposition.renderSize = assetVideoTrack.naturalSize;
            self.mutableVideoComposition.renderScale = 1.0;
            
            AVMutableVideoCompositionInstruction *passThroughInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
            passThroughInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, [self.mutableComposition duration]);
            
            AVAssetTrack *videoTrack = [self.mutableComposition tracksWithMediaType:AVMediaTypeVideo][0];
            AVMutableVideoCompositionLayerInstruction *passThroughLayer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
            [passThroughLayer setTransform:asset.preferredTransform atTime:kCMTimeZero];

            videoSize = self.mutableVideoComposition.renderSize;
            self.watermarkLayer = [self watermarkLayerForSize:videoSize];
            CALayer *parentLayer = [CALayer layer];
            CALayer *videoLayer = [CALayer layer];
            parentLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
            videoLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
            [parentLayer addSublayer:videoLayer];
            self.watermarkLayer.position = CGPointMake(videoSize.width/2, videoSize.height/4);
            [parentLayer addSublayer:self.watermarkLayer];
            
//            self.mutableVideoComposition.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
            self.mutableVideoComposition.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayers:@[videoLayer] inLayer:parentLayer];
            
            passThroughInstruction.layerInstructions = @[passThroughLayer];
//            self.mutableVideoComposition.customVideoCompositorClass = 
            self.mutableVideoComposition.instructions = @[passThroughInstruction];
        }
        
        

    }
    
    
    
    
    // Step 3
    // Notify AVSEViewController about add watermark operation completion
//    [[NSNotificationCenter defaultCenter] postNotificationName:AVSEEditCommandCompletionNotification object:self];
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:self.mutableComposition
                                                                      presetName:AVAssetExportPresetMediumQuality];
    exporter.outputURL=self.videoUrl;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = self.mutableVideoComposition;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //这里是输出视频之后的操作，做你想做的
            
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"合成完成"];
            // 调用播放方法
            _listenButton.hidden = NO;
            _deleteButton.hidden = NO;
            [_beginButton setImage:[UIImage imageNamed:@"complete"] forState:UIControlStateNormal];
            _beginButton.tag = 98;
            _labelPeiyin.text = @"保存";
            [self loadLocalVideo:exporter.outputURL.path];
            
        });
    }];
}

- (CALayer*)watermarkLayerForSize:(CGSize)videoSize
{
    // Create a layer for the title
    CALayer *watermarkLayer = [CALayer layer];
    
    // Create a layer for the text of the title.
    CATextLayer *titleLayer = [CATextLayer layer];
    titleLayer.string = @"abcdefg";
    titleLayer.foregroundColor = [[UIColor whiteColor] CGColor];
    titleLayer.font = (__bridge void*)[UIFont fontWithName:@"Helvetica" size:videoSize.height/4] ;
    titleLayer.shadowOpacity = 0.5;
    titleLayer.alignmentMode = kCAAlignmentCenter;
    titleLayer.bounds = CGRectMake(0, 0, videoSize.height/2, videoSize.width/2);
    
    // Add it to the overall layer.
    [watermarkLayer addSublayer:titleLayer];
    
    return watermarkLayer;
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
