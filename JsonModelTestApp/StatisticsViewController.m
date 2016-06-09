#import "StatisticsViewController.h"
#import "IssueModel.h"
#import "JSONModel.h"
#import "JSONHTTPClient.h"

NSString *const kDateFormat = @"yyyy-MM-dd";
NSString *const kNoDateTextFieldContent = @"---";
NSString *const kEndpointSearch = @"https://api.github.com/search/issues";
//https://api.github.com/search/issues?q=language:swift+created:2015-07-17

@interface StatisticsViewController ()

@property (atomic, strong) __block  NSMutableArray *data;
@property (atomic, strong) __block  NSMutableArray *dataSource;
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UILabel *label3;
@property (nonatomic, strong) UITextField *activeTextField;
@property (nonatomic, strong) UIDatePicker *datePicker;
@end

@implementation StatisticsViewController{
    UITapGestureRecognizer *singleTapGestureRecognizer;
    UITapGestureRecognizer *singleTapGestureRecognizer2;
    UITapGestureRecognizer *singleTapGestureRecognizer3;
    UIToolbar *toolbar;
    NSMutableArray *textFields;
    NSMutableArray *tmpLanguages;
}

#pragma mark - view methods
- (void) viewDidLoad{
    [super viewDidLoad];
    //_languages = @[@"c", @"java", @"ruby"/*, @"python"*/];
    
    textFields = [[NSMutableArray alloc] initWithArray:@[_dateDay,_dateStart, _dateEnd]];
    
    tmpLanguages = [[NSMutableArray alloc]initWithArray:_languages];
    
    //************ DATA ************
    _data = [[NSMutableArray alloc]init];

    
    //************ DATE PICKER *****
    [self makeDataPicker];
    
    //************ TEXT FIELDS *****
    for(UITextField *field in textFields){
        field.delegate = self;
        field.text =kNoDateTextFieldContent;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,0,15.625,10)];
        [button setImage:[UIImage imageNamed:@"clear.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clearTextField:) forControlEvents:UIControlEventTouchUpInside];
        [field setRightView:button];
        [field setRightViewMode: UITextFieldViewModeUnlessEditing];
        field.clearButtonMode = UITextFieldViewModeWhileEditing;
        field.userInteractionEnabled = YES;
    }
    
    //************ GESTURES *****
    singleTapGestureRecognizer =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    singleTapGestureRecognizer2 =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture2:)];
    singleTapGestureRecognizer3 =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture3:)];
    [self.bar1 addGestureRecognizer:singleTapGestureRecognizer];
    [self.bar2 addGestureRecognizer:singleTapGestureRecognizer2];
    [self.bar3 addGestureRecognizer:singleTapGestureRecognizer3];
    
    NSDictionary *views = @{@"dayLabel" : _dayLabel, @"periodLabel" : _periodLabel, @"field1": _dateDay, @"field2": _dateStart, @"field3" : _dateEnd};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[field1(==field2)]" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[field2(==field3)]" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==16)-[field1(>=80)]-(==5)-[field2(>=80)]-(==5)-[field3(>=80)]-(==16)-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==16)-[dayLabel(>=80)]-(==5)-[periodLabel(>=80)]-|" options:0 metrics:nil views:views]];
    [self makeRequestFromDate:nil toDate:nil];
}

- (void) makeDataPicker{
    _datePicker = [[UIDatePicker alloc]init];
    _datePicker.backgroundColor = [UIColor whiteColor];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    NSDate *minDate = [self makeDateFromString:@"2011-01-01"];
    [_datePicker setMinimumDate:minDate];
    [_datePicker setMaximumDate:[NSDate date]];
    
    NSLog(@"minDate: %@, min: %@, max: %@",minDate,_datePicker.minimumDate,_datePicker.maximumDate);
}
-(void) makeRequestFromDate:(NSDate*)dateFrom toDate:(NSDate*)dateTo{
    _dataSource = [[NSMutableArray alloc]init];
    
    //TODO: synchronous requests in background
    for(__block NSString *languageName in _languages){
        NSString *queryURL = [[NSString alloc]init];
        if(dateFrom == nil){
        // to textfilde with date, query for all repos
            queryURL = [NSString stringWithFormat:@"%@?q=language:%@", kEndpointSearch,languageName]; //@"https: //api.github.com/search/issues?q=language:swift+created:2015-07-17";
        }else if(dateFrom !=nil && dateTo == nil){
        // only one date for one day given, query for repsitories created that day
            NSString* date = [self makeStringFromTheDate:dateFrom];
            queryURL = [NSString stringWithFormat:@"%@?q=language:%@+created:%@", kEndpointSearch,languageName, date];
        }
        else{
        // query for period
            NSString* date1= [self makeStringFromTheDate:dateFrom];
            NSString* date2 = [self makeStringFromTheDate:dateTo];
            queryURL = [NSString stringWithFormat:@"%@?q=language:%@+created:\"%@ .. %@\"", kEndpointSearch,languageName, date1, date2];
        }

        [JSONHTTPClient getJSONFromURLWithString: queryURL
                                      completion:^(id json, JSONModelError *err) {
                                          if([json valueForKey:@"total_count"]){
                                              
                                              __block NSNumber *reposCount = [json valueForKey:@"total_count"];
                                              NSLog(@"%@",[json valueForKey:@"total_count"]);
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  [self updateData:reposCount];
                                              });
                                          }
                                      }];
    }
}

-(void) makeRequestFromStringsDate:(NSString*)dateFrom toDate:(NSString*)dateTo{
    _dataSource = [[NSMutableArray alloc]init];
    //TODO: synchronous requests in background
    for(__block NSString *languageName in tmpLanguages){
        NSString *queryURL = [[NSString alloc]init];
        if(dateFrom == nil){
            // to textfilde with date, query for all repos
            queryURL = [NSString stringWithFormat:@"%@?q=language:%@", kEndpointSearch,languageName]; //@"https: //api.github.com/search/issues?q=language:swift+created:2015-07-17";
        }else if(dateFrom !=nil && dateTo == nil){
            // only one date for one day given, query for repsitories created that day
            queryURL = [NSString stringWithFormat:@"%@?q=language:%@+created:%@", kEndpointSearch,languageName, dateFrom];
        }
        else{
            // query for period
            NSString* queryBeforeEncoding = [NSString stringWithFormat:@"%@?q=language:%@+created:\"%@ .. %@\"", kEndpointSearch,languageName, dateFrom, dateTo];
            queryURL = [queryBeforeEncoding stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        
        [JSONHTTPClient getJSONFromURLWithString: queryURL
                                      completion:^(id json, JSONModelError *err) {
                                          if([json valueForKey:@"total_count"]){
                                              
                                              __block NSNumber *reposCount = [json valueForKey:@"total_count"];
                                              NSLog(@"%@",[json valueForKey:@"total_count"]);
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  [self updateData:reposCount];
                                              });
                                          }
                                      }];
    }
}

-(NSString* )makeStringFromTheDate: (NSDate* )date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kDateFormat];
    return [dateFormatter stringFromDate:date];
}

-(NSDate*) makeDateFromString: (NSString*)string{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kDateFormat];
    return [dateFormatter dateFromString:string];
}

- (void) viewDidAppear:(BOOL)animated{
    [self updateData];
}

#pragma mark - text field
- (void) clearTextField: (id)sender {
    UITextField *field = (UITextField*)[sender superview];
    field.text = kNoDateTextFieldContent;
//    if(sender ==_dateDay) {
//        [self enableAlltextfields];
//    }else if( sender == _dateStart || sender == _dateEnd){
//        _dateDay.enabled = NO;
//    }
    [self enableAlltextfields];
}

- (void)enableAlltextfields{
    _dateDay.enabled = YES;
    _dateStart.enabled = YES;
    _dateEnd.enabled = YES;
}

- (void) manageTextFields: (UITextField*) textField{
    if(textField == _dateDay){
        _dateDay.enabled = YES;
        _dateStart.enabled = NO;
        _dateEnd.enabled = NO;
        _dateStart.text = kNoDateTextFieldContent;
        _dateEnd.text = kNoDateTextFieldContent;
        return;
    }else if(textField == _dateStart || textField == _dateEnd){
        _dateDay.enabled = NO;
        _dateStart.enabled = YES;
        _dateEnd.enabled = YES;
        _dateDay.text = kNoDateTextFieldContent;
        return;
    }
    return;
}

- (void) showAlertIncorretPeriod {
#ifdef __IPHONE_8_0
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Please correct the date" message:@"The date of the enf of the period must be later teh the date of the beginning. "
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okayAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self manageTextFields:_dateStart];
            [self manageTextFields:_dateEnd];
        });
        
    }];
    [alert addAction:okayAction];
    [self presentViewController:alert animated:YES completion:nil];
#endif
}

- (void) showAlertEarlierDateNeeded{
#ifdef __IPHONE_8_0
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Please correct the date" message:@"Enter the date from the past."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okayAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self enableAlltextfields];
        });
        
    }];
    [alert addAction:okayAction];
    [self presentViewController:alert animated:YES completion:nil];
#endif
}


#pragma mark - data

- (void)updateData{
    [_data addObjectsFromArray:@[@1100, @200, @1300]];
    [self prepareDataToDisplayTestMethod];
}

- (void)updateData: (NSNumber*)reposCount{
    [_dataSource addObject:reposCount];
    if([_dataSource count] == 3){
        [self prepareDataToDisplay];
        [self animate];
    }
}

-(void) addLabels{
    _label1 = [[UILabel alloc] init];
    _label2 = [[UILabel alloc] init];
    _label3 = [[UILabel alloc] init];
    NSArray *labelArray = @[_label1, _label2, _label3];
    NSInteger counter = 0;
    for(UILabel *lb in labelArray){
        lb.translatesAutoresizingMaskIntoConstraints = NO;
        lb.textColor = [UIColor grayColor];
        [lb setFont:[lb.font fontWithSize:12]];
        lb.numberOfLines = 0;  // Mandatory to allow multiline behaviour
        lb.textAlignment = NSTextAlignmentCenter;
        [lb sizeToFit]; //adjust height, width is in constraints
        lb.text = [tmpLanguages objectAtIndex:counter];
        [self.view addSubview:lb];
        [lb setAlpha:0.0];
        ++counter;
    }
    
    NSDictionary *margins = @{@"leftMargin" : [NSNumber numberWithFloat:_bar1margin.constant]};
    
    NSDictionary *labelsDict = @{@"label1":_label1, @"label2":_label2, @"label3":_label3};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==100@1000)-[label1(==41@1000)]-(==31@999)-[label2]-(==31@999)-[label3]"
                                                                      options:0  metrics:margins views:labelsDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[label2(==41@1000)]" options:0 metrics:margins views:@{@"label2":_label2}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[label3(==41@1000)]" options:0 metrics:margins views:@{@"label3":_label3}]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[label1]-(==10)-[bar1]" options:0 metrics:margins views:@{@"label1":_label1, @"bar1":_bar1}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[label2]-(==10)-[bar2]" options:0 metrics:margins views:@{@"label2":_label2, @"bar2":_bar2}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[label3]-(==10)-[bar3]" options:0 metrics:margins views:@{@"label3":_label3, @"bar3":_bar3}]];
}

-(void) prepareDataToDisplay{
    NSMutableArray *tmpArray = [[NSMutableArray alloc]init];
    NSInteger maxValue = [[_dataSource valueForKeyPath:@"@max.intValue"]integerValue];
    for(NSNumber *nr in _dataSource){
        NSInteger actualHeight = [nr integerValue];
        NSInteger maxExpectValue = 350.0;
        NSInteger expectedHeight;
        if(maxValue != 0){
            expectedHeight = (actualHeight *maxExpectValue)/ maxValue;
        }else{
            expectedHeight = 0;
        }
        [tmpArray addObject:[NSNumber numberWithInteger: expectedHeight]];
    }
    _dataSource = nil;
    _dataSource = [[NSMutableArray alloc]initWithArray:tmpArray];
}


-(void) prepareDataToDisplayTestMethod{
    NSMutableArray *tmpArray = [[NSMutableArray alloc]init];
    NSInteger maxValue = [[_data valueForKeyPath:@"@max.intValue"]integerValue];
    for(NSNumber *nr in _data){
        NSInteger actualHeight = [nr integerValue];
        NSInteger maxExpectValue = 350.0;
        NSInteger expectedHeight = (actualHeight *maxExpectValue)/ maxValue;
        [tmpArray addObject:[NSNumber numberWithInteger: expectedHeight]];
    }
    _data = nil;
    _data = [[NSMutableArray alloc]initWithArray:tmpArray];
}

#pragma mark - aniamtion & gestures

- (void)animate{
    [self addLabels];
    [self.view layoutIfNeeded]; // complete pending layout operations (optional)
//    _bar1Height.constant = [(NSNumber*)[_data objectAtIndex:0] floatValue];
//    _bar2Height.constant = [(NSNumber*)[_data objectAtIndex:1] floatValue];
//    _bar3Height.constant = [(NSNumber*)[_data objectAtIndex:2] floatValue];
    _bar1Height.constant = [(NSNumber*)[_dataSource objectAtIndex:0] floatValue];
    _bar2Height.constant= [(NSNumber*)[_dataSource objectAtIndex:1] floatValue];
    _bar3Height.constant = [(NSNumber*)[_dataSource objectAtIndex:2] floatValue];
    

    [UIView animateWithDuration:1.0 animations:^{
        [self.view layoutIfNeeded];
        [_label1 setAlpha:1.0];
        [_label2 setAlpha:1.0];
        [_label3 setAlpha:1.0];
    }];
}

-(void)handleSingleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer{
    NSLog(@"tapped 1");
    [self.view layoutIfNeeded];
    _bar1Height.constant += 10;
    [UIView animateWithDuration:1.0  animations:^{
        [self.view layoutIfNeeded];
    }];
    
}

-(void)handleSingleTapGesture2:(UITapGestureRecognizer *)tapGestureRecognizer{
    NSLog(@"tapped 2");
    [self.view layoutIfNeeded];
    _bar2Height.constant += 10;
    [UIView animateWithDuration:1.0  animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(void)handleSingleTapGesture3:(UITapGestureRecognizer *)tapGestureRecognizer{
    NSLog(@"tapped 3");
    [self.view layoutIfNeeded];
    _bar3Height.constant += 10;
    [UIView animateWithDuration:1.0  animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - data picker
- (void) showView {
    [self makeToolbar];
    [self.view addSubview:_datePicker];
    toolbar.translatesAutoresizingMaskIntoConstraints = NO;
    _datePicker.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==0@1000)-[datePicker(>=260@250)]-(==0@1000)-|" options:0 metrics:nil views:@{@"datePicker" : _datePicker}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==0@1000)-[toolbar(>=260@250)]-(==0@1000)-|" options:0 metrics:nil views:@{@"toolbar" : toolbar}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=10@250)-[toolbar(==30)]-(==0)-[datePicker(>=260@250)]-(==0@1000)-|" options:0 metrics:nil views:@{@"toolbar" : toolbar, @"datePicker" : _datePicker}]];
    
    //    datePicker.frame = CGRectMake(0, 700, 320, 50);
    //    [UIView animateWithDuration:1.0
    //                     animations:^{
    //                         datePicker.frame = CGRectMake(0, 200, 320, 260);
    //                     }];
}

- (void) makeToolbar{
    toolbar = [[UIToolbar alloc]init] ;//]initWithFrame:CGRectMake(0, 428, 320, 32)];
    toolbar.backgroundColor = [UIColor lightGrayColor];
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil] ;
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                               target:self
                                                                               action:@selector(hideView)];
    toolbar.delegate =self;
    NSArray* barItems = [NSArray arrayWithObjects: flex, doneButton, nil];
    [toolbar setItems:barItems animated:YES];
    [self.view addSubview:toolbar];
}

-(void) setDataInTextfield: (UITextField*) textField{
    NSString *formatedDate = [self makeStringFromTheDate:_datePicker.date];
    textField.text = formatedDate;
    [self manageTextFields:textField];
}

- (void) hideView {
    [UIView animateWithDuration:0.0
                     animations:^{
                         //datePicker.frame = CGRectMake(0, 700, 320, 50);
                     } completion:^(BOOL finished) {
                         //[datePicker removeFromSuperview];
                     }];
    [_datePicker removeFromSuperview];
    [toolbar removeFromSuperview];
    if([self checkDateCorrectness:_activeTextField]){
        [self setDataInTextfield:_activeTextField];
        [self refreshChart];
    }
}

- (BOOL) checkDateCorrectness: (UITextField*) field{
    /******* DATE FROM THE PAST *******/
    NSDate *nowDate = [NSDate date];
    NSDate *insertedDate = _datePicker.date;
    if([self checkOrderOfDate:nowDate andDate:insertedDate] == NSOrderedAscending){
        [self showAlertEarlierDateNeeded];
        field.text = kNoDateTextFieldContent;
        return NO;
    }
    
    /******* DATE ORDER *******/
    if(field == _dateEnd && ![_dateStart.text isEqualToString:kNoDateTextFieldContent]){
        NSComparisonResult result = [self checkOrderOfDate:[self makeDateFromString:_dateStart.text]
                                                   andDate:_datePicker.date];
        if(result == NSOrderedDescending){
            [self showAlertIncorretPeriod];
            return NO;
        }
    }else if(field == _dateStart && ![_dateEnd.text isEqualToString:kNoDateTextFieldContent]){
        NSComparisonResult result = [self checkOrderOfDate:_datePicker.date
                                                   andDate:[self makeDateFromString: _dateEnd.text]];
        if(result == NSOrderedDescending){
            [self showAlertIncorretPeriod];
            return NO;
        }
    }
    return YES;
}

- (NSComparisonResult)checkOrderOfDate:(NSDate*)date1 andDate: (NSDate*)date2{
    NSDate *dateTheFirst = date1;
    NSDate *dateTheSecond = date2;
    NSComparisonResult result = [dateTheFirst compare: dateTheSecond];
    return result;
}

- (IBAction)refreshChart:(id)sender {
    if(![_dateDay.text isEqualToString: kNoDateTextFieldContent]){
        [self makeRequestFromStringsDate:_dateDay.text toDate:nil];
    }
    else if(![_dateStart.text isEqualToString: kNoDateTextFieldContent] && ![_dateEnd.text isEqualToString: kNoDateTextFieldContent]){
        [self makeRequestFromStringsDate:_dateStart.text toDate:_dateEnd.text];
    }
}

- (void)refreshChart{
    if(![_dateDay.text isEqualToString: kNoDateTextFieldContent]){
        [self makeRequestFromStringsDate:_dateDay.text toDate:nil];
    }
    else if(![_dateStart.text isEqualToString: kNoDateTextFieldContent] && ![_dateEnd.text isEqualToString: kNoDateTextFieldContent]){
        [self makeRequestFromStringsDate:_dateStart.text toDate:_dateEnd.text];
    }
}

#pragma mark - text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    for(UITextField *field in textFields){
        field.enabled = NO;
    }
    _activeTextField = textField;
    [self showView];
    return NO; // preventing keyboard from showing
}

@end
