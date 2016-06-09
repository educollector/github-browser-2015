

#import "LanguageCollectionViewController.h"
#import "LanguageCollectionViewCell.h"

@implementation LanguageCollectionViewController


-(id)initWithLanguages:(NSArray*)languages{
    self = [super init];
    if(self){
        _languages = languages;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:
(NSInteger)section {
    return [_languages count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LanguageCollectionViewCell *cell = (LanguageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"LanguageCell" forIndexPath:indexPath];
    // Configure the cell
    cell.languageLabel.text = @"yolo";
    return cell;
}

@end
