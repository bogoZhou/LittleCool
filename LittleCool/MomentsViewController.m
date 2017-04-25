




/********************* 有任何问题欢迎反馈给我 liuweiself@126.com ****************************************/
/***************  https://github.com/waynezxcv/Gallop 持续更新 ***************************/
/******************** 正在不断完善中，谢谢~  Enjoy ******************************************************/










#import "MomentsViewController.h"
#import "LWImageBrowser.h"
#import "TableViewCell.h"
#import "TableViewHeader.h"
#import "StatusModel.h"
#import "CellLayout.h"
#import "CommentView.h"
#import "CommentModel.h"
#import "LWAlertView.h"
#import "TakePicDelegate.h"

#import "TextCommentViewController.h"
#import "PhotoCommentViewController.h"
#import "UpdateFriendsViewController.h"
#import "ChooseAnyUsersViewController.h"
#import "loadUserModel.h"


@interface MomentsViewController ()

<UITableViewDataSource,UITableViewDelegate,ChooseFriendsDelegate>


@property (nonatomic,strong) UIButton *rightBTN;

@property (nonatomic,strong) NSMutableArray* fakeDatasource;
@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) NSMutableArray* dataSource;
@property (nonatomic,strong) TableViewHeader* tableViewHeader;
@property (nonatomic,strong) CommentView* commentView;
@property (nonatomic,strong) CommentModel* postComment;
@property (nonatomic,assign,getter = isNeedRefresh) BOOL needRefresh;
@property (nonatomic,assign) BOOL displaysAsynchronously;//是否异步绘制

@property (nonatomic,strong) UserInfoModel *chooseUser;
@property (nonatomic,strong) NSString *chooseFriendsId;
@end



const CGFloat kRefreshBoundary = 20.0f;




@implementation MomentsViewController

#pragma mark - ViewControllerLifeCycle

- (void)loadView {
    [super loadView];
    [self setup];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navBarbackButton:@"发现"];
    [self navBarTitle:@"朋友圈"];
    [self navBarRButton];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.commentView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidAppearNotifications:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHidenNotifications:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(chooseUser:) name:@"chooseUser" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(choosePerson:) name:@"pinglunren" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBGImage:) name:@"changeBGImage" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"chooseUser" object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isNeedRefresh) {
        [self refreshBegin];
    }
}

- (void)navBarRButton{
    _rightBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBTN setFrame:CGRectMake(0, 0, 23, 17)];
    [_rightBTN setImage:[UIImage imageNamed:@"Small Camera.png"] forState:UIControlStateNormal];
    [_rightBTN addTarget:self action:@selector(addFriendsButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBTN];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -5;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, rightItem, nil];
    
}

//点击添加朋友圈
- (void)addFriendsButtonClick{
//    kAlert(@"点击添加朋友圈");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    UIAlertAction *textAction = [UIAlertAction actionWithTitle:@"文字" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//        UIStoryboard *storyboard = kWechatStroyboard;
//        
//        TextCommentViewController *textCommentVC = [storyboard instantiateViewControllerWithIdentifier:@"TextCommentViewController"];
//        [textCommentVC navBarbackButton:@"" textFloat:0];
//        [textCommentVC navBarTitle:@"编辑朋友圈内容"];
//        [self.navigationController pushViewController:textCommentVC animated:YES];
//        
//    }];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"发送朋友圈内容" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIStoryboard *storyboard = kWechatStroyboard;

        PhotoCommentViewController *photoCommentVC = [storyboard instantiateViewControllerWithIdentifier:@"PhotoCommentViewController"];
        [photoCommentVC navBarbackButton:@""];
        [photoCommentVC navBarTitle:@"编辑朋友圈内容"];
        [self.navigationController pushViewController:photoCommentVC animated:YES];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
//    [alert addAction:textAction];
    [alert addAction:photoAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CellLayout* layout = self.dataSource[indexPath.row];
    return layout.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"cellIdentifier";
    TableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [self confirgueCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)confirgueCell:(TableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.displaysAsynchronously = self.displaysAsynchronously;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    CellLayout* cellLayout = self.dataSource[indexPath.row];
    cell.cellLayout = cellLayout;
    [self callbackWithCell:cell];
}

- (void)callbackWithCell:(TableViewCell *)cell {
    
    __weak typeof(self) weakSelf = self;
    cell.clickedLikeButtonCallback = ^(TableViewCell* cell,BOOL isLike) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself tableViewCell:cell didClickedLikeButtonWithIsLike:isLike];
    };
    
    cell.clickedCommentButtonCallback = ^(TableViewCell* cell) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself commentWithCell:cell];
    };
    
    cell.clickedReCommentCallback = ^(TableViewCell* cell,CommentModel* model) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself reCommentWithCell:cell commentModel:model];
    };
    
    cell.clickedOpenCellCallback = ^(TableViewCell* cell) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself openTableViewCell:cell];
    };
    
    cell.clickedCloseCellCallback = ^(TableViewCell* cell) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself closeTableViewCell:cell];
    };
    
    cell.clickedAvatarCallback = ^(TableViewCell* cell) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself showAvatarWithCell:cell];
    };
    
    cell.clickedImageCallback = ^(TableViewCell* cell,NSInteger imageIndex) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself tableViewCell:cell showImageBrowserWithImageIndex:imageIndex];
    };
}

#pragma mark - Actions
//开始评论
- (void)commentWithCell:(TableViewCell *)cell  {
    UserInfoModel *user = [[[FMDBHelper fmManger] selectDataByTableName:kOthreUserTable] firstObject];

    NSArray *dataArray = [[FMDBHelper fmManger] selectFriendsWhereValue1:@"" value2:@"" isNeed:NO];
    
    FriendsModel *model = dataArray[cell.indexPath.row];
    _chooseFriendsId = model.Id;
    
    self.postComment.from = user.name;
    self.postComment.to = @"";
    self.postComment.index = cell.indexPath.row;
    self.commentView.placeHolder = @"评论";
    if (![self.commentView.textView isFirstResponder]) {
        [self.commentView.textView becomeFirstResponder];
    }
}

//开始回复评论

- (void)reCommentWithCell:(TableViewCell *)cell commentModel:(CommentModel *)commentModel {
    UserInfoModel *user = [[[FMDBHelper fmManger] selectDataByTableName:kOthreUserTable] firstObject];
    NSArray *dataArray = [[FMDBHelper fmManger] selectFriendsWhereValue1:@"" value2:@"" isNeed:NO];

    FriendsModel *model = dataArray[cell.indexPath.row];
    _chooseFriendsId = model.Id;
    self.postComment.from = user.name;
    self.postComment.to = commentModel.to;
    self.postComment.index = commentModel.index;

    self.commentView.placeHolder = [NSString stringWithFormat:@"回复%@:",commentModel.to];
    if (![self.commentView.textView isFirstResponder]) {
        [self.commentView.textView becomeFirstResponder];
    }
}

- (void)changeFrom:(NSString *)from content:(NSString *)content{
    self.postComment.from = from;
    self.postComment.content = content;
}

//点击查看大图
- (void)tableViewCell:(TableViewCell *)cell showImageBrowserWithImageIndex:(NSInteger)imageIndex {
//    NSMutableArray* tmps = [[NSMutableArray alloc] init];
//    for (NSInteger i = 0; i < cell.cellLayout.imagePostions.count; i ++) {
//        LWImageBrowserModel* model = [[LWImageBrowserModel alloc]
//                                      initWithplaceholder:nil
//                                      thumbnailURL:[cell.cellLayout.statusModel.imgs objectAtIndex:i]
//                                      HDURL:[cell.cellLayout.statusModel.imgs objectAtIndex:i]
//                                      containerView:cell.contentView
//                                      positionInContainer:CGRectFromString(cell.cellLayout.imagePostions[i])
//                                      index:i];
//        [tmps addObject:model];
//    }
//    LWImageBrowser* browser = [[LWImageBrowser alloc] initWithImageBrowserModels:tmps
//                                                                    currentIndex:imageIndex];
//    
//    [browser show];
}

//查看头像
- (void)showAvatarWithCell:(TableViewCell *)cell {
    [LWAlertView shoWithMessage:[NSString stringWithFormat:@"点击了头像:%@",cell.cellLayout.statusModel.name]];
}


/* 由于是异步绘制，而且为了减少View的层级，整个显示内容都是在同一个UIView上面，所以会在刷新的时候闪一下，这里可以先把原先Cell的内容截图覆盖在Cell上，
 延迟0.25s后待刷新完成后，再将这个截图从Cell上移除 */
- (void)coverScreenshotAndDelayRemoveWithCell:(UITableViewCell *)cell cellHeight:(CGFloat)cellHeight {
    
    UIImage* screenshot = [GallopUtils screenshotFromView:cell];
    
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:[self.tableView convertRect:cell.frame toView:self.tableView]];
    
    imgView.frame = CGRectMake(imgView.frame.origin.x,
                               imgView.frame.origin.y,
                               imgView.frame.size.width,
                               cellHeight);
    
    imgView.contentMode = UIViewContentModeTop;
    imgView.backgroundColor = [UIColor whiteColor];
    imgView.image = screenshot;
    [self.tableView addSubview:imgView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [imgView removeFromSuperview];
    });
    
}


//点赞
- (void)tableViewCell:(TableViewCell *)cell didClickedLikeButtonWithIsLike:(BOOL)isLike {
    [[FMDBHelper fmManger] createZanTable];
//    CellLayout* layout = [self.dataSource objectAtIndex:cell.indexPath.row];
//    NSMutableArray* newLikeList = [[NSMutableArray alloc] initWithArray:layout.statusModel.likeList];

    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"新建点赞" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *newZanList = [UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        CellLayout* layout = [self.dataSource objectAtIndex:cell.indexPath.row];
        
        NSMutableArray* newLikeList = [[NSMutableArray alloc] initWithArray:layout.statusModel.likeList];
        [newLikeList removeAllObjects];

        UITextField *textField = alert.textFields.lastObject;
        
        NSArray *dataArray = [[FMDBHelper fmManger] selectFriendsWhereValue1:@"" value2:@"" isNeed:NO];
        
        FriendsModel *fmodel = dataArray[cell.indexPath.row];
        
//        if (textField.text.integerValue <= 50) {
//            
//            NSArray *array = [[FMDBHelper fmManger] selectRandomZanWithNum:textField.text];
//            [[FMDBHelper fmManger] deleteDataByTableName:@"zanTable" TypeName:@"friendsId" TypeValue:fmodel.Id];
//            for (int i = 0 ; i < array.count; i ++) {
//                UserInfoModel *model = array[i];
//                [newLikeList addObject:model.name];
//                [[FMDBHelper fmManger] insertZanDataByFriendsId:fmodel.Id userId:model.name];
//            }
//        }else{
//            kAlert(@"人数请控制在50人内");
//        }
        [[AFClient shareInstance] getRandomUserByCounts:textField.text progressBlock:nil success:^(id responseBody) {
            if ([responseBody[@"code"] integerValue] == 200) {
                [[FMDBHelper fmManger] deleteDataByTableName:@"zanTable" TypeName:@"friendsId" TypeValue:fmodel.Id];
                for (NSDictionary *dic in responseBody[@"data"]) {
                    loadUserModel *user = [[loadUserModel alloc] init];
                    [user setValuesForKeysWithDictionary:dic];
                    user.type = @"1";
                    [newLikeList addObject:user.name];
                    [[FMDBHelper fmManger] insertZanDataByFriendsId:fmodel.Id userId:user.name];
                }
            }
        } failure:^(NSError *error) {
            
        }];
        
        StatusModel* statusModel = layout.statusModel;
        statusModel.likeList = newLikeList;
        layout = [self layoutWithStatusModel:statusModel index:cell.indexPath.row];
        [self coverScreenshotAndDelayRemoveWithCell:cell cellHeight:layout.cellHeight];
        [self.dataSource replaceObjectAtIndex:cell.indexPath.row withObject:layout];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:cell.indexPath.row inSection:0]]
                              withRowAnimation:UITableViewRowAnimationNone];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"请输入赞个数";
    }];
    
    [alert addAction:newZanList];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}


//展开Cell
- (void)openTableViewCell:(TableViewCell *)cell {
    CellLayout* layout =  [self.dataSource objectAtIndex:cell.indexPath.row];
    StatusModel* model = layout.statusModel;
    CellLayout* newLayout = [[CellLayout alloc] initContentOpendLayoutWithStatusModel:model
                                                                                index:cell.indexPath.row
                                                                        dateFormatter:self.dateFormatter];
    
    [self coverScreenshotAndDelayRemoveWithCell:cell cellHeight:newLayout.cellHeight];
    
    
    [self.dataSource replaceObjectAtIndex:cell.indexPath.row withObject:newLayout];
    [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath]
                          withRowAnimation:UITableViewRowAnimationNone];
}

//折叠Cell
- (void)closeTableViewCell:(TableViewCell *)cell {
    CellLayout* layout =  [self.dataSource objectAtIndex:cell.indexPath.row];
    StatusModel* model = layout.statusModel;
    CellLayout* newLayout = [[CellLayout alloc] initWithStatusModel:model
                                                              index:cell.indexPath.row
                                                      dateFormatter:self.dateFormatter];
    
    [self coverScreenshotAndDelayRemoveWithCell:cell cellHeight:newLayout.cellHeight];
    
    
    [self.dataSource replaceObjectAtIndex:cell.indexPath.row withObject:newLayout];
    [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath]
                          withRowAnimation:UITableViewRowAnimationNone];
}

//发表评论
- (void)postCommentWithCommentModel:(CommentModel *)model {
    [[FMDBHelper fmManger] createCommentTable];
    
    CellLayout* layout = [self.dataSource objectAtIndex:model.index];
    NSMutableArray* newCommentLists = [[NSMutableArray alloc] initWithArray:layout.statusModel.commentList];
    NSDictionary* newComment = @{@"from":[BGFunctionHelper isNULLOfString:_chooseUser.name] ? model.from : _chooseUser.name,
                                 @"to":model.to,
                                 @"content":model.content};
    [newCommentLists addObject:newComment];
    StatusModel* statusModel = layout.statusModel;
    statusModel.commentList = newCommentLists;
    CellLayout* newLayout = [self layoutWithStatusModel:statusModel index:model.index];
    
    
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:model.index inSection:0]];
    [self coverScreenshotAndDelayRemoveWithCell:cell cellHeight:newLayout.cellHeight];
    
    [self.dataSource replaceObjectAtIndex:model.index withObject:newLayout];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:model.index inSection:0]]
                          withRowAnimation:UITableViewRowAnimationNone];
    [[FMDBHelper fmManger] insertCommentDataByFriendsId:_chooseFriendsId isFriends:@"1" fromUserId:[BGFunctionHelper isNULLOfString:_chooseUser.name] ? model.from : _chooseUser.name  toUserId:model.to commentContent:model.content];
}



#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.commentView endEditing:YES];
    CGFloat offset = scrollView.contentOffset.y;
    [self.tableViewHeader loadingViewAnimateWithScrollViewContentOffset:offset];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    if (offset <= -kRefreshBoundary) {
        [self refreshBegin];
    }
}

#pragma mark - Keyboard

- (void)tapView:(id)sender {
    [self.commentView endEditing:YES];
}

- (void)keyboardDidAppearNotifications:(NSNotification *)notifications {
    NSDictionary *userInfo = [notifications userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat keyboardHeight = keyboardSize.height;
    self.commentView.frame = CGRectMake(0.0f, SCREEN_HEIGHT - 44.0f - keyboardHeight - 64, SCREEN_WIDTH, 44.0f);
}

- (void)keyboardDidHidenNotifications:(NSNotification *)notifications {
    self.commentView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 44.0f);
}

#pragma mark - Data

//模拟下拉刷新
- (void)refreshBegin {
    [UIView animateWithDuration:0.1f animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(kRefreshBoundary, 0.0f, 0.0f, 0.0f);
    } completion:^(BOOL finished) {
        [self.tableViewHeader refreshingAnimateBegin];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
                           [self fakeDownload];
                       });
    }];
}

//模拟下载数据
- (void)fakeDownload {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
//        if (self.needRefresh) {
            [self.dataSource removeAllObjects];
            [self fakeDatasource];
            for (NSInteger i = 0; i < self.fakeDatasource.count; i ++) {
                LWLayout* layout = [self layoutWithStatusModel:
                                    [[StatusModel alloc] initWithDict:self.fakeDatasource[i]]
                                                         index:i];
                [self.dataSource addObject:layout];
            }
//        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self refreshComplete];
        });
    });
}

//模拟刷新完成
- (void)refreshComplete {
    [self.tableViewHeader refreshingAnimateStop];
    [self.tableView reloadData];
    [UIView animateWithDuration:0.1f animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(-64.0f, 0.0f, 0.0f, 0.0f);
    } completion:^(BOOL finished) {
        
        self.needRefresh = NO;
    }];
}


- (CellLayout *)layoutWithStatusModel:(StatusModel *)statusModel index:(NSInteger)index {
    CellLayout* layout = [[CellLayout alloc] initWithStatusModel:statusModel
                                                           index:index
                                                   dateFormatter:self.dateFormatter];
    return layout;
}

- (void)segmentControlIndexChanged:(UISegmentedControl *)segmentedControl {
    NSInteger idx = segmentedControl.selectedSegmentIndex;
    switch (idx) {
        case 0:
            self.displaysAsynchronously = YES;
            break;
        case 1:
            self.displaysAsynchronously = NO;
            break;
    }
}

#pragma mark - Getter

- (void)setup {
    self.needRefresh = YES;
    self.displaysAsynchronously = YES;
    self.view.backgroundColor = [UIColor whiteColor];
}


- (CommentView *)commentView {
    if (_commentView) {
        return _commentView;
    }
    __weak typeof(self) wself = self;
    _commentView = [[CommentView alloc]
                    initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 54.0f)
                    sendBlock:^(NSString *content) {
                        __strong  typeof(wself) swself = wself;
                        swself.postComment.content = content;
                        [swself postCommentWithCommentModel:swself.postComment];
                    }];
    return _commentView;
}

- (UITableView *)tableView {
    if (_tableView) {
        return _tableView;
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height - 64)
                                              style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = self.tableViewHeader;
    return _tableView;
}

- (TableViewHeader *)tableViewHeader {
    if (_tableViewHeader) {
        return _tableViewHeader;
    }
    
    _tableViewHeader =
    [[TableViewHeader alloc] initWithFrame:CGRectMake(0.0f,
                                                      0.0f,
                                                      kScreenSize.width,
                                                      350.0f)];
    
//    NSData *bgImageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"bgImage"];
//    if (bgImageData) {
//        [self.tableViewHeader setBGImage:[UIImage imageWithData:bgImageData]];
//    }
    
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [_tableViewHeader addGestureRecognizer:singleRecognizer];
    
    return _tableViewHeader;
}

- (void)handleSingleTapFrom{
//    kAlert(@"点击了背景");
    [[TakePicDelegate defaultManager] jumpAlarmInViewController:self notiName:@"changeBGImage"];
}

- (void)changeBGImage:(NSNotification *)noti{
    [[NSUserDefaults standardUserDefaults] setObject:noti.object forKey:@"bgImage"];
    [self.tableViewHeader setBGImage:[UIImage imageWithData:(NSData *)noti.object]];
}

- (NSMutableArray *)dataSource {
    if (_dataSource) {
        return _dataSource;
    }
    _dataSource = [[NSMutableArray alloc] init];
    return _dataSource;
}

- (NSDateFormatter *)dateFormatter {
    static NSDateFormatter* dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM月dd日 hh:mm"];
    });
    return dateFormatter;
}

- (CommentModel *)postComment {
    if (_postComment) {
        return _postComment;
    }
    _postComment = [[CommentModel alloc] init];
    return _postComment;
}

- (NSMutableArray *)fakeDatasource {
    _fakeDatasource = [NSMutableArray array];
    NSMutableArray *reversedArray = [NSMutableArray array];
    [[FMDBHelper fmManger] createImagesTable];
    [[FMDBHelper fmManger] createZanTable];
    [[FMDBHelper fmManger] createCommentTable];
    
    NSArray *dataArray = [[FMDBHelper fmManger] selectFriendsWhereValue1:@"" value2:@"" isNeed:NO];
    
    for (int i = 0; i < dataArray.count; i ++) {
        
        //朋友圈信息
        FriendsModel *model = dataArray[i];
        NSArray *imageArray = [[FMDBHelper fmManger] selectFriendsImageWhereValue1:@"friendsId" value2:model.Id isNeed:YES];
        
        //发送朋友圈用户
        UserInfoModel *userInfo = [[[FMDBHelper fmManger] selectUserInfoDataByValueName:@"Id" value:model.userId] lastObject];
        
        //评论
        NSArray *commentArray =[[FMDBHelper fmManger] selectCommentWhereValue1:@"friendsId" value2:model.Id isNeed:YES];
        NSMutableArray *commentList = [NSMutableArray array];
        for (CommentModel2 *model in commentArray) {
//            UserInfoModel *fromUser = [[[FMDBHelper fmManger] selectUserInfoDataByValueName:@"Id" value:model.fromUserId] lastObject];
//            UserInfoModel *toUser = [[[FMDBHelper fmManger] selectUserInfoDataByValueName:@"Id" value:model.toUserId] lastObject];
            NSDictionary *dic = [[NSDictionary alloc] init];
            if ([BGFunctionHelper isNULLOfString:model.toUserId]) {
                dic =@{
                       @"from":model.fromUserId,
                       @"content":model.commentContent
                       };
            }else{
                dic =@{
                       @"from":model.fromUserId,
                       @"to":model.toUserId,
                       @"content":model.commentContent
                       };
            }
            
            [commentList addObject:dic];
        }
        
        //点赞
        NSArray *zanArray = [[FMDBHelper fmManger] selectZanWhereValue1:@"friendsId" value2:model.Id isNeed:YES];
        NSMutableArray *zanList = [NSMutableArray array];
        for (ZanModel *zanModel in zanArray) {
            [zanList addObject:zanModel.userId];
        }
        
        NSDictionary *dataSourceDict = [[NSDictionary alloc] init];
        
//        NSDate *date = (NSDate *)[BGDateHelper getTimeStempByString:model.date havehh:YES];
        
        NSDateFormatter* formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

        
        NSDate* date = [formater dateFromString:model.date];
        NSDate *timeSp = (NSDate *)[NSString stringWithFormat:@"%ld",(long)[date timeIntervalSince1970]];
        
        if ([BGFunctionHelper isNULLOfString:model.textContent] && imageArray.count > 0) {
            dataSourceDict =@{@"type":@"image",
                              @"name":userInfo.name,
                              @"avatar":userInfo.headImage,
                              @"date":timeSp,
                              @"imgs":imageArray,
                              @"statusID":model.Id,
                              @"commentList":commentList,
                              @"isLike":@(NO),
                              @"likeList":zanList
                              };
        }else if (imageArray.count > 0 && ![BGFunctionHelper isNULLOfString:model.textContent]){
            dataSourceDict =@{@"type":@"image",
                              @"name":userInfo.name,
                              @"avatar":userInfo.headImage,
                              @"content":model.textContent,
                              @"date":timeSp,
                              @"imgs":imageArray,
                              @"statusID":model.Id,
                              @"commentList":commentList,
                              @"isLike":@(NO),
                              @"likeList":zanList
                              };
        }else if(![BGFunctionHelper isNULLOfString:model.textContent]){
            dataSourceDict =@{@"type":@"image",
                              @"name":userInfo.name,
                              @"avatar":userInfo.headImage,
                              @"content":model.textContent,
                              @"date":timeSp,
                              @"statusID":model.Id,
                              @"commentList":commentList,
                              @"isLike":@(NO),
                              @"likeList":zanList
                              };
        }
        
        [reversedArray addObject:dataSourceDict];
    }
    _fakeDatasource = (NSMutableArray *)[[reversedArray reverseObjectEnumerator] allObjects];
    return _fakeDatasource;
}

- (void)chooseUser:(NSNotification *)noti{
    UIStoryboard *storyboard = kWechatStroyboard;
    ChooseAnyUsersViewController *chooseAnyUserVC = [storyboard instantiateViewControllerWithIdentifier:@"ChooseAnyUsersViewController"];
    chooseAnyUserVC.chooseNum = @"1";
    chooseAnyUserVC.notiName = @"pinglunren";
    [self.navigationController pushViewController:chooseAnyUserVC animated:YES];
}

- (void)choosePerson:(NSNotification *)noti{
    _chooseUser = [noti.object lastObject];
    
    [self.commentView.emojiButton setImage:[UIImage imageWithData:_chooseUser.headImage] forState:UIControlStateNormal];
}
//    _fakeDatasource =
//    @[@{@"type":@"image",
//        @"name":userInfo.name,
//        @"avatar":userInfo.headImage,
//        @"content":model.textContent,
//        @"date":model.date,
//        @"imgs":imageArray,
//        @"statusID":model.Id,
////        @"commentList":@[@{@"from":@"SIZE潮流生活",
////                           @"to":@"waynezxcv",
////                           @"content":@"nice~使用Gallop。支持异步绘制，让滚动如丝般顺滑。"}],
//        @"isLike":@(NO),
////        @"likeList":@[@"waynezxcv"]
//        },
    
//      @{@"type":@"image",
//        @"name":@"SIZE潮流生活",
//        @"avatar":@"http://tp2.sinaimg.cn/1829483361/50/5753078359/1",
//        @"content":@"近日[心][心][心][心][心][心][face]，adidas Originals😂为经典鞋款Stan Smith打造Primeknit版本，并带来全新的“OG”系列。简约的鞋身采用白色透气Primeknit针织材质制作，再将Stan Smith代表性的绿、红、深蓝三个元年色调融入到鞋舌和后跟点缀，最后搭载上米白色大底来保留其复古风味。据悉该鞋款将在今月登陆全球各大adidas Originals指定店舖。https://github.com/waynezxcv/Gallop <-",
//        @"date":@"1459668442",
//        @"imgs":@[@"http://ww2.sinaimg.cn/mw690/6d0bb361gw1f2jim2hgxij20lo0egwgc.jpg",
//                  @"http://ww3.sinaimg.cn/mw690/6d0bb361gw1f2jim2hsg6j20lo0egwg2.jpg",
//                  @"http://ww1.sinaimg.cn/mw690/6d0bb361gw1f2jim2d7nfj20lo0eg40q.jpg",
//                  @"http://ww1.sinaimg.cn/mw690/6d0bb361gw1f2jim2hka3j20lo0egdhw.jpg",
//                  @"http://ww2.sinaimg.cn/mw690/6d0bb361gw1f2jim2hq61j20lo0eg769.jpg"],
//        @"statusID":@"1",
//        @"commentList":@[@{@"from":@"SIZE潮流生活",
//                           @"to":@"",
//                           @"content":@"使用Gallop来快速构建图文混排界面。享受如丝般顺滑的滚动体验。"},
//                         @{@"from":@"waynezxcv",
//                           @"to":@"SIZE潮流生活",
//                           @"content":@"哈哈哈哈"},
//                         @{@"from":@"SIZE潮流生活",
//                           @"to":@"waynezxcv",
//                           @"content":@"nice~使用Gallop。支持异步绘制，让滚动如丝般顺滑。"}],
//        @"isLike":@(NO),
//        @"likeList":@[@"waynezxcv",@"伊布拉希莫维奇",@"权志龙",@"郜林",@"扎克伯格"]},
//      
//      @{@"type":@"website",
//        @"name":@"Ronaldo",
//        @"avatar":@"https://avatars0.githubusercontent.com/u/8408918?v=3&s=460",
//        @"content":@"Easy to use yet capable of so much, iOS 9 was engineered to work hand in hand with the advanced technologies built into iPhone.",
//        @"date":@"1459668442",
//        @"imgs":@[@"http://ww2.sinaimg.cn/mw690/6d0bb361gw1f2jim2hgxij20lo0egwgc.jpg"],
//        @"detail":@"LWAlchemy,A fast and lightweight ORM framework for Cocoa and Cocoa Touch.",
//        @"statusID":@"1",
//        @"commentList":@[@{@"from":@"伊布拉西莫维奇",
//                           @"to":@"",
//                           @"content":@"使用Gallop来快速构建图文混排界面。享受如丝般顺滑的滚动体验。"}],
//        @"isLike":@(NO),
//        @"likeList":@[@"waynezxcv",@"Gallop"]},
//      
//      
//      @{@"type":@"image",
//        @"name":@"妖妖小精",
//        @"avatar":@"http://tp2.sinaimg.cn/2185608961/50/5714822219/0",
//        @"content":@"出国留学的儿子为思念自己的家人们寄来一个用自己照片做成的人形立牌",
//        @"date":@"1459668442",
//        @"imgs":@[@"http://ww3.sinaimg.cn/mw690/8245bf01jw1f2jhh2ohanj20jg0yk418.jpg",
//                  @"http://ww4.sinaimg.cn/mw690/8245bf01jw1f2jhh34q9rj20jg0px77y.jpg",
//                  @"http://ww1.sinaimg.cn/mw690/8245bf01jw1f2jhh3grfwj20jg0pxn13.jpg",
//                  @"http://ww4.sinaimg.cn/mw690/8245bf01jw1f2jhh3ttm6j20jg0el76g.jpg",
//                  @"http://ww3.sinaimg.cn/mw690/8245bf01jw1f2jhh43riaj20jg0pxado.jpg",
//                  @"http://ww2.sinaimg.cn/mw690/8245bf01jw1f2jhh4mutgj20jg0ly0xt.jpg",
//                  @"http://ww3.sinaimg.cn/mw690/8245bf01jw1f2jhh4vc7pj20jg0px41m.jpg",],
//        @"statusID":@"2",
//        @"commentList":@[@{@"from":@"炉石传说",
//                           @"to":@"",
//                           @"content":@"#炉石传说#"},
//                         @{@"from":@"waynezxcv",
//                           @"to":@"SIZE潮流生活",
//                           @"content":@"哈哈哈哈"},
//                         @{@"from":@"SIZE潮流生活",
//                           @"to":@"waynezxcv",
//                           @"content":@"nice~使用Gallop。支持异步绘制，让滚动如丝般顺滑。"}],
//        @"isLike":@(NO),
//        @"likeList":@[@"waynezxcv"]},
//      
//      @{@"type":@"image",
//        @"name":@"Instagram热门",
//        @"avatar":@"http://tp4.sinaimg.cn/5074408479/50/5706839595/0",
//        @"content":@"Austin Butler & Vanessa Hudgens  想试试看扑到一个一米八几的人怀里是有多舒服[心]",
//        @"date":@"1459668442",
//        @"imgs":@[@"http://ww1.sinaimg.cn/mw690/005xpHs3gw1f2jg132p3nj309u0goq62.jpg",
//                  @"http://ww3.sinaimg.cn/mw690/005xpHs3gw1f2jg14per3j30b40ctmzp.jpg",
//                  @"http://ww3.sinaimg.cn/mw690/005xpHs3gw1f2jg14vtjjj30b40b4q5m.jpg",
//                  @"http://ww1.sinaimg.cn/mw690/005xpHs3gw1f2jg15amskj30b40f1408.jpg",
//                  @"http://ww3.sinaimg.cn/mw690/005xpHs3gw1f2jg16f8vnj30b40g4q4q.jpg",
//                  @"http://ww4.sinaimg.cn/mw690/005xpHs3gw1f2jg178dxdj30am0gowgv.jpg",
//                  @"http://ww2.sinaimg.cn/mw690/005xpHs3gw1f2jg17c5urj30b40ghjto.jpg"],
//        @"statusID":@"3",
//        @"commentList":@[@{@"from":@"waynezxcv",
//                           @"to":@"SIZE潮流生活",
//                           @"content":@"哈哈哈哈"},
//                         @{@"from":@"SIZE潮流生活",
//                           @"to":@"waynezxcv",
//                           @"content":@"nice~使用Gallop。支持异步绘制，让滚动如丝般顺滑。"}],
//        @"isLike":@(NO),
//        @"likeList":@[@"Tim Cook"]},
//      
//      
//      @{@"type":@"image",
//        @"name":@"头条新闻",
//        @"avatar":@"http://tp1.sinaimg.cn/1618051664/50/5735009977/0",
//        @"content":@"#万象# 【熊孩子！4名小学生铁轨上设障碍物逼停火车】4名小学生打赌，1人认为火车会将石头碾成粉末，其余3人不信，认为只会碾碎，于是他们将道碴摆放在铁轨上。火车司机发现前方不远处的铁轨上，摆放了影响行车安全的障碍物，于是紧急采取制动，列车中途停车13分钟。O4名学生铁轨上设障碍物逼停火车#waynezxcv# nice",
//        @"date":@"1459668442",
//        @"imgs":@[@"http://ww2.sinaimg.cn/mw690/60718250jw1f2jg46smtmj20go0go77r.jpg"],
//        @"statusID":@"4",
//        @"commentList":@[@{@"from":@"waynezxcv",
//                           @"to":@"SIZE潮流生活",
//                           @"content":@"哈哈哈哈"},
//                         @{@"from":@"SIZE潮流生活",
//                           @"to":@"waynezxcv",
//                           @"content":@"nice~使用Gallop。支持异步绘制，让滚动如丝般顺滑。"}],
//        @"isLike":@(NO),
//        @"likeList":@[@"Tim Cook"]},
//      
//      
//      @{@"type":@"image",
//        @"name":@"Kindle中国",
//        @"avatar":@"http://tp1.sinaimg.cn/3262223112/50/5684307907/1",
//        @"content":@"#只限今日#《简单的逻辑学》作者D.Q.麦克伦尼在书中提出了28种非逻辑思维形式，抛却了逻辑学一贯的刻板理论，转而以轻松的笔触带领我们畅游这个精彩无比的逻辑世界；《蝴蝶梦》我错了，我曾以为付出自己就是爱你。全球公认20世纪伟大的爱情经典，大陆独家合法授权。",
//        @"date":@"",
//        @"imgs":@[@"http://ww2.sinaimg.cn/mw690/c2719308gw1f2hav54htyj20dj0l00uk.jpg",
//                  @"http://ww4.sinaimg.cn/mw690/c2719308gw1f2hav47jn7j20dj0j341h.jpg"],
//        @"statusID":@"6",
//        @"commentList":@[@{@"from":@"Kindle中国",
//                           @"to":@"",
//                           @"content":@"统一回复,使用Gallop来快速构建图文混排界面。享受如丝般顺滑的滚动体验。"}],
//        @"isLike":@(NO),
//        @"likeList":@[@"waynezxcv"]},
//      
//      
//      
//      @{@"type":@"image",
//        @"name":@"G-SHOCK",
//        @"avatar":@"http://tp3.sinaimg.cn/1595142730/50/5691224157/1",
//        @"content":@"就算平时没有时间，周末也要带着G-SHOCK到户外走走，感受大自然的满满正能量！",
//        @"date":@"1459668442",
//        @"imgs":@[@"http://ww2.sinaimg.cn/mw690/5f13f24ajw1f2hc1r6j47j20dc0dc0t4.jpg"],
//        @"statusID":@"7",
//        @"commentList":@[@{@"from":@"SIZE潮流生活",
//                           @"to":@"",
//                           @"content":@"使用Gallop来快速构建图文混排界面。享受如丝般顺滑的滚动体验。"},
//                         @{@"from":@"waynezxcv",
//                           @"to":@"SIZE潮流生活",
//                           @"content":@"哈哈哈哈"},
//                         @{@"from":@"SIZE潮流生活",
//                           @"to":@"waynezxcv",
//                           @"content":@"nice~使用Gallop。支持异步绘制，让滚动如丝般顺滑。"}],
//        @"isLike":@(NO),
//        @"likeList":@[@"waynezxcv"]},
//      
//      
//      
//      
//      
//      @{@"type":@"image",
//        @"name":@"数字尾巴",
//        @"avatar":@"http://tp1.sinaimg.cn/1726544024/50/5630520790/1",
//        @"content":@"外媒 AndroidAuthority 日前曝光诺基亚首款回归作品 NOKIA A1 的渲染图，手机的外形很 N 记，边框控制的不错。这是一款纯正的 Android 机型，传闻手机将采用 5.5 英寸 1080P 屏幕，搭载骁龙 652，Android 6.0 系统，并使用了诺基亚自家的 Z 启动器，不过具体发表的时间还是未知。尾巴们你会期待吗？",
//        @"date":@"1459668442",
//        @"imgs":@[@"http://ww3.sinaimg.cn/mw690/66e8f898gw1f2jck6jnckj20go0fwdhb.jpg"],
//        @"statusID":@"9",
//        @"commentList":@[@{@"from":@"SIZE潮流生活",
//                           @"to":@"",
//                           @"content":@"使用Gallop来快速构建图文混排界面。享受如丝般顺滑的滚动体验。"},
//                         @{@"from":@"waynezxcv",
//                           @"to":@"SIZE潮流生活",
//                           @"content":@"哈哈哈哈"},
//                         @{@"from":@"SIZE潮流生活",
//                           @"to":@"waynezxcv",
//                           @"content":@"nice~使用Gallop。支持异步绘制，让滚动如丝般顺滑。"}],
//        @"isLike":@(NO),
//        @"likeList":@[@"waynezxcv"]},
//      
//      
//      @{@"type":@"image",
//        @"name":@"欧美街拍XOXO",
//        @"avatar":@"http://tp4.sinaimg.cn/1708004923/50/1283204657/0",
//        @"content":@"3.31～4.2 肯豆",
//        @"date":@"1459668442",
//        @"imgs":@[@"http://ww2.sinaimg.cn/mw690/65ce163bjw1f2jdkd2hgjj20cj0gota8.jpg",
//                  @"http://ww1.sinaimg.cn/mw690/65ce163bjw1f2jdkjdm96j20bt0gota9.jpg",
//                  @"http://ww2.sinaimg.cn/mw690/65ce163bjw1f2jdkvwepij20go0clgnd.jpg",
//                  @"http://ww4.sinaimg.cn/mw690/65ce163bjw1f2jdl2ao77j20ci0gojsw.jpg",],
//        @"statusID":@"10",
//        @"commentList":@[@{@"from":@"waynezxcv",
//                           @"to":@"SIZE潮流生活",
//                           @"content":@"哈哈哈哈"}],
//        @"isLike":@(NO),
//        @"likeList":@[@"waynezxcv"]},
//      ];
    
//}

@end
