//
//  StaticBrowserViewController.h
//  iOS-StarterKit
//
//  Created by Rakesh B on 02/10/14.
//  Copyright (c) 2014 Elevati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface StaticBrowserViewController : GAITrackedViewController<UIWebViewDelegate>

@property(nonatomic,strong) IBOutlet UIWebView *legalWebView;
@property(nonatomic,strong) NSString *htmlFilePath;
@property(nonatomic,strong) NSString *strTitle;

@end
