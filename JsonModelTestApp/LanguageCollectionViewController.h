
#import <UIKit/UIKit.h>

@interface LanguageCollectionViewController : UICollectionViewController

@property (nonatomic, strong) NSArray *languages;
-(id)initWithLanguages:(NSArray*)languages;

@end
