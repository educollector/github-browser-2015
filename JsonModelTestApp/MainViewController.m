#import "MainViewController.h"
#import "MainTableViewController.h"
#import "UserReposViewController.h"
#import "LanguageCollectionViewCell.h"
#import "StatisticsViewController.h"
#import "UIViewController+AS.h"
#import "AFNetworking.h"
#import "UIColor+Rgb.h"

NSString *const kEndpoit = @"https://api.github.com/";
NSString *const kGreenColor = @"56B942";
NSString *const kGrayColor = @"F2F2F5";

@interface MainViewController ()
- (void)didRecognizeTapGesture:(UITapGestureRecognizer*)gesture;
@end

@implementation MainViewController{
    NSArray *languages;
    NSMutableArray *selectedIems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(didRecognizeTapGesture:)];
    self.userLoginTextField.delegate = self;
    [_userLoginTextField addGestureRecognizer:tapGesture];
    [_userLoginTextField setUserInteractionEnabled:YES];
    _showUserReposButton.enabled = YES;
    
    [self styleNavbar];
    _separator.backgroundColor = [UIColor colorWithHexString:kGreenColor];
    _raceButton.titleLabel.textColor =  [UIColor colorWithHexString:kGreenColor];
    [self makeConstraints];
    
    languages = @[@"C", @"Objective-c", @"Java", @"Ruby", @"Python",@"Swift", @"JavaScript", @"PHP", @"Groovy", @"Scala", @"Perl", @"Shell"];
    selectedIems = [[NSMutableArray alloc] init];
    _collectionVIew.languages = languages;
    _collectionVIew.dataSource = self;
    _collectionVIew.delegate = self;
    _collectionVIew.backgroundColor = [UIColor whiteColor];
    _collectionVIew.allowsMultipleSelection = YES;
    _userLoginTextField.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:kGreenColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)viewDidDisappear:(BOOL)animated{
    [selectedIems removeAllObjects];
    [_collectionVIew reloadData];}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) makeConstraints{
    _raceButton.translatesAutoresizingMaskIntoConstraints = NO;
    //[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==0)-[raceButton(>=10@250)]-(==0)-|" options:0 metrics:nil views:@{@"raceButton" : _raceButton}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[collection]-(5)-[raceButton(==70)]" options:0 metrics:nil views:@{@"collection" : _collectionVIew, @"raceButton" : _raceButton}]];
}

- (void)didRecognizeTapGesture:(UITapGestureRecognizer*)gesture{
    CGPoint point = [gesture locationInView:gesture.view];
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (CGRectContainsPoint(_userLoginTextField.frame, point)) {
            _showUserReposButton.enabled = YES;
        }
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _showUserReposButton.enabled = YES;
    
    return YES;
}

- (IBAction)showPublicReposButtonTapped:(id)sender {
}

- (IBAction)showUserReposButtonTapped:(id)sender {
}

#pragma mark - CollectionView data source and delegate methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:
(NSInteger)section {
    return [languages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LanguageCollectionViewCell *cell = (LanguageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"LanguageCell" forIndexPath:indexPath];
    cell.languageLabel.text = (NSString*)[languages objectAtIndex:[indexPath row]];
    cell.contentView.backgroundColor = [UIColor colorWithHexString:kGrayColor];
    cell.languageLabel.textColor = [UIColor blackColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"cell selected");
    if([selectedIems count] <3){
        LanguageCollectionViewCell *cell = (LanguageCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor colorWithHexString:kGreenColor];
        cell.languageLabel.textColor = [UIColor whiteColor];
        [selectedIems addObject: (NSString*)[languages objectAtIndex:indexPath.item]];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"cell deselected");
    LanguageCollectionViewCell *cell = (LanguageCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithHexString:kGrayColor];
    cell.languageLabel.textColor = [UIColor blackColor];
    [selectedIems removeObject: (NSString*)[languages objectAtIndex:indexPath.item]];
}

#pragma mark - text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    //if (theTextField == self.playerNameField) {
    [theTextField resignFirstResponder];
    //}
    return YES;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showPublicReposSegue"]){
        MainTableViewController *listViewController = [segue destinationViewController];
        listViewController.queryURL = [NSString stringWithFormat:@"%@repositories",kEndpoit];
        listViewController.title = @"Public repos list";
        listViewController.fetchingTarget = @"allPublicRepos";
    }
    else if([segue.identifier isEqualToString:@"showUsersSegue"]){
        UserReposViewController *listViewController = [segue destinationViewController];
        listViewController.queryURL = [NSString stringWithFormat:@"%@users/%@/repos",kEndpoit, _userLoginTextField.text];
        listViewController.title = [NSString stringWithFormat:@"%@'s repos", _userLoginTextField.text];
        listViewController.fetchingTarget = @"userRepos";
    }
    else if([segue.identifier isEqualToString:@"statisticsSegue"]){
        StatisticsViewController *statisticsViewController = [segue destinationViewController];
        statisticsViewController.languages = selectedIems;
    }
}

@end
