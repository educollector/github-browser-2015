
#import <UIKit/UIKit.h>

@interface LanguageCollectionView : UICollectionView
@property (nonatomic, strong) NSArray *languages;
-(id)initWithLanguages:(NSArray*)languages;

@end
