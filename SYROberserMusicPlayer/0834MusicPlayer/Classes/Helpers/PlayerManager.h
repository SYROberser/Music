//
//  PlayerManager.h
//  0834MusicPlayer
//
//  Created by 郑建文 on 15/11/5.
//  Copyright © 2015年 Lanou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#pragma mark --写协议
@protocol playerManagerDelegate <NSObject>



//当一首歌播放结束后,让代理去做的事情
-(void)playerDidPlayEnd;

//播放中刷新ui时间
-(void)playerDidPlayInWithTime:(NSTimeInterval)time;

@end


@interface PlayerManager : NSObject

#pragma mark -- 
//播放器 -> 全局唯一,因为如果有两个avplayer的话,就会同时播放两个音乐.
@property (nonatomic,strong) AVPlayer * player;



//判断是否正在播放
@property(nonatomic,assign)BOOL isPlaying;

+ (instancetype)sharedManager;

//给一个链接,让AVPlayer播放
- (void)playWithUrlString:(NSString *)urlStr;


//写一个对外开放的接口
//播放
-(void)play;

//暂停
-(void)pause;

//改变进度
-(void)seekToTime:(NSTimeInterval)time;

//改变音量
-(void)currentVoice:(float)voice;

//用来访问avplayer音量
-(CGFloat)volume;


#pragma mark -- 代理
@property(nonatomic,assign)id <playerManagerDelegate>delegate;

@end
