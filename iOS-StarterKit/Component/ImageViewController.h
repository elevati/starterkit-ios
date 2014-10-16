//
//  ImageViewController.h
//  iOS-StarterKit
//
//  Created by Rakesh B on 02/06/14.
//  Copyright (c) 2014 Elevati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"

@interface ImageViewController : UIViewController

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, assign) BOOL isLoadingImage;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;

- (id)initWithImage:(UIImage *)image;
- (id)initWithURL:(NSURL *)url;
- (id)initWithImage:(UIImage *)image andURL:(NSURL *)url;
- (void)loadImage;
- (void)hideBars:(BOOL)hide animated:(BOOL)animated;
- (void)centerImage;

@end
