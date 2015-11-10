//
//  LyricManager.h
//  0834MusicPlayer
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 Lanou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricManager : NSObject

+(LyricManager *)shareManager;

//接口
-(void)loadLyricWith:(NSString *)lyricStr;
//对外歌词
@property(nonatomic,retain)NSArray *allLyric;

/**
 *  //根据时间获取到该播放的歌词的索引
 *
 *  @param NSInteger <#NSInteger description#>
 *
 *  @return <#return value description#>
 */

-(NSInteger)indexWith:(NSTimeInterval)time;

@end
