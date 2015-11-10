//
//  PlayingViewController.h
//  0834MusicPlayer
//
//  Created by 郑建文 on 15/11/5.
//  Copyright © 2015年 Lanou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingViewController : UIViewController

//要播放第几首
@property (nonatomic,assign) NSInteger index;

+ (instancetype)sharedPlayingPVC;

@end
