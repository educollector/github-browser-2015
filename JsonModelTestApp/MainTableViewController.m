#import "MainTableViewController.h"
#import "DetailViewController.h"
#import "AFNetworking.h"
#import "JSONHTTPClient.h"
#import "RepositoryModel.h"
#import "OwnerModel.h"


@interface MainTableViewController ()
@property (strong) NSArray *dataArray;
@property (strong) __block RepositoryModel *repo;
@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    NSString *queryURL = _queryURL; //@"https://api.github.com/repositories";
    
    //fetch the feed
    [JSONHTTPClient getJSONFromURLWithString: queryURL
                          completion:^(id json, JSONModelError *err) {
                              __block NSArray *data = [RepositoryModel arrayOfModelsFromDictionaries:json error:nil];
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self updateData:data];
                              });
                          }];
    if(![self.fetchingTarget isEqualToString:@"userRepos"]){
        self.navigationItem.rightBarButtonItem = nil;
    }
        
    
    //fetchnig data about one repo
    [JSONHTTPClient getJSONFromURLWithString: @"https://api.github.com/repos/octokit/octokit.rb" //link to one repo
                          completion:^(id json, JSONModelError *err) {
                              NSError *error;
                              NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json
                                                                                 options:NSJSONWritingPrettyPrinted
                                                                                   error:&error];
                              NSString* aStr;
                              aStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                              _repo = [[RepositoryModel alloc]initWithString:aStr error:nil];
                              
                          }];
}

- (void) updateData:(NSArray*)data {
    _dataArray = data;
    if(_dataArray && [_dataArray count]>0){
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    if((_dataArray && [_dataArray count]>0)){
        RepositoryModel *repo = (RepositoryModel*)[_dataArray objectAtIndex:[indexPath row]];
        cell.textLabel.text = repo.name;
        cell.detailTextLabel.text = repo.owner.login;
    }

    
    return cell;
}

#pragma mark - Navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if([segue.identifier isEqualToString:@"showDetailsSegue"]){
         DetailViewController *childViewController = [segue destinationViewController];
         NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
         if((_dataArray && [_dataArray count]>0)){
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
