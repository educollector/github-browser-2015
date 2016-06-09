#import <UIKit/UIKit.h>

@interface UserHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameSurnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;

- (void)configureCell;
+ (UserHeaderTableViewCell*)configureCell: (UserHeaderTableViewCell*) cell;
@end
