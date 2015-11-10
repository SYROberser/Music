//
//  PlayerManager.m
//  0834MusicPlayer
//
//  Created by 郑建文 on 15/11/5.
//  Copyright © 2015年 Lanou. All rights reserved.
//

#import "PlayerManager.h"


@interface PlayerManager ()



//计时器
@property(nonatomic,strong)NSTimer* timer;
@end


@implementation PlayerManager

static PlayerManager *manager = nil;
//单例方法
+ (instancetype)sharedManager{
   
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [PlayerManager new];
        manager.player = [AVPlayer new];
        //设置播放器音量
        manager.player.volume = 1.0;
    });
    return manager;
}

- (void)playWithUrlString:(NSString *)urlStr{
    
    if (self.player.currentItem) {
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    }
    //创建一个Item
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:urlStr]];
    
    //替换当前正在播放的音乐
    [self.player replaceCurrentItemWithPlayerItem:item];

#pragma mark -- 添加观察者
    //(NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld )
    [item addObserver:self forKeyPath:@"status" options: (NSKeyValueObservingOptionNew)context:nil];
    
}

#pragma mark - lazy load
- (AVPlayer *)player{
    if (!_player) {
        _player = [AVPlayer new];
    }
    return _player;
}
-(void)currentVoice:(float)voice {
    self.player.volume =voice;
}
#pragma mark --观察者响应事件
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    AVPlayerItemStatus status = [change[@"new"]integerValue];

    switch (status) {
        case AVPlayerItemStatusFailed:
            NSLog(@"加载失败");
            break;
            case AVPlayerItemStatusUnknown:
            NSLog(@"资源不对");
            break;
            case AVPlayerItemStatusReadyToPlay:
            NSLog(@"准备完毕,等待发射");
            //先暂停,在销毁,然后播放
            [self pause];
            [self play];
            break;
        default:
            break;
    }
}

//播放
-(void)play{
    //如果正在播放的话,就不播放,返回就行
//    if (_isPlaying) {
//        return;
//    }
    [self.player play];
//    开始播放标记为yes
    _isPlaying = YES;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playingWithSeconds) userInfo:nil repeats:YES];
}

-(void)playingWithSeconds{
//    NSLog(@"%lld",self.player.currentTime.value/self.player.currentTime.timescale);
    if (self.delegate &&[self.delegate respondsToSelector:@selector(playerDidPlayInWithTime:)]) {

        NSTimeInterval time = self.player.currentTime.value/self.player.currentTime.timescale;
        
        [self.delegate playerDidPlayInWithTime:time];
    }
    
}

//暂停
-(void)pause{
    [self.player pause];
    //    暂停播放标记为no
    _isPlaying = NO;
    
    [self.timer invalidate];
    self.timer = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerDidPlayEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}


-(void)playerDidPlayEnd:(NSNotification *)not{
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(playerDidPlayEnd)]) {
        //接收到item播放结束后,让代理去切换下一首,播放器不需要知道
        [self.delegate playerDidPlayEnd];
    }
}

//time: 50秒
-(void)seekToTime:(NSTimeInterval)time{
    [self pause];
    
    [self.player seekToTime:CMTimeMakeWithSeconds(time, self.player.currentTime.timescale) completionHandler:^(BOOL finished) {
        if (finished) {
            //拖拽成功后再播放
            [self play];
        }
    }];
}
-(CGFloat)volume{
    return self.player.volume;
}



@end
