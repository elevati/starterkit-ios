//
//  AdCell.h
//  AdoptionDaily
//
//  Created by Rakesh B on 30/07/14.
//  Copyright (c) 2014 Elevati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFPBannerView.h"
#import "GADAdSizeDelegate.h"
#import "GADAppEventDelegate.h"
#import "GADBannerViewDelegate.h"

@protocol AdCellDelegate <NSObject>
@optional

- (void)reloadArticleListing:(NSInteger)rowIndex;

@end

@interface AdCell : UITableViewCell<GADBannerViewDelegate, GADAdSizeDelegate, GADAppEventDelegate>

@property (weak, nonatomic) IBOutlet UIView *bannerContainerView;
@property (nonatomic,strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic,strong) DFPBannerView *dfpBannerView;
@property (nonatomic,assign) BOOL isAdLoaded;
@property (nonatomic,assign) BOOL isFromDetailScreen;

@property (nonatomic, weak) id<AdCellDelegate> delegate;

@property (weak, nonatomic) UIViewController *sender;
@property (nonatomic,assign) GADAdSize adSize;
@property (nonatomic,strong) NSString *strAdUnitID;

@property (nonatomic,assign) NSInteger rowIndex;

-(void)loadDFPGoogleAds;
@end
