//
//  MasterViewController.h
//  AdoptionDaily
//
//  Created by Rakesh B on 19/05/14.
//  Copyright (c) 2014 Elevati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleCategoryManager.h"
#import "ArticleDetailViewController.h"
#import "ArticleCell.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import <NSString-HTML/NSString+HTML.h>
#import <MWFeedParser/NSString+HTML.h>
#import "Article.h"
#import "MenuViewController.h"
#import "AsyncImageView.h"
#import "SHK.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "CFShareCircleView.h"
#import "DFPBannerView.h"
#import "GADAdSizeDelegate.h"
#import "GADAppEventDelegate.h"
#import "GADBannerViewDelegate.h"
#import "GAITrackedViewController.h"
#import "MenuManager.h"
#import "SVWebViewController.h"
#import "MBProgressHUD.h"
#import "AdCell.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "FollowUsViewController.h"
#import "LegalViewController.h"
#import "StaticBrowserViewController.h"

@class ArticleDetailViewController;

@interface ArticleMasterViewController : GAITrackedViewController <UITableViewDataSource,UITableViewDelegate,ArticleCategoryDelegate,AsyncImageViewDelegate,MFMailComposeViewControllerDelegate,CFShareCircleViewDelegate,GADBannerViewDelegate, GADAdSizeDelegate, GADAppEventDelegate, MenuManagerDelegate,AdCellDelegate>
{
     DFPBannerView *dfpBannerView;
     BOOL shouldHideStatusBar;
     UIActivityIndicatorView *activityIndicator;
     MBProgressHUD *HUD;
}
@property (nonatomic, strong) LegalViewController *legalViewController;
@property (nonatomic, strong) SVWebViewController *webViewController;

@property (nonatomic, strong) AdCell *advertisementCell;
@property (nonatomic, strong) UITableViewCell *advertCell;
@property (nonatomic, strong) ArticleCell *cell;
@property (nonatomic, strong) UIButton *btnBackHeart;
@property (nonatomic, strong) UIButton *btnAdoption;

@property (nonatomic, strong) IBOutlet UITableView *tblArticleListing;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityProgress;
@property (nonatomic, strong) IBOutlet UIView *leftView;
@property (nonatomic, strong) IBOutlet UILabel *lblNoArticles;
@property (nonatomic, strong) IBOutlet UILabel *lblProcess;

@property (nonatomic, strong) NSMutableArray *arrArticleDetails;
@property (nonatomic, strong) NSMutableArray *arrSlideShowPost;

@property (nonatomic, strong) ArticleDetailViewController *articleDetailViewController;
@property (nonatomic, strong) FollowUsViewController *followUsViewController;

@property (nonatomic, strong) NSMutableArray *arrColors;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) AsyncImageView *imageView;
@property (nonatomic, strong) Article *objCurrentArticle;
@property (nonatomic, strong) Article *objSelectedArticle;
@property (nonatomic, assign) BOOL shouldTableReset;

@property (nonatomic, assign) BOOL isFirstServerCall;

@property (nonatomic, assign) CGRect titleRect;
@property (nonatomic, assign) BOOL isAsyncCallInProgress;
@property (nonatomic, strong) NSMutableArray *arrParsing;
@property (nonatomic, strong) MenuViewController *menuViewController;
@property (nonatomic, assign) NSInteger rowIndex;

@property (nonatomic, retain) UIView *sharePopUp;
@property (nonatomic, retain) UIView *shareSubPopUp;
@property (nonatomic, strong) NSString *strShareURL;

@property (nonatomic, strong) CFShareCircleView *shareCircleView;

@property (nonatomic, assign) BOOL shouldHideStatusBar;
@property (nonatomic, strong) NSString *menuCategoryId;
@property (nonatomic, strong) NSString *lastSelectedCategoryId;

@property (nonatomic, strong) NSString *strPageTitle;

- (void)refreshViewForCategory:(Menu*)objMenu;
- (IBAction)shareButtonCliked:(id)sender;
- (void)showMessage:strTitle forMessage:(NSString*)strMessage;

@end
