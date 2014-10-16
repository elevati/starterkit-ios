//
//  AdCell.m
//  AdoptionDaily
//
//  Created by Rakesh B on 30/07/14.
//  Copyright (c) 2014 Elevati. All rights reserved.
//

#import "AdCell.h"
#import "AppDelegate.h"

@implementation AdCell

@synthesize dfpBannerView = dfpBannerView;
@synthesize activityIndicator = activityIndicator;
@synthesize sender = sender;
@synthesize isAdLoaded = isAdLoaded;
@synthesize bannerContainerView = bannerContainerView;
@synthesize adSize = adSize;
@synthesize strAdUnitID = strAdUnitID;
@synthesize rowIndex = rowIndex;
@synthesize isFromDetailScreen = isFromDetailScreen;

AppDelegate *appDelegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


/*We need to make size is configurable, currently it will display 320*250 size ad */
-(void)loadDFPGoogleAds
{
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
 
   NSString *strUniqueID = [NSString stringWithFormat:@"%@_%ld",strAdUnitID,(long)rowIndex];
   
    /*
     I have added below check(if(!isFromDetailScreen)) because on details screen advertisement, after tapping on ad I was getting warning as
      Warning: Attempt to present <GADBrowserController: 0x158a73b0> on <ArticleDetailViewController: 0x12727d90> whose view is not in the window hierarchy!
     due to which ads detail view were not presented
     */
    if(!isFromDetailScreen)
        dfpBannerView = [appDelegate.dicAdvertisement objectForKey:strUniqueID];
    
    if(dfpBannerView == nil)
    {
        // Create a view of the standard size at the top of the screen.
        // Available AdSize constants are explained in GADAdSize.h.
        dfpBannerView = [[DFPBannerView alloc] initWithAdSize:adSize];
        dfpBannerView.tag = rowIndex;
        
        // Specify the ad's "unit identifier." This is your DFP ad unit ID.
        dfpBannerView.adUnitID = strAdUnitID;
        
        // Set the delegate to listen for GADBannerViewDelegate events.
        dfpBannerView.delegate = self;
        
        // Let the runtime know which UIViewController to restore after taking
        // the user wherever the ad goes and add it to the view hierarchy.
        dfpBannerView.rootViewController = sender;
        //[self.view addSubview:dfpBannerView];
        
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.frame=CGRectMake(((dfpBannerView.frame.size.width)-20)/2, ((dfpBannerView.frame.size.height)-20)/2, 20.0, 20.0);
        activityIndicator.hidesWhenStopped=YES;
        [activityIndicator startAnimating];
        [dfpBannerView addSubview:activityIndicator];
        GADRequest *request = [GADRequest request];
        //request.testDevices = @[ @"be43f74243d7bb3e27cab20fefe3ced6" ];
   
        // Initiate a generic request to load it with an ad.
        [dfpBannerView loadRequest:request];
    }
    else
    {
        NSLog(@"***** strUniqueID - DFPBannerView is available *****");
    }
    
    [bannerContainerView addSubview:dfpBannerView];
}


#pragma mark GADBannerViewDelegate implementation

- (void)adViewDidReceiveAd:(DFPBannerView *)adView {
    NSLog(@"Received ad successfully");
    [activityIndicator stopAnimating];
    isAdLoaded = YES;
    NSString *strUniqueID = [NSString stringWithFormat:@"%@_%ld",adView.adUnitID,(long)adView.tag];
    
    [appDelegate.dicAdvertisement setObject:adView forKey:strUniqueID];
}

- (void)adView:(DFPBannerView *)adView didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Failed to receive ad with error: %@ - %@", [error localizedFailureReason],strAdUnitID);
    //dicDeleteAdvertisement
    
    NSString *strUniqueID = [NSString stringWithFormat:@"%@",adView.adUnitID];
    [appDelegate.dicDeleteAdvertisement setObject:@"Advertisement Not Available" forKey:strUniqueID];
   
    if ([self.delegate respondsToSelector:@selector(reloadArticleListing:)])
        [self.delegate reloadArticleListing:adView.tag];
    
    [activityIndicator stopAnimating];
}
@end
