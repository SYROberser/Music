//
//  MusicCell.h
//  0834MusicPlayer
//
//  Created by 郑建文 on 15/11/4.
//  Copyright © 2015年 Lanou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicModel.h"

@interface MusicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lab4SongName;
@property (nonatomic,strong) MusicModel * model;

@end
