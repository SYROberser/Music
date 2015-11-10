//
//  MusicListController.m
//  0834MusicPlayer
//
//  Created by 郑建文 on 15/11/4.
//  Copyright © 2015年 Lanou. All rights reserved.
//

#import "MusicListController.h"
#import "MusicCell.h"
#import "DataManager.h"
#import "PlayerManager.h"
#import "PlayingViewController.h"

@interface MusicListController ()


// 存放所有搜索结果
@property (nonatomic, retain) NSMutableArray *searchResult;
// 搜索框
@property (nonatomic, retain) UISearchController *searchController;


@end

static NSString * cellIdentifier = @"musicCell";
static NSString *customCell = @"customcell";

@implementation MusicListController
//代码规范,每一个模块之间要空一行
- (void)viewDidLoad {
    [super viewDidLoad];
    //注册自定义cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MusicCell" bundle:nil] forCellReuseIdentifier:customCell];
    
    
    [DataManager sharedManager].myUpdataUI = ^(){
        [self.tableView reloadData];
    };
    
//搜索框
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    // 设置搜索资源更新代理
//    _searchController.searchResultsUpdater = self;
     self.tableView.tableHeaderView = self.searchController.searchBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [DataManager sharedManager].allMusic.count;
    
    return self.searchController.active == YES ? self.searchResult.count :[DataManager sharedManager].allMusic.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //找到复用池中的自定义的cell
    MusicCell *cell = [tableView dequeueReusableCellWithIdentifier:customCell forIndexPath:indexPath];
//    cell.textLabel.text = @"音乐";
    
    MusicModel *model =  [[DataManager sharedManager] musicModelWithIndex:indexPath.row];
 
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
 
    if (self.searchController.active) {
        cell.lab4SongName.text = self.searchResult[indexPath.row];
    }else{
        cell.model = model;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
//cell 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    MusicCell *cell =  [tableView cellForRowAtIndexPath:indexPath];
//    NSLog(@"%@",cell.model);
//    
//    //播放音乐
//    [[PlayerManager sharedManager] playWithUrlString:cell.model.mp3Url];
    
    //拿到要模态出来的控制器
    PlayingViewController *playingVC = [PlayingViewController sharedPlayingPVC];
    playingVC.index = indexPath.row;
    [self showDetailViewController:playingVC sender:nil];
    
}

//// 遵循协议，必须走这个方法，通过这个方法，来更新内容
//- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
//    [self.searchResult removeAllObjects];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains[cd]%@", self.searchController.searchBar.text];
//    self.searchResult = [[DataManager sharedManager].allMusic filteredArrayUsingPredicate:predicate].mutableCopy;
//    [self.tableView reloadData];
//    
//    
//    
//    
//}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
