#import "UserHeaderTableViewCell.h"

@implementation UserHeaderTableViewCell

-(void)configureCell {
    if(_userImage !=nil){
        _userImage.layer.cornerRadius = self.userImage.frame.size.width/2;
        _userImage.layer.borderWidth = 2.0f;
        _userImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _userImage.clipsToBounds = YES;
        
                _loginLabel.textAlignment = NSTextAlignmentRight;
                _nameSurnameLabel.textAlignment = NSTextAlignmentRight;
                _followersLabel.textAlignment = NSTextAlignmentLeft;
                _followingLabel.textAlignment = NSTextAlignmentLeft;
        
                _userImage.translatesAutoresizingMaskIntoConstraints = NO;
                //_bgView.translatesAutoresizingMaskIntoConstraints = NO;
                _loginLabel.translatesAutoresizingMaskIntoConstraints = NO;
                _nameSurnameLabel.translatesAutoresizingMaskIntoConstraints = NO;
                _followersLabel.translatesAutoresizingMaskIntoConstraints = NO;
                _followingLabel.translatesAutoresizingMaskIntoConstraints = NO;
                self.translatesAutoresizingMaskIntoConstraints = NO;
        
                UIView *parentView = [self superview];
                NSDictionary *views = @{@"cell": self,
                                        /*@"colorView": _bgView,*/
                                        @"userImage": _userImage,
                                        @"following" : _followingLabel,
                                        @"followers" : _followersLabel,
                                        @"name" : _nameSurnameLabel,
                                        @"login" : _loginLabel};
        //        [parentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[colorView(==cell)]"
        //                                                                           options:0 metrics:nil
        //                                                                             views:@{@"cell":self, @"colorView":_bgView}]];
//        
//                [parentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==5)-[login(>=100@250)]-(==4)-[userImage(==80)]-(==4)-[followers(==login)]-(==5)-|"
//                                                                                   options:0 metrics:nil
//                                                                                     views:views]];
//                [parentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==5)-[name(>=100@250)]-(==15)-[userImage]-(==15)-[following(==name)]-(==5)-|"
//                                                                                   options:0 metrics:nil
//                                                                                     views:views]];
            }
            [super updateConstraints];
}

+ (UserHeaderTableViewCell*)configureCell: (UserHeaderTableViewCell*) cell {
    if(cell.userImage !=nil){
        cell.userImage.layer.cornerRadius = cell.userImage.frame.size.width/2;
        cell.userImage.layer.borderWidth = 2.0f;
        cell.userImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.userImage.clipsToBounds = YES;
        
        cell.loginLabel.textAlignment = NSTextAlignmentRight;
        cell.nameSurnameLabel.textAlignment = NSTextAlignmentRight;
        cell.followersLabel.textAlignment = NSTextAlignmentLeft;
        cell.followingLabel.textAlignment = NSTextAlignmentLeft;
        
        cell.userImage.translatesAutoresizingMaskIntoConstraints = NO;
        //_bgView.translatesAutoresizingMaskIntoConstraints = NO;
        cell.loginLabel.translatesAutoresizingMaskIntoConstraints = NO;
        cell.nameSurnameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        cell.followersLabel.translatesAutoresizingMaskIntoConstraints = NO;
        cell.followingLabel.translatesAutoresizingMaskIntoConstraints = NO;
        cell.translatesAutoresizingMaskIntoConstraints = NO;
        
        UIView *parentView = [cell superview];
        NSDictionary *views = @{@"cell": self,
                                /*@"colorView": _bgView,*/
                                @"userImage": cell.userImage,
                                @"following" : cell.followingLabel,
                                @"followers" : cell.followersLabel,
                                @"name" : cell.nameSurnameLabel,
                                @"login" : cell.loginLabel};
        //        [parentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[colorView(==cell)]"
        //                                                                           options:0 metrics:nil
        //                                                                             views:@{@"cell":self, @"colorView":_bgView}]];
        //
        //                [parentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==5)-[login(>=100@250)]-(==4)-[userImage(==80)]-(==4)-[followers(==login)]-(==5)-|"
        //                                                                                   options:0 metrics:nil
        //                                                                                     views:views]];
        //                [parentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==5)-[name(>=100@250)]-(==15)-[userImage]-(==15)-[following(==name)]-(==5)-|"
        //                                                                                   options:0 metrics:nil
        //                                                                                     views:views]];
    }
    //[[cell subviews] updateConstraints];
    return cell;
}
@end
