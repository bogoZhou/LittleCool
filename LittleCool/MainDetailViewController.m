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

#import <GPUImage.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "AudioConvert.h"
#import "BorderHelper.h"




#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )


@interface MainDetailViewController ()<TYVideoPlayerControllerDelegate,AVAudioRecorderDelegate,AudioConvertDelegate>
{
    BOOL _beginRecording;
    CGFloat _longTime;
    NSString *localUrlString;
    float _yuansheng;
    float _luyin;
    AudioConvertOutputFormat outputFormat; //输出音频格式

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

@property (nonatomic,strong) NSString *waterString;

@property (nonatomic,strong) UIImage *waterImage;
@property (nonatomic,assign) int changeSoundsValue;

@property (nonatomic,strong) UIView *jumpView;
#pragma mark - GPUimage

@property (strong, nonatomic) GPUImageMovie *movieFile;
@property (strong, nonatomic) GPUImageBrightnessFilter *filter;
@property (strong, nonatomic) GPUImageOverlayBlendFilter *overlayFilter;
@property (strong, nonatomic) GPUImageMovieWriter *movieWriter;
@property (strong, nonatomic) GPUImageAlphaBlendFilter *blendFilter;
@property (strong, nonatomic) GPUImageUIElement *uiElementInput;
@property (strong, nonatomic) GPUImageTransformFilter *transformFilter;

@property (strong, nonatomic) GPUImageAlphaBlendFilter *overlayBlendFilter;
@property (strong, nonatomic) GPUImageUIElement *labelInput;
@property (strong, nonatomic) GPUImageTransformFilter *labelTransformFilter;

@property (strong, nonatomic) GPUImageAlphaBlendFilter *waterMarkBlendFilter;
@property (strong, nonatomic) GPUImageUIElement *watermarkInput;
@property (strong, nonatomic) GPUImageTransformFilter *watermarkTransformFilter;

@property (strong, nonatomic) GPUImageAlphaBlendFilter *landBlendFilter;
@property (strong, nonatomic) GPUImageUIElement *landInput;
@property (strong, nonatomic) GPUImageTransformFilter *landTransformFilter;

@property (strong, nonatomic) GPUImageBrightnessFilter *brightnessFilter;

//@property (nonatomic, strong) GPUImageMovieWriter *movieWriter;
@property (nonatomic, strong) GPUImageUIElement *uiElement;
@property (nonatomic, strong) GPUImageBrightnessFilter *brightFilter;
@property (nonatomic, strong) GPUImageAlphaBlendFilter *blendFliter;

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
//    _model.video_url = @"http://oj09diuk4.bkt.clouddn.com/%E9%83%AD%E5%AF%8C%E5%9F%8E.mp4";
    if ([BGFunctionHelper isNULLOfString:_model.video_url]) {
        [self loadLocalVideo:_model.url];
    }else{
        [self loadVodVideo];
    }
    _sliderOne.enabled = YES;
    _sliderTwo.enabled = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _beginRecording = NO;
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_playerController stop];
    _playerController = nil;
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
    _yuansheng = 1;
    _luyin = 1;
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

#pragma mark - 创建弹框

- (void)creatJumpView{
    if (!_jumpView) {
        _jumpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
        _jumpView.backgroundColor = kClearColor;
        
        UIButton *backButton = [[UIButton alloc] initWithFrame:_jumpView.frame];
        backButton.backgroundColor = kBlackColor;
        backButton.alpha = 0.3;
        [backButton addTarget:self action:@selector(hiddenView:) forControlEvents:UIControlEventTouchUpInside];
        [_jumpView addSubview:backButton];
        
        UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width - 120, 150)];
//        centerView.backgroundColor = kWhiteColor;
        centerView.layer.masksToBounds = YES;
        centerView.layer.cornerRadius = 10;
        centerView.backgroundColor = [kWhiteColor colorWithAlphaComponent:0.98];
        centerView.center = CGPointMake(_jumpView.center.x, _jumpView.center.y - 50);
        [_jumpView addSubview:centerView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, centerView.sizeWidth, 20)];
        titleLabel.text = @"请调音后加水印";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:17];
        [centerView addSubview:titleLabel];
        
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, centerView.sizeHeight - 50, centerView.sizeWidth/2, 50)];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:kBlackColor forState:UIControlStateNormal];
        [BorderHelper setBorderWithColor:kColorFrom0x(0xd6d6d6) view:cancelButton];
        [cancelButton addTarget:self action:@selector(hiddenView:) forControlEvents:UIControlEventTouchUpInside];
        [centerView addSubview:cancelButton];
        
        UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(centerView.sizeWidth/2 -0.5, centerView.sizeHeight - 50, centerView.sizeWidth/2+0.5, 50)];
        [sureButton setTitle:@"继续" forState:UIControlStateNormal];
        [sureButton setTitleColor:kBlackColor forState:UIControlStateNormal];
        [BorderHelper setBorderWithColor:kColorFrom0x(0xd6d6d6) view:sureButton];
        [sureButton addTarget:self action:@selector(addwaterFun:) forControlEvents:UIControlEventTouchUpInside];
        [centerView addSubview:sureButton];
        
        _jumpView.alpha = 0;
        [self.view addSubview:_jumpView];
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        _jumpView.alpha =  1;
    }];
}

- (void)hiddenView:(UIButton *)button{
    [UIView animateWithDuration:0.1 animations:^{
        _jumpView.alpha = 0;
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
    
    [_playerController stop];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否要删除视频" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSArray* myPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString* myDocPath = [myPaths objectAtIndex:0];
//        if (_waterString.length > 0) {
//            NSString *name = [NSString stringWithFormat:@"%@_%@_waterMark.mp4",_model.id,@"final"];
//            NSString* outPutFilePath = [myDocPath stringByAppendingPathComponent:name];
//            [self deleteOldRecordFile:outPutFilePath];
//        }else{
//            NSString *name = [NSString stringWithFormat:@"%@_%@.mp4",_model.id,@"final"];
//            NSString* outPutFilePath = [myDocPath stringByAppendingPathComponent:name];
//            [self deleteOldRecordFile:outPutFilePath];
//        }
        


        
        [self IWantoPButtonClick:nil];
        [_beginButton setImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
        _beginButton.tag = 99;
        _labelPeiyin.text = @"开始配音";
        _listenButton.hidden = YES;
        _deleteButton.hidden = YES;
        _labelShiting.hidden = YES;
        _labelShanchu.hidden = YES;
        _viewSlider.hidden = YES;
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:nil];
}


//我要配音
- (IBAction)IWantoPButtonClick:(UIButton *)sender {
    _viewIWantoP.hidden = YES;
    if (![BGFunctionHelper isNULLOfString:_model.video_url]) {
        [self loadAudioIntoLocal];
    }
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
        
        
        
        if ([BGFunctionHelper isNULLOfString:_model.video_url]) {
//            [self loadLocalVideo:_fileUrl];
            [self loadLocalmy:_model.localUrl];
        }else{
            [self loadLocalVideo:_fileUrl];
        }
        [self Progress];
    }else{//保存到相册
        [self save];
    }
}

//混音比例 (原视频音)
- (IBAction)sliderOneChangedFun:(UISlider *)sender {
    NSLog(@"原音%.0f/配音%.0f",sender.value * 100,(1-sender.value) *100);
    _yuansheng =sender.value;
    [self merge];
}

//配音声调 (配音声音)
- (IBAction)sliderTwoChangedFun:(UISlider *)sender {
    NSLog(@"slider -> %f",sender.value);
//    _changeSoundsValue = (int)sender.value;
    _luyin = sender.value;
    [self merge];
//    [self changeSoundPitch];
}

//点击添加水印
- (IBAction)waterMarkButtonClick:(UIButton *)sender {
    if (_luyin == 1 && _yuansheng == 1) {
         [self creatJumpView];
    }else{
        [self addwaterFun:nil];
    }
   
}

- (void)addwaterFun:(UIButton *)aaa{
    [self hiddenView:nil];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"水印内容" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alert.textFields.lastObject;
        
        self.waterString = textField.text;
        
        NSString *name = [NSString stringWithFormat:@"%@_%@.mp4",_model.id,@"final"];
        NSString *outPutFilePath = [BGFunctionHelper filePath:name];
        NSURL *inputFilePath = [NSURL fileURLWithPath:outPutFilePath];
        
        NSString *name1 = [NSString stringWithFormat:@"%@_%@_waterMark.mp4",_model.id,@"final"];
        NSString *outPutFilePath1 = [BGFunctionHelper filePath:name1];
        //        [self deleteOldRecordFile:outPutFilePath1];
        self.videoUrl = [NSURL fileURLWithPath:outPutFilePath1];
        [self testMark:[AVAsset assetWithURL:inputFilePath]];
        _sliderOne.enabled = NO;
        _sliderTwo.enabled = NO;
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"请输入水印内容";
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 存储方法

- (void)save{
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];

    NSArray* myPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* myDocPath = [myPaths objectAtIndex:0];
    NSString *name ;
    if ([BGFunctionHelper isNULLOfString:_waterString]) {
        name = [NSString stringWithFormat:@"%@_%@.mp4",_model.id,@"final"];
    }else{
        name = [NSString stringWithFormat:@"%@_%@_waterMark.mp4",_model.id,@"final"];
    }
    NSString* outPutFilePath = [myDocPath stringByAppendingPathComponent:name];
    NSURL *url = [NSURL URLWithString:outPutFilePath];
    
    [library saveVideo:url toAlbum:@"有点逗" completion:^(NSURL *assetURL, NSError *error) {
        kAlert(@"保存成功");
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        kAlert(@"保存失败");
    }];
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
//- (void)audio_PCMtoMP3
//{
//    
//    @try {
//        int read, write;
//        
//        FILE *pcm = fopen([self.cafPathStr cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
//        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
//        FILE *mp3 = fopen([self.mp3PathStr cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
//        
//        const int PCM_SIZE = 8192;
//        const int MP3_SIZE = 8192;
//        short int pcm_buffer[PCM_SIZE*2];
//        unsigned char mp3_buffer[MP3_SIZE];
//        
//        lame_t lame = lame_init();
//        lame_set_in_samplerate(lame, 11025.0);
//        lame_set_VBR(lame, vbr_default);
//        lame_init_params(lame);
//        
//        do {
//            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
//            if (read == 0)
//                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
//            else
//                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
//            
//            fwrite(mp3_buffer, write, 1, mp3);
//            
//        } while (read != 0);
//        
//        lame_close(lame);
//        fclose(mp3);
//        fclose(pcm);
//    }
//    @catch (NSException *exception) {
//        NSLog(@"%@",[exception description]);
//    }
//    @finally {
//        NSLog(@"MP3生成成功: %@",self.mp3PathStr);
//    }
//    
//}

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
    [self deleteOldRecordFile:_mp3PathStr];  //如果不删掉，会在原文件基础上录制；虽然不会播放原来的声音，但是音频长度会是录制的最大长度。
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
    [self.audioRecorder stop];
 
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
    //http://oj09diuk4.bkt.clouddn.com/%E9%83%AD%E5%AF%8C%E5%9F%8E.mp4
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
                       
                       BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:fPath];
                       if (!blHave) {
                           NSLog(@"不存在- > %@",fPath);
                           //        return ;
                       }else {
                           NSLog(@"存在- > %@",fPath);
                       }
                       
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
    //_changeSoundsValue != 0 ? @"wav" : 
    NSString *soundsStr = [BGFunctionHelper filePath:[NSString stringWithFormat:@"%@_%@.%@",_model.id,@"audio",@"caf"]];
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
    //  把采集轨道数据加入到可变轨道之中
    [videoTrack insertTimeRange:videoTimeRange ofTrack:videoAssetTrack atTime:nextClistartTime error:nil];

    [videoTrack setPreferredTransform:videoAssetTrack.preferredTransform];
    
    // 声音采集
    AVURLAsset *audioAsset = [[AVURLAsset alloc] initWithURL:audioInputUrl options:nil];
    // 因为视频短这里就直接用视频长度了,如果自动化需要自己写判断
//    CMTimeRange audioTimeRange = videoTimeRange;
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
//    CMTimeRange videoTimeRange1 = videoTimeRange;
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
    AVAssetExportSession *assetExport = [[AVAssetExportSession alloc] initWithAsset:comosition presetName:AVAssetExportPresetHighestQuality];
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
//
            [MBProgressHUD hideHUD];
           [MBProgressHUD showSuccess:@"合成完成"];
           // 调用播放方法
           _listenButton.hidden = NO;
           _deleteButton.hidden = NO;
            _labelShiting.hidden = NO;
            _labelShanchu.hidden = NO;
            
            if ([kIsVip integerValue] == 200) {
                _viewSlider.hidden = NO;
            }
           [_beginButton setImage:[UIImage imageNamed:@"complete"] forState:UIControlStateNormal];
           _beginButton.tag = 98;
           _labelPeiyin.text = @"保存";
           localUrlString = outPutFilePath;
//            if ([BGFunctionHelper isNULLOfString:_waterString]) {
                [self loadLocalVideo:assetExport.outputURL.path];
//            }else{
//                
//                NSString *name1 = [NSString stringWithFormat:@"%@_%@_waterMark.mp4",_model.id,@"final"];
//                NSString *outPutFilePath1 = [BGFunctionHelper filePath:name1];
//                self.videoUrl = [NSURL fileURLWithPath:outPutFilePath1];
//                [self testMark:[AVAsset assetWithURL:assetExport.outputURL]];
//            }
           
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
    [trackMix setVolume:volumeNum atTime:startTime];
    [_audioMixParams addObject:trackMix];
    
    //Insert audio into track  //offset CMTimeMake(0, 44100)
    [track insertTimeRange:tRange ofTrack:sourceAudioTrack atTime:kCMTimeZero error:&error];
}

#pragma mark - 改变音调

- (void)changeSoundPitch{
//    [self stopAudio];
    [_playerController stop];
//    [[Recorder shareRecorder] stopRecord];
    
//    NSString *p =  [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_%@",_model.id,@"audio"] ofType:@"mp3"];
    NSString *p = [BGFunctionHelper filePath:[NSString stringWithFormat:@"%@_%@.mp3",_model.id,@"audio"]];
    outputFormat = AudioConvertOutputFormat_MP3;
    
    
    AudioConvertConfig dconfig;
    dconfig.sourceAuioPath = [p UTF8String];
    dconfig.outputFormat = outputFormat;
    dconfig.outputChannelsPerFrame = 2;
    dconfig.outputSampleRate = 22050;
    dconfig.soundTouchPitch = _changeSoundsValue;
    dconfig.soundTouchRate = 0;
    dconfig.soundTouchTempoChange = 0;
    [[AudioConvert shareAudioConvert] audioConvertBegin:dconfig withCallBackDelegate:self];

}

#pragma mark - 变声代理方法
/**
 * 对音频解码动作的回调
 **/
- (void)audioConvertDecodeSuccess:(NSString *)audioPath {
    //解码成功
//    [self playAudio:audioPath];
    [self merge];
    NSLog(@"解码 -> %@",audioPath);
    kAlert(@"解码成功");
}
- (void)audioConvertDecodeFaild
{
    //解码失败
//    [self stopAudio];
    kAlert(@"解码失败");
}


/**
 * 对音频变声动作的回调
 **/
- (void)audioConvertSoundTouchSuccess:(NSString *)audioPath
{
    //变声成功
//    [self playAudio:audioPath];
    [self merge];
    kAlert(@"变声成功");
}


- (void)audioConvertSoundTouchFail
{
    //变声失败
//    [self stopAudio];
    kAlert(@"变声失败");
}




/**
 * 对音频编码动作的回调
 **/

- (void)audioConvertEncodeSuccess:(NSString *)audioPath
{
    //编码完成
//    [self playAudio:audioPath];
    [self merge];
}

- (void)audioConvertEncodeFaild
{
    //编码失败
//    [self stopAudio];
    kAlert(@"编码失败");
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
- (void)testMark:(AVAsset *)asset{
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Set the label text.
    _hud.label.text = NSLocalizedString(@"合成中...", @"HUD loading title");
    self.watermarkLayer = nil;
    CGSize videoSize;
    
    AVAssetTrack *assetVideoTrack = nil;
    AVAssetTrack *assetAudioTrack = nil;
    CGAffineTransform t1 ;
    CGAffineTransform t2 ;
    // Check if the asset contains video and audio tracks
    if ([[asset tracksWithMediaType:AVMediaTypeVideo] count] != 0) {
        assetVideoTrack = [asset tracksWithMediaType:AVMediaTypeVideo][0];
    }
    if ([[asset tracksWithMediaType:AVMediaTypeAudio] count] != 0) {
        assetAudioTrack = [asset tracksWithMediaType:AVMediaTypeAudio][0];
    }
    
    CMTime insertionPoint = kCMTimeZero;
    NSError *error = nil;
    
    NSString *name1 = [NSString stringWithFormat:@"%@_%@_waterMark.mp4",_model.id,@"final"];
    NSString *outPutFilePath1 = [BGFunctionHelper filePath:name1];
    NSURL *vUrl = [NSURL fileURLWithPath:outPutFilePath1];
    
    [self deleteOldRecordFile:outPutFilePath1];
    
    
    // Step 1
    // Create a composition with the given asset and insert audio and video tracks into it from the asset
//    if(!self.mutableComposition) {
    
        // Check if a composition already exists, else create a composition using the input asset
        self.mutableComposition = [AVMutableComposition composition];
        
        // Insert the video and audio tracks from AVAsset
        if (assetVideoTrack != nil) {
            AVMutableCompositionTrack *compositionVideoTrack = [self.mutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
            [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, [asset duration]) ofTrack:assetVideoTrack atTime:insertionPoint error:&error];
            CGAffineTransform transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
            [compositionVideoTrack setPreferredTransform:transform];
        }
        if (assetAudioTrack != nil) {
            AVMutableCompositionTrack *compositionAudioTrack = [self.mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
            [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, [asset duration]) ofTrack:assetAudioTrack atTime:insertionPoint error:&error];
        }

//    }
    
    
    // Step 2
    // Create a water mark layer of the same size as that of a video frame from the asset
    if ([[self.mutableComposition tracksWithMediaType:AVMediaTypeVideo] count] != 0) {
        self.watermarkLayer = [CALayer layer];
//        if(!self.mutableVideoComposition) {
        
            // build a pass through video composition
            self.mutableVideoComposition = [AVMutableVideoComposition videoComposition];
            self.mutableVideoComposition.frameDuration = CMTimeMake(1, 30); // 30 fps
//            assetVideoTrack.naturalSize
            NSLog(@"naturalSize -> width:%f ; height:%f",assetVideoTrack.naturalSize.width,assetVideoTrack.naturalSize.height);
            CGSize renderSize = assetVideoTrack.naturalSize;

            if (assetVideoTrack.preferredTransform.a == 1 && assetVideoTrack.preferredTransform.d == 1) {//正
                NSLog(@"rendersize -> 1");
                self.mutableVideoComposition.renderSize = renderSize;
                t2 = asset.preferredTransform;
            }else{//侧
                
                t1 = CGAffineTransformMakeTranslation(assetVideoTrack.naturalSize.height, 0.0);
                t2 = CGAffineTransformRotate(t1, degreesToRadians(90.0));
                
                self.mutableVideoComposition.renderSize = CGSizeMake(renderSize.height, renderSize.width);

            }
        
            
            
            NSLog(@"renderSize -> width:%f ; height:%f",self.mutableVideoComposition.renderSize.width,self.mutableVideoComposition.renderSize.height);
            self.mutableVideoComposition.renderScale = 1.0;
            
            AVMutableVideoCompositionInstruction *passThroughInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
            passThroughInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, [self.mutableComposition duration]);
            
            AVAssetTrack *videoTrack = [self.mutableComposition tracksWithMediaType:AVMediaTypeVideo][0];
            AVMutableVideoCompositionLayerInstruction *passThroughLayer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
            CGAffineTransform transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
            [passThroughLayer setTransform:t2 atTime:kCMTimeZero];
            NSLog(@"transform -> a%f,b%f,c%f,d%f,tx%f,ty%f,",transform.a,transform.b,transform.c,transform.d,transform.tx,transform.ty);
            NSLog(@"passthroughLayer.transform -> a%f,b%f,c%f,d%f,tx%f,ty%f,",assetVideoTrack.preferredTransform.a,assetVideoTrack.preferredTransform.b,assetVideoTrack.preferredTransform.c,assetVideoTrack.preferredTransform.d,assetVideoTrack.preferredTransform.tx,assetVideoTrack.preferredTransform.ty);
            
            videoSize = self.mutableVideoComposition.renderSize;
            self.watermarkLayer = [self watermarkLayerForSize:videoSize waterText:_waterString];
            CALayer *parentLayer = [CALayer layer];
            CALayer *videoLayer = [CALayer layer];
            parentLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
            videoLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
            [parentLayer addSublayer:videoLayer];
            self.watermarkLayer.position = CGPointMake(videoSize.width - _waterImage.size.width/2-10, 30);
            [parentLayer addSublayer:self.watermarkLayer];
            
            self.mutableVideoComposition.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayers:@[videoLayer] inLayer:parentLayer];
            
            passThroughInstruction.layerInstructions = @[passThroughLayer];
//            self.mutableVideoComposition.customVideoCompositorClass = 
            self.mutableVideoComposition.instructions = @[passThroughInstruction];
//        }
    }
//    [self deleteOldRecordFile:self.videoUrl.path];
    // Step 3
    // Notify AVSEViewController about add watermark operation completion
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:self.mutableComposition
                                                                      presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL=vUrl;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = self.mutableVideoComposition;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //这里是输出视频之后的操作，做你想做的
            BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:exporter.outputURL.path];
            if (!blHave) {
                NSLog(@"不存在- > %@",exporter.outputURL.path);
                //        return ;
            }else {
                NSLog(@"存在- > %@",exporter.outputURL.path);
            }

            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"合成完成"];
            // 调用播放方法
//            _listenButton.hidden = NO;
//            _deleteButton.hidden = NO;
//            _labelShanchu.hidden = NO;
//            _labelShiting.hidden = NO;
//            
//            if ([kIsVip integerValue] ==200) {
//                _viewSlider.hidden = NO;
//            }
//            
//            [_beginButton setImage:[UIImage imageNamed:@"complete"] forState:UIControlStateNormal];
//            _beginButton.tag = 98;
//            _labelPeiyin.text = @"保存";
            [self loadLocalVideo:exporter.outputURL.path];
            [_hud hideAnimated:YES];
        });
    }];
}

- (CALayer*)watermarkLayerForSize:(CGSize)videoSize waterText:(NSString *)waterText
{
    // Create a layer for the title
    CALayer *watermarkLayer = [CALayer layer];
    CALayer *backgroundLayer = [CALayer layer];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, videoSize.width - 30, videoSize.height, 30)];
    label.textColor = kWhiteColor;
    label.text = waterText;
    label.backgroundColor = kClearColor;
    label.textAlignment = NSTextAlignmentRight;
    label.font = [UIFont systemFontOfSize:20];
    _waterImage = nil;
    _waterImage = [BGFunctionHelper imageWithUIView:label];
    
    [backgroundLayer setContents:(id)[_waterImage CGImage]];
    backgroundLayer.bounds = CGRectMake(0, videoSize.width - 30, videoSize.height, 30);
    [backgroundLayer setMasksToBounds:YES];
    
    // Add it to the overall layer.
    [watermarkLayer addSublayer:backgroundLayer];
    return watermarkLayer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GPUImage
//- (void)addTwoFilterToMovieFormURL:(NSURL *)sampleURL{
////    NSURL *sampleURL = [[NSBundle mainBundle] URLForResource:@"gas" withExtension:@"mp4"];
//    
//    // GPUImageSoftLightBlendFilter 柔光混合
//    // GPUImageHardLightBlendFilter 强光混合
//    
//    _movieFile = [[GPUImageMovie alloc] initWithURL:sampleURL];
//    _movieFile.runBenchmark = YES;
//    _movieFile.playAtActualSpeed = NO;
//    _filter = [[GPUImageBrightnessFilter alloc] init];
//    _filter.brightness = 0.0f;
//    
//    __weak MainDetailViewController *weakself = self;
//    
//    AVAsset *fileas = [AVAsset assetWithURL:sampleURL];
//    
//    //CGFloat allSec = fileas.duration.value / fileas.duration.timescale;
//    //CGFloat allfps = fileas.duration.value;
//    CGSize movieSize = fileas.naturalSize;
//    
//    //加载第一个Image
//    UIImage *image = [UIImage imageNamed:@"selected"];
//    UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 800, 560)];
//    [imv setImage:image];
//    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, movieSize.width, movieSize.height)];
//    vi.backgroundColor = [UIColor clearColor];
//    imv.center = CGPointMake(vi.bounds.size.width, vi.bounds.size.height + 80);
//    [vi addSubview:imv];
//    
//    UIImageView *landImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 800, 560)];
//    [landImgView setImage:[UIImage imageNamed:@"selected"]];
//    landImgView.alpha = 0.0;
//    UIView *landView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, movieSize.width, movieSize.height)];
//    [landView setBackgroundColor:[UIColor clearColor]];
//    landImgView.center = CGPointMake(landView.bounds.size.width, landView.bounds.size.height - 500);
//    [landView addSubview:landImgView];
//    
//    //下面的label
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
//    label.text = @"I Make It!";
//    label.textAlignment = NSTextAlignmentCenter;
//    label.font = [UIFont systemFontOfSize:100.0f];
//    [label sizeToFit];
//    label.textColor = [UIColor whiteColor];
//    //label.alpha = 0.0;
//    UIView *labelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, movieSize.width, movieSize.height)];
//    [labelView setBackgroundColor:[UIColor clearColor]];
//    label.center = CGPointMake(labelView.center.x, labelView.bounds.size.height - 100);
//    [labelView addSubview:label];
//    
//    //左下角的image
//    UIImageView *waterMarkImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 312)];
//    waterMarkImgView.image = [UIImage imageNamed:@"selected"];
//    UIView *waterMarkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, movieSize.width, movieSize.height)];
//    waterMarkImgView.alpha = 0.0;
//    waterMarkImgView.center = CGPointMake(250 , waterMarkView.bounds.size.height - 160);
//    [waterMarkView addSubview:waterMarkImgView];
//    
//    _landBlendFilter = [[GPUImageAlphaBlendFilter alloc] init];
//    _landBlendFilter.mix = 1.0f;
//    _landInput = [[GPUImageUIElement alloc] initWithView:landView];
//    _landTransformFilter = [[GPUImageTransformFilter alloc] init];
//    
//    _watermarkInput = [[GPUImageUIElement alloc] initWithView:waterMarkView];
//    _watermarkTransformFilter = [[GPUImageTransformFilter alloc] init];
//    _waterMarkBlendFilter = [[GPUImageAlphaBlendFilter alloc] init];
//    _waterMarkBlendFilter.mix = 1.0f;
//    
//    _uiElementInput = [[GPUImageUIElement alloc] initWithView:vi];
//    _transformFilter = [[GPUImageTransformFilter alloc] init];
//    _blendFilter = [[GPUImageAlphaBlendFilter alloc] init];
//    _blendFilter.mix = 1.0;
//    
//    _labelInput = [[GPUImageUIElement alloc] initWithView:labelView];
//    _labelTransformFilter = [[GPUImageTransformFilter alloc] init];
//    _overlayBlendFilter = [[GPUImageAlphaBlendFilter alloc] init];
//    _overlayBlendFilter.mix = 1.0f;
//    
//    CATransform3D perspectiveTransform = CATransform3DIdentity;
//    perspectiveTransform = CATransform3DRotate(perspectiveTransform, 0, 1.0, 0.0, 0.0);
//    
//    [_transformFilter setTransform3D:perspectiveTransform];
//    
//    CATransform3D secTransform = CATransform3DIdentity;
//    secTransform = CATransform3DRotate(secTransform, 0, 1.0, 0.0, 0.0);
//    [_labelTransformFilter setTransform3D:secTransform];
//    
//    [_watermarkTransformFilter setTransform3D:secTransform];
//    [_landTransformFilter setTransform3D:secTransform];
//    
//    __unsafe_unretained GPUImageUIElement *weakUIElementInput = _uiElementInput;
//    __unsafe_unretained GPUImageUIElement *weakLabelInput = _labelInput;
//    __unsafe_unretained GPUImageUIElement *weakWaterMarkInput = _watermarkInput;
//    __unsafe_unretained GPUImageUIElement *weakLandInput = _landInput;
//    
//    __block CGFloat i = 1.0f;
//    __block CGFloat j = 1.0f;
//    __block CGFloat k = 1.0f;
//    __block CGFloat l = 1.0f;
//    
//    [_filter setFrameProcessingCompletionBlock:^(GPUImageOutput * filter, CMTime time){
//        
//        //NSLog(@"%d, %lld, %d", time.flags, time.epoch, time.timescale);
//        
////        CGFloat sencond = time.value / time.timescale;
////        
////        //最后一秒模糊
////        imv.alpha = 1.0f;
////        
////        if (sencond >= 1 && sencond < 3){
////            
////            imv.alpha = 1.0f;
////            [imv.layer setAnchorPoint:CGPointMake(1, 1)];
////            [vi.layer setAnchorPoint:CGPointMake(1, 1)];
////            CGAffineTransform transform = imv.transform;
////            
////            if (sencond >= 2){
////                transform = CGAffineTransformRotate(transform, - i / 50 * M_PI / 10);
////            }
////            transform = CGAffineTransformRotate(transform, i / 50 * M_PI / 10);
////            
////            [weakself.landTransformFilter setAffineTransform:transform];
////            i = i + 1.0f;
////            
////        }else if (sencond >=3 && sencond < 5){
////            imv.alpha = 0.0;
////            landImgView.alpha = 1.0f;
////            
////            [landImgView.layer setAnchorPoint:CGPointMake(1, 0)];
////            [landView.layer setAnchorPoint:CGPointMake(1, 0)];
////            CGAffineTransform transform = landImgView.transform;
////            
////            if (sencond > 3){
////                transform = CGAffineTransformRotate(transform,  - l / 50 * M_PI / 100);
////                l = l + 1.0f;
////            }else {
////                transform = CGAffineTransformRotate(transform,  j / 50 * M_PI / 100);
////                j = j + 1.0f;
////            }
////            
////            [weakself.watermarkTransformFilter setAffineTransform:transform];
////            
////            
////        }else if (sencond >= 5 && sencond < 7){
////            landImgView.alpha = 0.0f;
////            waterMarkImgView.alpha = 1.0f;
////            
////            [waterMarkImgView.layer setAnchorPoint:CGPointMake(0, 1)];
////            [waterMarkView.layer setAnchorPoint:CGPointMake(0, 1)];
////            CGAffineTransform transform = waterMarkView.transform;
////            transform = CGAffineTransformScale(transform, k, k);
////            [weakself.labelTransformFilter setAffineTransform:transform];
////            k = k + 0.02;
////        }
////        
////        if (sencond >= 7 && sencond < 11){
////            waterMarkImgView.alpha = 0.0f;
////            label.alpha = 1.0f;
////        }
//        
//        //NSLog(@"i = %f, j = %f, k = %f", i,j,k);
//        [weakUIElementInput update];
//        [weakLabelInput update];
//        [weakWaterMarkInput update];
//        [weakLandInput update];
//    }];
//    
//    // Only rotate the video for display, leave orientation the same for recording
//    // In addition to displaying to the screen, write out a processed version of the movie to disk
//    
//    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.mp4"];
//    unlink([pathToMovie UTF8String]); // If a file already exists, AVAssetWriter won't let you record new frames, so delete the old movie
//    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
//    
//    _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(640.0, 480.0)];
//    //_movieWriter.transform = CGAffineTransformMakeScale(0.3, 0.3);
//    
//    [_movieFile addTarget:_filter];
//    [_filter addTarget:_blendFilter];
//    [_uiElementInput addTarget:_transformFilter];
//    [_transformFilter addTarget:_blendFilter];
//    
//    [_blendFilter addTarget:_overlayBlendFilter];
//    [_labelInput addTarget:_labelTransformFilter];
//    [_labelTransformFilter addTarget:_overlayBlendFilter];
//    
//    [_overlayBlendFilter addTarget:_waterMarkBlendFilter];
//    [_watermarkInput addTarget:_watermarkTransformFilter];
//    [_watermarkTransformFilter addTarget:_waterMarkBlendFilter];
//    
//    
//    [_waterMarkBlendFilter addTarget:_landBlendFilter];
//    [_landInput addTarget:_landTransformFilter];
//    [_landTransformFilter addTarget:_landBlendFilter];
//    
//    [_landBlendFilter addTarget:_movieWriter];
//    // Configure this for video from the movie file, where we want to preserve all video frames and audio samples
//    
//    _movieWriter.shouldPassthroughAudio = YES;
//    _movieFile.audioEncodingTarget = _movieWriter;
//    [_movieFile enableSynchronizedEncodingUsingMovieWriter:_movieWriter];
//    
//    [_movieWriter startRecording];
//    [_movieFile startProcessing];
//    
//    [_movieWriter setCompletionBlock:^{
//        [weakself.filter removeTarget:weakself.movieWriter];
//        [weakself.movieWriter finishRecording];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            //[weakself.timer invalidate];
//            
////            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
////            
////            [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:pathToMovie] completionBlock:^(NSURL *assetURL, NSError *error) {
//            
//                NSLog(@"---finished!!!!!");
//                
////                [[[UIAlertView alloc] initWithTitle:@"" message:@"已经成功写入相册！" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil] show];
////            }];
//            
//        });
//    }];
//
//}
//
//- (void)gpuImageUrl:(NSURL *)sampleURL{
////    NSURL *sampleURL = [[NSBundle mainBundle] URLForResource:@"loginmovie" withExtension:@"mp4"];
//    
//    NSLog(@"sample -> %@",sampleURL);
//    _movieFile = [[GPUImageMovie alloc] initWithURL:sampleURL];
//    _movieFile.runBenchmark = YES;
//    _movieFile.playAtActualSpeed = NO;
//    
//    AVAsset *fileas = [AVAsset assetWithURL:sampleURL];
//    AVAssetTrack *videoAssetTrack = [[fileas tracksWithMediaType:AVMediaTypeVideo] firstObject];
//    CGSize movieSize = videoAssetTrack.naturalSize;
//    
//    NSLog(@"size -> %f,%f",movieSize.width,movieSize.height);
//    
//    UIImage *image = [UIImage imageNamed:@"selecte.png"];
//    UIImageView *waterFliter = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 150)];
//    [waterFliter setImage:image];
//    
//    UIView *cotentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, movieSize.width, movieSize.height)];
//    cotentView.backgroundColor = [UIColor clearColor];
//    [cotentView addSubview:waterFliter];
//    
//    _brightFilter = [[GPUImageBrightnessFilter alloc] init];
//    _brightFilter.brightness = 0.0f;
//    
//    _uiElement = [[GPUImageUIElement alloc] initWithView:cotentView];
//    
//    _blendFliter = [[GPUImageAlphaBlendFilter alloc] init];
//    _blendFliter.mix = 1.0;
//    
//    __weak typeof(self) weakSelf = self;
//    [_brightFilter setFrameProcessingCompletionBlock:^(GPUImageOutput *output, CMTime Time) {
//        [weakSelf.uiElement update];
//    }];
//    
//    NSLog(@"%@",weakSelf);
//    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Movie.mp4"]];
//    NSLog(@"%@",pathToMovie);
//    unlink([pathToMovie UTF8String]); // If a file already exists, AVAssetWriter won't let you record new frames, so delete the old movie
//    NSURL * movieURL = [NSURL fileURLWithPath:pathToMovie];
//    
//    _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:movieSize];
//    
//    [_movieFile addTarget:_brightFilter];
//    [_brightFilter addTarget:_blendFliter];
//    [_uiElement addTarget:_blendFliter];
//    
//    [_blendFliter addTarget:_movieWriter];
//    
//    _movieWriter.shouldPassthroughAudio = YES;
//    _movieFile.audioEncodingTarget = _movieWriter;
//    [_movieFile enableSynchronizedEncodingUsingMovieWriter:_movieWriter];
//    
//    [_movieWriter startRecording];
//    [_movieFile startProcessing];
//    NSLog(@"马上就要完成了");
//    [_movieWriter setCompletionBlock:^{
//        [weakSelf.brightFilter removeTarget:weakSelf.movieWriter];
//        [weakSelf.movieWriter finishRecording];
//        NSLog(@"马上就要完成了");
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"完成了");
//            [weakSelf loadLocalVideo:movieURL.path];
//        });
//    }];
//
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
