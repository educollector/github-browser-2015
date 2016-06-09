
#import "LanguageCollectionViewCell.h"
#import "LanguageCollectionView.h"

@implementation LanguageCollectionView

- (NSInteger)numberOfSections{
    return 1;
}
- (NSInteger)numberOfItemsInSection:(NSInteger)section{
    return _languages.count;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(id)initWithLanguages:(NSArray*)languages{
    self = [super init];
    if(self){
        _languages = languages;
        
    }
    return self;
}

@end
