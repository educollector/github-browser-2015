#import "DetailViewController.h"

@implementation DetailViewController

- (void) viewDidLoad{
    [super viewDidLoad];
    _webView.delegate = self;
    [self makeConstraints];
    if(_urlString){
        NSURL *url = [NSURL URLWithString:_urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
    }
    
}

- (void) makeConstraints{
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==5)-[webView(>=320)]-(>=5)-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"webView" : _webView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==0)-[webView(>=560)]-(==0)-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"webView" : _webView}]];
}

@end
