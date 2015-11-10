//
//  PlayingViewController.m
//  0834MusicPlayer
//
//  Created by 郑建文 on 15/11/5.
//  Copyright © 2015年 Lanou. All rights reserved.
//

#import "PlayingViewController.h"
#import "PlayerManager.h"
#import "DataManager.h"
#import "UIImageView+WebCache.h"
#import "LyricManager.h"
#import "LyricModel.h"
#import "JDStatusBarNotification.h"

@interface PlayingViewController ()<playerManagerDelegate,UITableViewDelegate,UITableViewDataSource>
//记录一下当前播放的音乐的索引
@property (nonatomic,assign) NSInteger currentIndex;

//记录下当前播放的音乐
@property(nonatomic,strong)MusicModel *currentModel;


#pragma mark -- 控件
@property (strong, nonatomic) IBOutlet UILabel *songName;
@property (strong, nonatomic) IBOutlet UILabel *singerName;
@property (strong, nonatomic) IBOutlet UIImageView *img4Pic;

@property (strong, nonatomic) IBOutlet UILabel *lab4PlayTime;
@property (strong, nonatomic) IBOutlet UILabel *lab4LastTime;
@property (strong, nonatomic) IBOutlet UISlider *slider4Time;//持续播放时间
@property (strong, nonatomic) IBOutlet UISlider *slider4Volume;//音量
@property (strong, nonatomic) IBOutlet UIButton *ben4PlayOrPause;
@property (strong, nonatomic) IBOutlet UITableView *tableView4Lyric;



#pragma mark - 控件事件
- (IBAction)action4Prev:(UIButton *)sender;
- (IBAction)action4PlayOrPause:(UIButton *)sender;
- (IBAction)action4Next:(UIButton *)sender;
- (IBAction)action4ChangeTime:(UISlider *)sender;
- (IBAction)action4ChangeVolume:(UISlider *)sender;


@end
//cell
static NSString *identfier = @"cellReuse";

static PlayingViewController *playingVC = nil;
@implementation PlayingViewController

+ (instancetype)sharedPlayingPVC{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //拿到main sb
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //在main sb 拿到我们要用的视图控制器
        playingVC = [sb instantiateViewControllerWithIdentifier:@"playingVC"];
        
    });
    return playingVC;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //如果要播放的音乐和当前播放的音乐一样,就什么都不干了.
    if (_index == _currentIndex) {
        return;
    }
    //如果不等于
    _currentIndex = _index;
    
    [self startPlay];
    
    
}

- (void)startPlay{
    
//    //取到要播放的model
//    MusicModel *model = [[DataManager sharedManager] musicModelWithIndex:self.currentIndex];
    
    [[PlayerManager sharedManager] playWithUrlString:self.currentModel.mp3Url];
    
    
    [self buildingUI];
}

-(void)buildingUI{
    
    self.songName.text = self.currentModel.name;
    self.singerName.text = self.currentModel.singer;
    
    [self.img4Pic sd_setImageWithURL:[NSURL URLWithString:self.currentModel.picUrl]];

    //更改button
    [self.ben4PlayOrPause setImage:[UIImage imageNamed:@"Pause_32px_1194080_easyicon.net"] forState:UIControlStateNormal];
    //改变进度条最大值
    self.slider4Time.maximumValue = [self.currentModel.duration integerValue]/1000;
    self.slider4Time.value = 0;
    //更改旋转角度,当切换歌曲时
    self.img4Pic.transform = CGAffineTransformMakeRotation(0);
    
    //解析歌词
    [[LyricManager shareManager] loadLyricWith:self.currentModel.lyric];
    [self.tableView4Lyric reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _currentIndex = -1;
    //设置自己为播放器代理,帮播放器做事
    [PlayerManager sharedManager].delegate =self;
    
    
    //注册
    [self.tableView4Lyric registerClass:[UITableViewCell class] forCellReuseIdentifier:identfier];
    self.slider4Volume.value = [[PlayerManager sharedManager]volume];
    
    
}
#pragma mark -- 代理实现方法
-(void)playerDidPlayEnd{
//    _currentIndex++;
//    [self startPlay];
    [self action4Next:nil];
 
    
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


#pragma mark -- UITableViewDataSource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [LyricManager shareManager].allLyric.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identfier forIndexPath:indexPath];
    LyricModel *lyric = [LyricManager shareManager].allLyric[indexPath.row];
    cell.textLabel.text = lyric.lyricContext;
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    //
    UIImageView *aView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cellBack"]];
    aView.backgroundColor = [UIColor purpleColor];
    cell.selectedBackgroundView = aView;
    cell.backgroundColor = [UIColor orangeColor];

    return cell;
}

//************************************

- (IBAction)action4Back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//上一首
- (IBAction)action4Prev:(UIButton *)sender {
    _currentIndex--;
    //判断是否第一首
    if (_currentIndex == -1) {
        _currentIndex = [DataManager sharedManager].allMusic.count - 1;
    }
 [JDStatusBarNotification showWithStatus:self.currentModel.name dismissAfter:1 styleName:JDStatusBarStyleSuccess];
    
    [self startPlay];
    
}

//暂停或者播放
- (IBAction)action4PlayOrPause:(UIButton *)sender {
    //如果正在播放就让其暂停,反之如此,同时改变buttn的文字
    if ([PlayerManager sharedManager].isPlaying) {
        [[PlayerManager sharedManager]pause];
         [sender setImage:[UIImage imageNamed:@"play_32px_1194928_easyicon.net"] forState:UIControlStateNormal];
    }else{
        [[PlayerManager sharedManager]play];
        [sender setImage:[UIImage imageNamed:@"Pause_32px_1194080_easyicon.net"] forState:UIControlStateNormal];
    }

}

//下一首
- (IBAction)action4Next:(UIButton *)sender {
#pragma mark --随机播放
        //在播放下一首是先暂停销毁timer
    [[PlayerManager sharedManager]pause];
    int random;
    random = arc4random()%[DataManager sharedManager].allMusic.count;

    _currentIndex = random;
    //判断是不是最后一首
   
    if (_currentIndex == [DataManager sharedManager].allMusic.count) {
        //是最后一首返回第一首
        _currentIndex = 0;
    }
    [JDStatusBarNotification showWithStatus:self.currentModel.name dismissAfter:1 styleName:JDStatusBarStyleSuccess];


    
    [self startPlay];
}

//持续时间
- (IBAction)action4ChangeTime:(UISlider *)sender {
    UISlider *slider = sender;
//    slider.maximumValue
    [[PlayerManager sharedManager]seekToTime:slider.value];
}
//?????????????????
-(void)playerDidPlayInWithTime:(NSTimeInterval)time{
    
    self.slider4Time.value = time;
    self.lab4PlayTime.text = [self stringWithTime:time];
    NSTimeInterval time2 = [self.currentModel.duration integerValue]/1000 -time;
    self.lab4LastTime.text = [self stringWithTime:time2];
    //没0.1秒旋转1度
    self.img4Pic.transform = CGAffineTransformRotate(self.img4Pic.transform, M_PI/180);
    
    //根据当前播放时间获取到应该播放哪句歌词
    
    NSInteger index = [[LyricManager shareManager]indexWith:time];
    NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
    //让tableView选中我们找到的歌词
    [self.tableView4Lyric selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}


-(NSString *)stringWithTime:(NSTimeInterval)time{
    NSInteger minutes = time/60;
    NSInteger seconds = (int)time%60;
    return [NSString stringWithFormat:@"⌚️%ld:%ld",(long)minutes,(long)seconds];
}

//改变音量
- (IBAction)action4ChangeVolume:(UISlider *)sender {
    UISlider *slider = sender;
    slider.maximumValue = 1.0;
////
//    [[PlayerManager sharedManager] currentVoice:sender.value];
    [PlayerManager sharedManager].player.volume = sender.value;

    
}


-(MusicModel *)currentModel{
    MusicModel *model = [[DataManager sharedManager] musicModelWithIndex:self.currentIndex];
    return model;

}
@end
