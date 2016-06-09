#import <UIKit/UIKit.h>
#import "MainTableViewController.h"
#import "OwnerModel.h"
#import "UserHeaderTableViewCell.h"

@interface UserReposViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSString *queryURL;
@property (nonatomic, strong) __block OwnerModel *owner;
@property (nonatomic, strong) NSString *fetchingTarget;
@end
