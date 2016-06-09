#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "OwnerModel.h"

@interface RepositoryModel : JSONModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *html_url;
@property (nonatomic, strong) OwnerModel *owner;

@end
