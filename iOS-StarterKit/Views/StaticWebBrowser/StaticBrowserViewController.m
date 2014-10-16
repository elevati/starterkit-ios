//
//  LegalViewController.m
//  iOS-StarterKit
//
//  Created by Rakesh B on 02/10/14.
//  Copyright (c) 2014 Elevati. All rights reserved.
//

#import "StaticBrowserViewController.h"

@implementation StaticBrowserViewController
@synthesize htmlFilePath = htmlFilePath;
@synthesize strTitle = strTitle;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = strTitle;
    self.legalWebView.delegate = self;
    
    NSError *error;
    NSString *content = [NSString stringWithContentsOfFile:htmlFilePath encoding:NSUTF8StringEncoding error:&error];
    [self.legalWebView loadHTMLString:content baseURL:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Registering the screen name for google analytics
    self.screenName = [NSString stringWithFormat:@"%@ Screen",strTitle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // Disable user selection
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    // Disable callout
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}
@end
