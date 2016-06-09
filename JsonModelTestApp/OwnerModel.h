#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface OwnerModel : JSONModel

@property (nonatomic, strong) NSString *login;
@property (nonatomic, strong) NSString *avatar_url;
@property (nonatomic, strong) NSString *url;        //api url: https://api.github.com/users/mojombo
@property (nonatomic, strong) NSString *html_url;   //link to profile: https://github.com/mojombo
@property (nonatomic, strong) NSString *followers_url;
@property (nonatomic, strong) NSString *following_url;
@property (nonatomic, strong) NSString *repos_url;  //repos url: https://api.github.com/users/mojombo/repos

@end
