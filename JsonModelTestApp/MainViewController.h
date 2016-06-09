#import <UIKit/UIKit.h>
#import "LanguageCollectionView.h"

@interface MainViewController : UIViewController <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *showPublicReposButton;
@property (weak, nonatomic) IBOutlet UITextField *userLoginTextField;
@property (weak, nonatomic) IBOutlet UIButton *showUserReposButton;
@property (weak, nonatomic) IBOutlet UIButton *raceButton;
@property (weak, nonatomic) IBOutlet LanguageCollectionView *collectionVIew;
@property (weak, nonatomic) IBOutlet UIView *separator;

- (IBAction)showPublicReposButtonTapped:(id)sender;
- (IBAction)showUserReposButtonTapped:(id)sender;

@end
