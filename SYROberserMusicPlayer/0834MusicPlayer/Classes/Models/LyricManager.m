//
//  LyricManager.m
//  0834MusicPlayer
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 Lanou. All rights reserved.
//

#import "LyricManager.h"
#import "LyricModel.h"

@interface LyricManager ()

//用来存放歌词的数组
@property(nonatomic,strong)NSMutableArray *lyrics;

@end


static LyricManager *lyric = nil;
@implementation LyricManager
+(LyricManager *)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lyric = [LyricManager new];
    });
    return lyric;
}

-(void)loadLyricWith:(NSString *)lyricStr{
    //先移除之前歌曲歌词
    [self.lyrics removeAllObjects];
    
    
    if ([lyricStr isEqualToString:@""]) {
        LyricModel *model = [[LyricModel alloc] initWithTime:0 lyric:@"无歌词"];
        [self.lyrics addObject:model];

        return;
    }
    
    //1.分行
    NSMutableArray *lyricStringArray = [[lyricStr componentsSeparatedByString:@"\n"] mutableCopy];
    //最后一行为@""
    //移除最后一行
    [lyricStringArray removeLastObject];
    
    
    //进行加载下一首歌曲
    
    for (NSString *str in lyricStringArray) {
        
        if ([str isEqualToString:@""]) {
            continue;
        }
        
//        NSLog(@"%@",str);
        //2.分开时间和歌词
        NSArray *timeAndLyric =[str componentsSeparatedByString:@"]"];
        if (timeAndLyric.count != 2) {
            continue;
        }
        //3.去掉时间左边的"["
        NSString *time = [timeAndLyric[0] substringFromIndex:1];
        
        //4.截取时间获取分和秒
        NSArray *minuteAndSecond = [time componentsSeparatedByString:@":"];
        NSInteger minute = [minuteAndSecond[0] integerValue];
        //秒
        NSInteger second = [minuteAndSecond[1] doubleValue];
        //装成一个model
        LyricModel *model = [[LyricModel alloc]initWithTime:(minute *60 + second) lyric:timeAndLyric[1]];
        
        //添加到数组中
        [self.lyrics addObject:model];
        
        
    }
    
}
//懒加载
-(NSMutableArray *)lyrics{
    if (!_lyrics) {
        _lyrics = [NSMutableArray new];
    }
    return _lyrics;
}

-(NSArray *)allLyric{
    return self.lyrics;
}

//歌词滚动
-(NSInteger)indexWith:(NSTimeInterval)time{
   
    NSInteger index = 0;
    for (int i = 0; i <self.lyrics.count; i++) {
        LyricModel *model = self.lyrics[i];
        if (model.time > time) {
            index = (i-1 > 0) ? i -1 :0;
#warning 一定要加,否则一直循环到倒数第二个
//            break;
        }
    }
    return index;
    
}


@end
