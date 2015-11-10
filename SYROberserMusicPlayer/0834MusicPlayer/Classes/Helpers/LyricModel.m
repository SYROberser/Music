//
//  LyricModel.m
//  0834MusicPlayer
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 Lanou. All rights reserved.
//

#import "LyricModel.h"

@implementation LyricModel

- (instancetype)initWithTime:(NSTimeInterval)time lyric:(NSString *)lyric
{
    self = [super init];
    if (self) {
        _time = time;
        _lyricContext = lyric;
    }
    return self;
}
@end
