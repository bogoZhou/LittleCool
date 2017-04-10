//
//  PlayViewController.m
//  LittleCool
//
//  Created by 周博 on 17/3/31.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "PlayViewController.h"
#import "TYVideoPlayerController.h"


@interface PlayViewController ()<TYVideoPlayerControllerDelegate>
@property (nonatomic, weak) TYVideoPlayerController *playerController;

@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navBarTitle:@"视频播放"];
    [self navBarbackButton:@"        "];
    [self addVideoPlayerController];
    [self loadLocalVideo:_url];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_playerController stop];
    _playerController = nil;
}

#pragma mark - 播放视频

- (void)addVideoPlayerController
{
    TYVideoPlayerController *playerController = [[TYVideoPlayerController alloc]init];
    //playerController.shouldAutoplayVideo = NO;
    playerController.delegate = self;
    [self addChildViewController:playerController];
    [self.playView addSubview:playerController.view];
    _playerController = playerController;
}

// 本地播放
- (void)loadLocalVideo:(NSURL *)path
{
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    //设置为播放
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
    
    [_playerController loadVideoWithStreamURL:path];
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
