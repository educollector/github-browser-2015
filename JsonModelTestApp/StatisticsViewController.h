#import <UIKit/UIKit.h>


@interface StatisticsViewController : UIViewController <UITextFieldDelegate, UIToolbarDelegate, UIAlertViewDelegate>

@property __block NSArray *languages;

@property (weak, nonatomic) IBOutlet UIView *bar1;
@property (weak, nonatomic) IBOutlet UIView *bar2;
@property (weak, nonatomic) IBOutlet UIView *bar3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bar1Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bar2Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bar3Height;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bar1margin;

@property (weak, nonatomic) IBOutlet UITextField *dateDay;
@property (weak, nonatomic) IBOutlet UITextField *dateStart;
@property (weak, nonatomic) IBOutlet UITextField *dateEnd;

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *periodLabel;

@end
