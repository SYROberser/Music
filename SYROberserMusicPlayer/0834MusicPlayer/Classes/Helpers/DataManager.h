//
//  DataManager.h
//  0834MusicPlayer
//
//  Created by 郑建文 on 15/11/4.
//  Copyright © 2015年 Lanou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicModel.h"

typedef void(^UpdataUI)();

@interface DataManager : NSObject


@property (nonatomic,copy) UpdataUI myUpdataUI;
@property (nonatomic,strong) NSArray * allMusic;
/**
 *  单例方法
 *
 *  @return 单例
 */
+ (DataManager *)sharedManager;

/**
 *  根据cell的索引返回一个model
 *
 *  @param index 索引值
 *
 *  @return model
 */
- (MusicModel *)musicModelWithIndex:(NSInteger)index;

@end
