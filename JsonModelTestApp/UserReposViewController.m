#import "UserReposViewController.h"
#import "UserHeaderTableViewCell.h"
#import "DetailViewController.h"
#import "JSONHTTPClient.h"
#import "RepositoryModel.h"
#import "UIViewController+AS.h"
#import "AFNetworking.h"

@interface UserReposViewController ()
@property (strong) NSArray *dataArray;
@property (strong) __block RepositoryModel *repo;
@property __block NSUInteger followersCount;
@property __block NSUInteger followingsCount;
@property __block UIImage *userImage;
@end

@implementation UserReposViewController{
    NSMutableArray *tmpArray;
}

@synthesize queryURL = _queryURL;

- (void)viewDidLoad {
    
    tmpArray = [[NSMutableArray alloc]init];
    [tmpArray addObjectsFromArray:@[@"name1",@"name2",@"name3",@"name4",@"name5"]];
    
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    NSString *queryURL = _queryURL;
    [self styleNavbar];
    [self requestFollowinfFollowersAndAvatar];
    
    //REPOSITORIES
    queryURL = _queryURL;
    [JSONHTTPClient getJSONFromURLWithString: queryURL
                                  completion:^(id json, JSONModelError *err) {
                                      __block NSArray *data = [RepositoryModel arrayOfModelsFromDictionaries:json error:nil];
                                      [self requestFollowinfFollowersAndAvatar];
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [self updateData:data];
                                      });
                                  }];
}

- (void) requestFollowinfFollowersAndAvatar{
    //FOLLOWERS
    NSString *queryURL = _owner.followers_url;
    [JSONHTTPClient getJSONFromURLWithString: queryURL
                                  completion:^(id json, JSONModelError *err) {
                                      __block NSArray *data = [OwnerModel arrayOfModelsFromDictionaries:json error:nil];
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [self updateFollowers:data];
                                      });
                                  }];
    //FOLLOWING
    queryURL = [_owner.following_url stringByReplacingOccurrencesOfString:@"{/other_user}" withString:@""];
    [JSONHTTPClient getJSONFromURLWithString: queryURL
                                  completion:^(id json, JSONModelError *err) {
                                      __block NSArray *data = [OwnerModel arrayOfModelsFromDictionaries:json error:nil];
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [self updateFollowing:data];
                                      });
                                  }];
    //AVATAR
    //queryURL = @"https://avatars.githubusercontent.com/u/1?v=3";
    //NSURL *url = [NSURL URLWithString:@"https://avatars.githubusercontent.com/u/1?v=3"];
    NSURL *url = [NSURL URLWithString:@"http://i.imgur.com/7spzG.png"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"image/png"]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _userImage = [UIImage imageWithData:operation.responseData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving User Image"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        NSLog(@"%@", [error localizedDescription]);
    }];
    [operation start];
}

- (void) makeHeader {
    [self.tableView reloadData];
}

- (void) updateData:(NSArray*)data {
    _dataArray = data;
    if(_dataArray && [_dataArray count]>0){
        _owner = [[data objectAtIndex:0] owner];
        [self.tableView reloadData];
    }
}

- (void) updateFollowers:(NSArray*)data {
    _followersCount = [data count];
    [self.tableView reloadData];
}
- (void) updateFollowing:(NSArray*)data{
    _followingsCount = [data count];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataArray count];//[tmpArray count];//
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"UserRepoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    if(_dataArray && [_dataArray count]>0){
        RepositoryModel *repo = (RepositoryModel*)[_dataArray objectAtIndex:[indexPath row]];
        cell.textLabel.text = repo.name;
        cell.detailTextLabel.text = _owner.login;
    }
    return cell;
}

#pragma mark - Table view data source - header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        UserHeaderTableViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
        headerCell.loginLabel.text = _owner.login;
        headerCell.nameSurnameLabel.text = @"Name:";
        headerCell.loginLabel.text =[NSString stringWithFormat: @"login:%@", _owner.login];
        headerCell.followersLabel.text = [NSString stringWithFormat:@"followers: %ld",_followersCount];
        headerCell.followingLabel.text = [NSString stringWithFormat:@"folowing: %ld",_followingsCount];
        headerCell.userImage.image = _userImage;
        
        headerCell.userImage.layer.cornerRadius = headerCell.userImage.frame.size.width/2;
        headerCell.userImage.layer.borderWidth = 2.0f;
        headerCell.userImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
        headerCell.userImage.clipsToBounds = YES;
        
        return headerCell;
        //return [UserHeaderTableViewCell configureCell: headerCell];
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100.0;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showDetailsSegueFromUserScreen"]){
        DetailViewController *childViewController = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if(_dataArray && [_dataArray count]>0){
            NSString *string = [[_dataArray objectAtIndex:[indexPath row]] html_url];
            childViewController.urlString = string;
        }
        
    }
}

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


@end
