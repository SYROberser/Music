//
//  MusicCell.m
//  0834MusicPlayer
//
//  Created by 郑建文 on 15/11/4.
//  Copyright © 2015年 Lanou. All rights reserved.
//

#import "MusicCell.h"

@interface MusicCell()

@property (weak, nonatomic) IBOutlet UIImageView *img4Pic;

@property (weak, nonatomic) IBOutlet UILabel *lab4SingerName;

@end

@implementation MusicCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(MusicModel *)model{
    _model = model;
    
    [self.img4Pic sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
    
    self.lab4SongName.text = model.name;
    
    self.lab4SingerName.text = model.singer;
}

@end
