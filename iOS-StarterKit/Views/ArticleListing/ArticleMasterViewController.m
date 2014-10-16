//
//  MasterViewController.m
//  AdoptionDaily
//
//  Created by Rakesh B on 19/05/14.
//  Copyright (c) 2014 Elevati. All rights reserved.
//

#import "ArticleMasterViewController.h"
#import "AFNetworking.h"
#import "Global.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import <ImageIO/ImageIO.h>
#import "DBOperations.h"
#import "SHKConfiguration.h"
#import "SHKItem.h"
#import "SHKTwitter.h"
#import "SHKFacebook.h"
#import "SHKActionSheet.h"
#import "SHKiOSFacebook.h"
#import "SHKiOSTwitter.h"
#import "SHKPinterest.h"
#import "SHKGooglePlus.h"
#import "iRate.h"

@interface ArticleMasterViewController ()
{
    NSMutableArray *_objects;
    DBOperations *objDBOperations;
}

@end

@implementation ArticleMasterViewController
@synthesize tblArticleListing = tblArticleListing;
@synthesize activityProgress = activityProgress;
@synthesize arrColors = arrColors;
@synthesize shouldTableReset = shouldTableReset;
@synthesize titleRect = titleRect;
@synthesize objCurrentArticle = objCurrentArticle;
@synthesize leftView = leftView;
@synthesize menuViewController = menuViewController;
@synthesize lblNoArticles = lblNoArticles;
@synthesize lblProcess = lblProcess;
@synthesize articleDetailViewController = articleDetailViewController;
@synthesize arrArticleDetails = arrArticleDetails;
@synthesize cell = cell;
@synthesize isAsyncCallInProgress = isAsyncCallInProgress;
@synthesize webViewController = webViewController;
@synthesize sharePopUp = sharePopUp;
@synthesize shareSubPopUp = shareSubPopUp;
@synthesize strShareURL = strShareURL;
@synthesize shareCircleView = shareCircleView;
@synthesize menuCategoryId = menuCategoryId;
@synthesize advertCell = advertCell;
@synthesize strPageTitle = strPageTitle;
@synthesize isFirstServerCall = isFirstServerCall;
@synthesize lastSelectedCategoryId = lastSelectedCategoryId;
@synthesize arrSlideShowPost = arrSlideShowPost;
@synthesize advertisementCell = advertisementCell;
@synthesize objSelectedArticle = objSelectedArticle;
@synthesize rowIndex = rowIndex;
@synthesize shouldHideStatusBar = shouldHideStatusBar;
@synthesize imageView = imageView;
@synthesize followUsViewController = followUsViewController;
@synthesize legalViewController = legalViewController;

const CGRect TitleFrame = { { 15.0f, 190.0f }, { 270.0f, 90.0f }};
const CGRect SubTitleFrame = { { 15.0f, 269.0f }, { 270.0f, 92.0f }};
#define ImageHeight 196 //150 image and other for category label

const CGRect TitleFrameiPad = { { 15.0f, 280.0f }, { 450.0f, 90.0f }};
const CGRect SubTitleFrameiPad = { { 15.0f, 359.0f }, { 450.0f, 92.0f }};


#define ImageHeightiPad 286 //240 image and other for category label
#define ImageHeightPadding 46
#define ShareButtonHeight 30
#define ForumHeaderViewHeight 30
#define ForumFooterViewHeight 130
#define TitleFont [UIFont fontWithName:@"robotoslabregular" size:20.0f]
#define SubTitleFont [UIFont fontWithName:@"Helvetica" size:14.0f]
#define MaxSubTitleLength 150
#define MaxSubTitleLengthiPad 400
#define LabelPadding 42
#define MoreSubTitleHeight 50

const CGSize iPhoneImageSize = { 300.0f, 150.0f };
const CGSize iPadImageSize = { 480.0f, 240.0f };



AppDelegate *appDelegate;

#pragma mark - View Lifecycle

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // NSLog(@"In viewWillAppear");
    
    if([strPageTitle length] > 0)
        self.navigationItem.title = strPageTitle;
    
    if([self.navigationItem.title length] == 0)
        self.navigationItem.title = @"Recent Posts";
    
    if(articleDetailViewController.youTubeWebView != nil)
    {
        [articleDetailViewController.youTubeWebView loadHTMLString:nil baseURL:nil];
    }
    
    //This is for removing allocated memory for details screen
    articleDetailViewController = nil;
    webViewController = nil;
    
    appDelegate.isOnMasterArticleMasterScreen = YES;
    
    [tblArticleListing reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    appDelegate.isOnMasterArticleMasterScreen = NO;
    self.navigationItem.title = Blank;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self loadArticleDetailsScreen:indexPath.row];
}

-(void)loadAdoptableKidDetails:(NSString *)strChildId
{
    //NSLog(@"adoptable kid strChildId ->>>> %@",strChildId);
    ArticleCategoryManager *articleCategory = [ArticleCategoryManager defaultManager];
    [self showProgressBar:YES];
    [articleCategory getAdoptableKidDetailsById:strChildId];
}

- (void)getAdoptableKidDetailsByIdSuccessfullyWith:(NSDictionary*)postResults
{
    //NSLog(@"postResults ->>>> %@",postResults);
    objSelectedArticle.content = [postResults objectForKey:@"FullSummary"];
    objSelectedArticle.country = [postResults objectForKey:@"Country"];
    
    if([[postResults objectForKey:@"Gender"] isEqualToString:@"F"])
        objSelectedArticle.childGender = @"Female";
    else
        objSelectedArticle.childGender = @"Male";
    
    //NSLog(@"postResults AgencyChildID->>>> %@",[postResults objectForKey:@"AgencyChildID"]);
    
    //if([[postResults objectForKey:@"AgencyChildID"] length] > 0)
    
    if([postResults objectForKey:@"AgencyChildID"] != [NSNull null] && [[postResults objectForKey:@"AgencyChildID"] length] > 0 && ![[postResults objectForKey:@"AgencyChildID"]  isEqualToString:@"(null)"])
        objSelectedArticle.caseId = [NSString stringWithFormat:@"%@",[postResults objectForKey:@"AgencyChildID"]];
    else
        objSelectedArticle.caseId = @"";
    
    objSelectedArticle.isUpdated = @"1";
    
    NSString *strArticleDetailsJSON =  [[Global defaultGlobal] convertDictionaryToJSON:[objSelectedArticle toNSDictionary]];
    [objDBOperations updateArticle:objSelectedArticle.articleId  withDetails:strArticleDetailsJSON created:objSelectedArticle.date modified:objSelectedArticle.modified categoryIds:objSelectedArticle.categoryIds postType:objSelectedArticle.categoryType];
    [self showProgressBar:NO];
    [self loadArticleDetailsScreen:-1];
}

- (void)getAdoptableKidDetailsByIdError:(NSString*)error
{
    NSLog(@"postResults error - %@",error);
    //[self loadArticleDetailsScreen:-1];
}

#pragma mark - TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([arrArticleDetails count] != 0)
    {
        [tblArticleListing setHidden:NO];
        [activityProgress stopAnimating];
    }
    
    return [arrArticleDetails count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    objCurrentArticle = (Article*)[arrArticleDetails objectAtIndex:indexPath.row];
    
    if(objCurrentArticle.isAdvertisement)
    {
        NSString *strAdvertisement = [appDelegate.dicDeleteAdvertisement objectForKey:objCurrentArticle.adsUnit];
        if([strAdvertisement length] == 0)
        {
            if(IS_IPHONE)
                return 255;
            else
                return 325;
        }
        else
        {
            return 0;
        }
    }
    else
    {
        if([objCurrentArticle.title isEqualToString:No_More_Content_To_Display])
        {
            return No_More_Cell_Height;
        }
        else
        {
            CGRect titleFrame = TitleFrame;
            if(IS_IPAD)
                titleFrame = TitleFrameiPad;
            
            CGRect mainTitleRect = CGRectZero;
            
            mainTitleRect = [[Global defaultGlobal] getDynamicHeightForLabel:titleFrame forString:objCurrentArticle.title forFont:TitleFont];
            
            CGRect subTitleFrame = SubTitleFrame;
            if(IS_IPAD)
                subTitleFrame = SubTitleFrameiPad;
            
            CGRect subTitleRect = CGRectZero;
            
            if([objCurrentArticle.subTitle length] > 0)
                subTitleRect = [[Global defaultGlobal] getDynamicHeightForLabel:subTitleFrame forString:objCurrentArticle.subTitle forFont:SubTitleFont];
            
            CGFloat rowHeight = 0;
            
            CGSize imageSize = iPhoneImageSize;
            
            if(IS_IPAD)
                imageSize = iPadImageSize;
            
            CGFloat imgHeight = 0;
            
            if([objCurrentArticle.thumbnailImage length] > 0)
            {
                //This is to resolve variable image sizes for adoptable kids
                if([objCurrentArticle.imageWidth integerValue] > 0 && [objCurrentArticle.imageHeight integerValue] > 0)
                {
                    CGSize actualImageSize = CGSizeMake([objCurrentArticle.imageWidth integerValue], [objCurrentArticle.imageHeight integerValue]);
                    imgHeight = [[Global defaultGlobal] getImageRect:objCurrentArticle.thumbnailImage size:imageSize actualImage:actualImageSize].size.height + ImageHeightPadding;
                }
                else
                {
                    imgHeight = [[Global defaultGlobal] getImageRect:objCurrentArticle.thumbnailImage size:imageSize actualImage:[self getImageSize:objCurrentArticle.thumbnailImage]].size.height + ImageHeightPadding;
                }
            }
            
            if(objCurrentArticle.isImageAvailable)
                rowHeight = imgHeight +  mainTitleRect.size.height + subTitleRect.size.height + ShareButtonHeight + LabelPadding;
            else
                rowHeight = 45 + mainTitleRect.size.height + subTitleRect.size.height + ShareButtonHeight + LabelPadding;
            
            if([objCurrentArticle.categoryType isEqualToString:Key_Adoptable_Kids] || [objCurrentArticle.categoryType isEqualToString:Key_Forum] || [objCurrentArticle.categoryType isEqualToString:Key_Parent_Profile])
            {
                CGRect moreSubTitleFrame = [[Global defaultGlobal] getDynamicHeightForLabelOnMaxHeight:subTitleFrame forString:objCurrentArticle.nonHTMLContent forFont:SubTitleFont forHeight:MoreSubTitleHeight];
                
                rowHeight = rowHeight + moreSubTitleFrame.size.height + 5;
            }
            
            if([objCurrentArticle.categoryType isEqualToString:Key_Forum])
                rowHeight = rowHeight + ForumHeaderViewHeight + ForumFooterViewHeight + 5;
            return rowHeight;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ArticleCell";
    static NSString *advertiseCellIdentifier = @"AdvertCell";
    
    //parsing the json file
    objCurrentArticle = (Article*)[arrArticleDetails objectAtIndex:indexPath.row];
    
    if(objCurrentArticle.isAdvertisement)
    {
        if(advertisementCell == nil) {
            if(IS_IPAD)
                [tableView registerNib:[UINib nibWithNibName:@"AdCell_iPad" bundle:nil] forCellReuseIdentifier:advertiseCellIdentifier];
            else
                [tableView registerNib:[UINib nibWithNibName:@"AdCell_iPhone" bundle:nil] forCellReuseIdentifier:advertiseCellIdentifier];
        }
        
        advertisementCell = [tableView dequeueReusableCellWithIdentifier:advertiseCellIdentifier];
        NSString *strAdvertisement = [appDelegate.dicDeleteAdvertisement objectForKey:objCurrentArticle.adsUnit];
        
        NSLog(@"%@",strAdvertisement);
        
        if([strAdvertisement length] == 0)
        {
            @autoreleasepool {
                advertisementCell = (AdCell *)[tableView dequeueReusableCellWithIdentifier:advertiseCellIdentifier];
                advertisementCell.delegate = self;
                advertisementCell.isFromDetailScreen = NO;
                advertisementCell.bannerContainerView.backgroundColor = [UIColor clearColor];
                advertisementCell.rowIndex = indexPath.row;
                [advertisementCell setSelectionStyle:UITableViewCellSelectionStyleNone];
                advertisementCell.strAdUnitID = objCurrentArticle.adsUnit;
                
                if(IS_IPHONE)
                    advertisementCell.adSize = kGADAdSizeMediumRectangle;
                else
                    advertisementCell.adSize =  GADAdSizeFromCGSize(CGSizeMake(480, 320));
                
                advertisementCell.sender = self;
                [advertisementCell loadDFPGoogleAds];
            }
        }
        return advertisementCell;
    }
    else
    {
        //This is for handing the
        if([objCurrentArticle.title isEqualToString:No_More_Content_To_Display])
        {
            [tblArticleListing setShowsInfiniteScrolling:NO];
            NSLog(@"%@",No_More_Content_To_Display);
            UITableViewCell *lblNoMoreContentToDisplay = [[UITableViewCell alloc] init];
            lblNoMoreContentToDisplay.textLabel.text = @"No more records";
            lblNoMoreContentToDisplay.textLabel.textColor = [UIColor redColor];
            UIFont *font = [UIFont boldSystemFontOfSize:18];
            lblNoMoreContentToDisplay.textLabel.font = font;
            lblNoMoreContentToDisplay.textLabel.textAlignment = NSTextAlignmentCenter;
            lblNoMoreContentToDisplay.userInteractionEnabled = NO;
            return lblNoMoreContentToDisplay;
        }
        else
        {
            if(cell == nil) {
                if(IS_IPAD)
                    [tableView registerNib:[UINib nibWithNibName:@"ArticleCell_iPad" bundle:nil] forCellReuseIdentifier:cellIdentifier];
                else
                    [tableView registerNib:[UINib nibWithNibName:@"ArticleCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
                
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                titleRect = cell.lblTitle.frame;
            }
            
            cell = (ArticleCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            cell.lblTitle.frame = titleRect;
            cell.lblTitle.font = TitleFont;
            
            //Settings for the Image
            if(objCurrentArticle.isImageAvailable)
            {
                cell.imgThumbnail.hidden = NO;
                CGSize imageSize = iPhoneImageSize;
                if(IS_IPAD)
                    imageSize = iPadImageSize;
                
                //This is to resolve variable image sizes for adoptable kids
                if([objCurrentArticle.imageWidth integerValue] > 0 && [objCurrentArticle.imageHeight integerValue] > 0)
                {
                    CGSize actualImageSize = CGSizeMake([objCurrentArticle.imageWidth integerValue], [objCurrentArticle.imageHeight integerValue]);
                    cell.imgThumbnail.frame = [[Global defaultGlobal] getImageRect:objCurrentArticle.thumbnailImage size:imageSize actualImage:actualImageSize];
                }
                else
                {
                    cell.imgThumbnail.frame = [[Global defaultGlobal] getImageRect:objCurrentArticle.thumbnailImage size:imageSize actualImage:[self getImageSize:objCurrentArticle.thumbnailImage]];
                }
                
                cell.imgThumbnail.contentMode = UIViewContentModeScaleAspectFill;
                
                NSLog(@"%@",NSStringFromCGRect(cell.imgThumbnail.bounds));
                
                //Code for downloading async offer image
                NSString *strStorageLocation = [NSString stringWithFormat:ArticleImageFolderLocation];
                CGRect imgPostion = cell.imgThumbnail.bounds;
                NSLog(@"%@",NSStringFromCGRect(imgPostion));
                
                imageView = [self downloadImageForRowIndex:indexPath.row withImageUrl:objCurrentArticle.thumbnailImage withImageDirectory:strStorageLocation withRect:imgPostion resizeTo:cell.imgThumbnail.frame.size];
                imageView.tag  = 100;
                UIView *view = [cell.imgThumbnail viewWithTag:100];
                
                if(view)
                    [view removeFromSuperview];
                
                [cell.imgThumbnail addSubview:imageView];
                
                //Arrange play button rect to center of background image
                CGFloat imgWidthCenter = cell.imgThumbnail.frame.size.width - cell.imgPlayVideo.frame.size.width;
                CGFloat imgHeightCenter = cell.imgThumbnail.frame.size.height - cell.imgPlayVideo.frame.size.height;
                CGRect imgPlayRect = CGRectMake(imgWidthCenter/2
                                                , imgHeightCenter/2, cell.imgPlayVideo.frame.size.width, cell.imgPlayVideo.frame.size.height);
                cell.imgPlayVideo.frame = imgPlayRect;
                
                //if([objCurrentArticle.articleType isEqualToString:VideoTag])
                if([objCurrentArticle.youtubeVideoID length] > 0)
                    cell.imgPlayVideo.hidden = NO;
                else
                    cell.imgPlayVideo.hidden = YES;
            }
            else
            {
                cell.imgPlayVideo.hidden = YES;
                cell.imgThumbnail.hidden = YES;
            }
            
            //Below code is to make substring bold
            NSMutableAttributedString *strAttributedCategoryTitle;
            UIFont *categoryTitleFont = [UIFont fontWithName:@"Helvetica-Bold" size:11.0];
            
            if(objCurrentArticle.categoryTitle != nil)
            {
                //This parent profile comes from adoption website
                if([objCurrentArticle.categoryTitle isEqualToString:ParentProfileSuccessStory])
                {
                    strAttributedCategoryTitle = [[NSMutableAttributedString alloc] initWithString:ParentProfileSuccessStory];
                    [strAttributedCategoryTitle addAttribute:NSFontAttributeName value:categoryTitleFont range:NSMakeRange(0, [ParentProfileSuccessStory length])];
                }
                //This parent profile comes from parent profile website
                else if([objCurrentArticle.categoryType isEqualToString:Key_Parent_Profile])
                {
                    strAttributedCategoryTitle = [[NSMutableAttributedString alloc] initWithString:Parent_Profile_Title];
                    [strAttributedCategoryTitle addAttribute:NSFontAttributeName value:categoryTitleFont range:NSMakeRange(0, [Parent_Profile_Title length])];
                }
                else if([objCurrentArticle.categoryType isEqualToString:Key_Forum])
                {
                    strAttributedCategoryTitle = [[NSMutableAttributedString alloc] initWithString:[objCurrentArticle.categoryTitle uppercaseString]];
                    [strAttributedCategoryTitle addAttribute:NSFontAttributeName value:categoryTitleFont range:NSMakeRange(0, [objCurrentArticle.categoryTitle length])];
                }
                else if([objCurrentArticle.categoryType isEqualToString:Key_Adoptable_Kids])
                {
                    strAttributedCategoryTitle = [[NSMutableAttributedString alloc] initWithString:objCurrentArticle.categoryTitle];
                    [strAttributedCategoryTitle addAttribute:NSFontAttributeName value:categoryTitleFont range:NSMakeRange(0, [Adoptable_Kids length])];
                }
                else
                {
                    strAttributedCategoryTitle = [[NSMutableAttributedString alloc] initWithString:objCurrentArticle.categoryTitle];
                    [strAttributedCategoryTitle addAttribute:NSFontAttributeName value:categoryTitleFont range:NSMakeRange(0, [objCurrentArticle.categoryName length])];
                }
                cell.lblCategory.attributedText =  strAttributedCategoryTitle;
            }
            
            [cell.forumHeaderView setHidden:YES];
            [cell.forumMiddleView setHidden:YES];
            [cell.forumFooterView setHidden:YES];
            
            if(objCurrentArticle.isImageAvailable)
            {
                cell.lblCategory.frame = CGRectMake(cell.lblCategory.frame.origin.x, cell.imgThumbnail.frame.origin.y+cell.imgThumbnail.frame.size.height + 15, cell.lblCategory.frame.size.width, cell.lblCategory.frame.size.height);
            }
            else if([objCurrentArticle.categoryType isEqualToString:Key_Forum])
            {
                [cell.forumHeaderView setHidden:NO];
                [cell.forumMiddleView setHidden:NO];
                [cell.forumFooterView setHidden:YES];
                
                cell.forumHeaderView.frame = CGRectMake(0, 0, cell.forumHeaderView.frame.size.width, cell.forumHeaderView.frame.size.height);
                cell.lblCategory.frame = CGRectMake(cell.lblCategory.frame.origin.x, cell.forumHeaderView.frame.origin.y+cell.forumHeaderView.frame.size.height + 15, cell.lblCategory.frame.size.width, cell.lblCategory.frame.size.height);
            }
            else
            {
                cell.lblCategory.frame = CGRectMake(cell.lblCategory.frame.origin.x,15, cell.lblCategory.frame.size.width, cell.lblCategory.frame.size.height);
            }
            
            //Positioning for the Underline Label
            cell.lblUnderline.frame = CGRectMake(cell.lblUnderline.frame.origin.x, cell.lblCategory.frame.origin.y+cell.lblCategory.frame.size.height - 8, cell.lblUnderline.frame.size.width, cell.lblUnderline.frame.size.height);
            
            //Positioning for the Title Label
            cell.lblTitle.text = objCurrentArticle.title;
            CGRect titleFrame = [[Global defaultGlobal] getDynamicHeightForLabel:cell.lblTitle.frame forString:cell.lblTitle.text forFont:cell.lblTitle.font];
            cell.lblTitle.frame = CGRectMake(cell.lblTitle.frame.origin.x, cell.lblUnderline.frame.origin.y+cell.lblUnderline.frame.size.height + 10, cell.lblTitle.frame.size.width, titleFrame.size.height);
            
            //Positioning for the Sub Title Label
            cell.lblSubTitle.text = objCurrentArticle.subTitle;//objCurrentArticle.shortContent;
            CGRect rect = [[Global defaultGlobal] getDynamicHeightForLabel:cell.lblSubTitle.frame forString:cell.lblSubTitle.text forFont:cell.lblSubTitle.font];
            cell.lblSubTitle.frame = CGRectMake(cell.lblSubTitle.frame.origin.x, cell.lblTitle.frame.origin.y+cell.lblTitle.frame.size.height + 10, cell.lblSubTitle.frame.size.width, rect.size.height);
            
            CGFloat btnShareYValue = cell.lblSubTitle.frame.origin.y + cell.lblSubTitle.frame.size.height + 15;
            
            //More Sub Title is the label used only for the Adoptable Kids
            if([objCurrentArticle.categoryType isEqualToString:Key_Adoptable_Kids] || [objCurrentArticle.categoryType isEqualToString:Key_Forum] || [objCurrentArticle.categoryType isEqualToString:Key_Parent_Profile])
            {
                //remove padding
                btnShareYValue = btnShareYValue - 10;
                
                [cell.lblMoreSubTitle setHidden:NO];
                
                //For the Adoptable Kids we need to display partial text in Masnory listing
                cell.lblMoreSubTitle.text = objCurrentArticle.nonHTMLContent;
                
                CGRect moreSubTitleFrame = [[Global defaultGlobal] getDynamicHeightForLabelOnMaxHeight:cell.lblMoreSubTitle.frame forString:cell.lblMoreSubTitle.text forFont:cell.lblMoreSubTitle.font forHeight:MoreSubTitleHeight];
                
                cell.lblMoreSubTitle.frame = CGRectMake(cell.lblMoreSubTitle.frame.origin.x, btnShareYValue, cell.lblMoreSubTitle.frame.size.width, moreSubTitleFrame.size.height);
                btnShareYValue = cell.lblMoreSubTitle.frame.origin.y + cell.lblMoreSubTitle.frame.size.height + 15;
            }
            else
            {
                [cell.lblMoreSubTitle setHidden:YES];
            }
            
            if([objCurrentArticle.categoryType isEqualToString:Key_Forum])
            {
                //Calculating the height for the middle view
                cell.forumMiddleView.frame = CGRectMake(cell.forumMiddleView.frame.origin.x, cell.forumHeaderView.frame.origin.y+cell.forumHeaderView.frame.size.height, cell.forumMiddleView.frame.size.width, btnShareYValue - ForumHeaderViewHeight + 5);
                
                [cell.forumFooterView setHidden:NO];
                
                [cell.lblFooterViewByName  setText:[NSString stringWithFormat:@"by %@ / %@",objCurrentArticle.author,objCurrentArticle.forumPostDateTime]];
                
                cell.forumFooterView.frame = CGRectMake(cell.forumFooterView.frame.origin.x, cell.forumMiddleView.frame.origin.y + cell.forumMiddleView.frame.size.height, cell.forumFooterView.frame.size.width, cell.forumFooterView.frame.size.height);
                
                btnShareYValue = btnShareYValue + ForumFooterViewHeight + 5;
            }
            
            CGFloat yPadding = 4;
            if(IS_IPAD && (!IS_RETINA))
                yPadding = 3;
            
            //Positioning for the Share button/icon/background view
            cell.btnShare.frame = CGRectMake(cell.btnShare.frame.origin.x,btnShareYValue + yPadding, cell.btnShare.frame.size.width, cell.btnShare.frame.size.height);
            
            cell.viewShareBackgorund.frame = CGRectMake(cell.viewShareBackgorund.frame.origin.x,btnShareYValue, cell.viewShareBackgorund.frame.size.width, cell.viewShareBackgorund.frame.size.height);
            cell.btnShareIcon.frame = CGRectMake(cell.btnShareIcon.frame.origin.x,btnShareYValue - 1, cell.btnShareIcon.frame.size.width, cell.btnShareIcon.frame.size.height);
            cell.btnShare.tag = indexPath.row;
            
            [cell.btnShare addTarget:self action:@selector(shareButtonCliked:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.centerContentView.frame = CGRectMake(cell.centerContentView.frame.origin.x, cell.centerContentView.frame.origin.y, cell.centerContentView.frame.size.width, cell.viewShareBackgorund.frame.origin.y + cell.viewShareBackgorund.frame.size.height);
            
            
            UIColor *backgroundColor = [self getBackgorundColorForRow:objCurrentArticle.index];
            cell.centerContentView.backgroundColor = backgroundColor;
            //cell.centerContentView.backgroundColor = [UIColor grayColor];
            
            //Implemented to swipe right on cell to open Article
            UISwipeGestureRecognizer *gestureR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipeToOpenArticle:)];
            gestureR.direction = UISwipeGestureRecognizerDirectionLeft; // default
            [cell addGestureRecognizer:gestureR];
            return cell;
        }
    }
    
}

#pragma mark - Public methods
- (void)refreshViewForCategory:(Menu*)objMenu
{
    menuCategoryId = objMenu.menuCategoryId;
    
    
    if([objMenu.menuCategoryType isEqualToString:@"Category"])
    {
        [tblArticleListing setShowsInfiniteScrolling:YES];
        
        lastSelectedCategoryId = menuCategoryId;
        strPageTitle = objMenu.pageTitle;
        self.navigationItem.title = objMenu.pageTitle;
        
        //this is to record when user refresh from the masonry listing
        if([self.navigationItem.title length] > 0)
            self.screenName = [NSString stringWithFormat:@"Masonry Listing - %@",self.navigationItem.title];
        
        [[Global defaultGlobal] setUserDefaultValue:@"1" forKey:Key_Current_Page];
        
        [appDelegate inititalizeReachability];
        if([appDelegate isInternetConnectionAvailable])
        {
            arrArticleDetails = [[NSMutableArray alloc] init];
            rowIndex = 0;
            objCurrentArticle = [[Article alloc] init];
            [tblArticleListing reloadData];
            
            shouldTableReset = YES;
            
            [[Global defaultGlobal] setUserDefaultValue:@"1" forKey:Key_Current_Page];
            
            if([arrArticleDetails count] == 0)
            {
                [lblProcess setHidden:NO];
                [activityProgress setHidden:NO];
                [activityProgress startAnimating];
            }
            
            [self refreshArticleListing];
        }
        else
        {
            //Very IMP functionality
            //here we get the article from database if availble else display message as "no articles to display"
            [self loadCachedArticlesForOfflineMode];
            [self handleClickForOfflineMode];
        }
    }
    else if([objMenu.menuCategoryType isEqualToString:@"Slideshow"])
    {
        [self loadArticleByCategoryId:menuCategoryId];
    }
    else if([objMenu.title isEqualToString:@"Legal"])
    {
        if(IS_IPAD)
            legalViewController = [[LegalViewController alloc] initWithNibName:@"LegalViewController_iPad" bundle:nil];
        else if(appDelegate.isIphone4)
            legalViewController = [[LegalViewController alloc] initWithNibName:@"LegalViewController_iPhone_4" bundle:nil];
        else
            legalViewController = [[LegalViewController alloc] initWithNibName:@"LegalViewController_iPhone" bundle:nil];
        
        [self.navigationController pushViewController:legalViewController animated:YES];
    }
    else
    {
        //Above condition is commented because in wp-admin panel we have multiple type of menu, so here we are handling two type of menu as slideshow and category
        NSString *strAnalyticsTitle = [NSString stringWithFormat:@"%@ - %@",objMenu.pageTitle,objMenu.title];
        [self openWebURL:[NSURL URLWithString:objMenu.url] withTitle:objMenu.title withAnalyticsTitle:strAnalyticsTitle];
    }
}

-(void)loadArticleByCategoryId:(NSString*)categoryId
{
    if(![self getArticleLocallyByCategoryId:menuCategoryId])
    {
        [appDelegate inititalizeReachability];
        if(appDelegate.isInternetConnectionAvailable)
        {
            [self showProgressBar:YES];
            //Need to redirect to article details, also need to make a call there
            ArticleCategoryManager *articleCategory = [ArticleCategoryManager defaultManager];
            articleCategory.delegate = self;
            [articleCategory getPostById:menuCategoryId];
        }
        else
        {
            [self showProgressBar:NO];
            [self handleClickForOfflineMode];
        }
    }
}

-(void)showProgressBar:(BOOL)status
{
    if(status)
    {
        HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES] ;
        HUD.labelText = NSLocalizedString(@"ProgressLabel",nil);
        HUD.detailsLabelText = NSLocalizedString(@"ProgressDetailLabel",nil);
        HUD.square = NO;
    }
    else
    {
        [HUD hide:YES];
    }
}

-(BOOL)getArticleLocallyByCategoryId:(NSString*)categoryId
{
    if([objDBOperations checkPostExistsLocally:categoryId])
    {
        [self showProgressBar:YES];
        [self performSelector:@selector(loadArticleDetailsView:) withObject:categoryId afterDelay:0.1];
        
        return YES;
    }
    return NO;
}

-(void)loadArticleDetailsView:(NSString*)categoryId
{
    NSMutableArray *arrLocalArticle = [[NSMutableArray alloc] initWithArray:[objDBOperations getArticleLocallyByCategoryId:categoryId]];
    // arrLocalArticle = ;
    if([arrLocalArticle count] > 0)
    {
        //if(objSelectedArticle == nil)
        objSelectedArticle = [[Article alloc] init];
        objSelectedArticle = [arrLocalArticle objectAtIndex:0];
        [self showProgressBar:NO];
        [self loadArticleDetailsScreen:-1];
    }
}

#pragma mark - Advertisement Cell Call back methods

- (void)reloadArticleListing:(NSInteger)tempRowIndex
{
    NSLog(@"%ld",(long)tempRowIndex);
    [tblArticleListing reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:tempRowIndex inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
}

#pragma mark - API Call back methods

- (void)getPostByIdSuccessfullyWith:(NSMutableArray*)postResults
{
    arrSlideShowPost = [[NSMutableArray alloc] init];
    if ([postResults count] > 0) {
        [self parseArticleListing:postResults completionHandler:^(NSMutableArray *arrFinalList){
            arrSlideShowPost = arrFinalList;
            if([arrSlideShowPost count] > 0){
                objSelectedArticle = [[Article alloc] init];
                objSelectedArticle = [arrSlideShowPost objectAtIndex:0];
                [self loadArticleDetailsScreen:-1];
                [self showProgressBar:NO];
            }
            else {
                [self displayAlertForErrorOccuredWhileConnecting];
            }
        }];
    } else {
        [self showProgressBar:NO];
        [self displayAlertForErrorOccuredWhileConnecting];
    }
}

- (void)getPostByIdError:(NSString*)error
{
    [self showProgressBar:NO];
    [self displayAlertForErrorOccuredWhileConnecting];
}

- (void)getPostsSuccessfullyWith:(NSMutableArray*)postsResults
{
    NSLog(@"getRecentArticleSuccessfullyWith --- start --------------");
    if(isFirstServerCall)
    {
        if ([postsResults count] > 0) {
            isFirstServerCall = NO;
            if (shouldTableReset) {
                [[Global defaultGlobal] setUserDefaultValue:@"2" forKey:Key_Current_Page];
                [arrArticleDetails removeAllObjects];
            } else {
                NSInteger currentPage = [[[Global defaultGlobal] getUserDefaultValue:Key_Current_Page] integerValue];
                currentPage++;
                [[Global defaultGlobal] setUserDefaultValue:[NSString stringWithFormat:@"%ld",(long)currentPage] forKey:Key_Current_Page];
            }
            
            postsResults = [self parseArticleListingData:postsResults];
            [arrArticleDetails addObjectsFromArray:postsResults];
            [tblArticleListing reloadData];
            [lblNoArticles setHidden:YES];
            tblArticleListing.tableFooterView = nil;
        } else {
            if ([arrArticleDetails count] == 0) {
                [self displayNoPostsAvailble];
                [self loadCachedArticleForError];
            }
        }
        
        [lblProcess setHidden:YES];
        [tblArticleListing setHidden:NO];
        //[tblArticleListing reloadData];
        [self.refreshControl endRefreshing];
        [tblArticleListing.infiniteScrollingView stopAnimating];
        isAsyncCallInProgress = NO;
    }
    else
    {
        if ([postsResults count] > 0) {
            [self parseJSONAndUpdateUI:postsResults];
            
        } else {
            if ([arrArticleDetails count] == 0) {
                [self displayNoPostsAvailble];
                [self loadCachedArticleForError];
            }
        }
    }
    NSLog(@"getRecentArticleSuccessfullyWith --- end --------------");
}

- (void)parseArticleListing:(NSMutableArray *)arrArticleList completionHandler:(void (^)(NSMutableArray *events))completionHandler
{
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(backgroundQueue, ^{
        NSMutableArray *mutable = [self parseArticleListingData:arrArticleList];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler([mutable copy]);
        });
    });
}

- (void)parseJSONAndUpdateUI:(NSMutableArray*)arrArticleList // Or whatever you're doing
{
    [self parseArticleListing:arrArticleList completionHandler:^(NSMutableArray *arrFinalList){
        // Update UI with parsed events here
        if (shouldTableReset) {
            [[Global defaultGlobal] setUserDefaultValue:@"2" forKey:Key_Current_Page];
            [arrArticleDetails removeAllObjects];
        } else {
            NSInteger currentPage = [[[Global defaultGlobal] getUserDefaultValue:Key_Current_Page] integerValue];
            currentPage++;
            [[Global defaultGlobal] setUserDefaultValue:[NSString stringWithFormat:@"%ld",(long)currentPage] forKey:Key_Current_Page];
        }
        
        isFirstServerCall = NO;
        [arrArticleDetails addObjectsFromArray:arrFinalList];
        [tblArticleListing reloadData];
        [lblNoArticles setHidden:YES];
        tblArticleListing.tableFooterView = nil;
        
        [lblProcess setHidden:YES];
        [tblArticleListing setHidden:NO];
        [self.refreshControl endRefreshing];
        [tblArticleListing.infiniteScrollingView stopAnimating];
        isAsyncCallInProgress = NO;
    }];
}

-(NSMutableArray*)parseArticleListingData:(NSMutableArray*)arrArticles
{
    NSMutableArray *arrArticleListing = [[NSMutableArray alloc] init];
    
    NSLog(@"--- parseArticleListingData --- start --------------");
    
    for (int index = 0; index < [arrArticles count]; index++) {
        if([[[arrArticles objectAtIndex:index] description] isEqualToString:No_More_Content_To_Display])
        {
            NSLog(@"No more content to display");
            Article *objArticle = [[Article alloc] init];
            objArticle.title = No_More_Content_To_Display;
            [arrArticleListing addObject:objArticle];
        }
        else
        {
            NSDictionary *posts = [arrArticles objectAtIndex:index];
            if([posts count] > 0)
            {
                Article *objArticle = [[Article alloc] init];
                if(([posts objectForKey:Key_Category_Type] != [NSNull null]) && [[posts objectForKey:Key_Category_Type] length] >0)
                    objArticle.categoryType = [posts objectForKey:Key_Category_Type];
                else
                    objArticle.categoryType = Blank;
                
                //Below is the logic for handling the content box background color case
                if([objArticle.categoryType isEqualToString:Key_Advertisement])
                {
                    objArticle.index = -1;
                }
                else
                {
                    objArticle.index = rowIndex;
                    rowIndex = rowIndex + 1;
                }
                
                if([objArticle.categoryType isEqualToString:Key_Advertisement])
                {
                    NSDictionary *dicCategories = [posts objectForKey:@"dfp_ad"];
                    if([dicCategories count] > 0)
                    {
                        objArticle.adsUnit = [self appendAdvertisementPrefix:[dicCategories objectForKey:@"ad_unit"]];
                        
                        objArticle.adsSize = [dicCategories objectForKey:@"size"];
                        
                        NSArray *arrAdSize = [objArticle.adsSize componentsSeparatedByString:@","];
                        
                        if([arrAdSize count] > 0)
                        {
                            objArticle.adWidth = [arrAdSize objectAtIndex:0];
                            objArticle.adHeight = [arrAdSize objectAtIndex:1];
                        }
                        
                        if([objArticle.adsUnit length] > 0)
                            objArticle.isAdvertisement = YES;
                    }
                }
                else if([objArticle.categoryType isEqualToString:Key_Forum])
                {
                    if([posts objectForKey:@"postid"] != [NSNull null])
                        objArticle.articleId =[posts objectForKey:@"postid"];
                    else
                        objArticle.articleId = Blank;
                    
                    if([posts objectForKey:@"image"] != [NSNull null])
                    {
                        objArticle.thumbnailImage = [posts objectForKey:@"image"];
                        if([objArticle.thumbnailImage length] > 0)
                            objArticle.isImageAvailable = YES;
                    }
                    else
                    {
                        objArticle.isImageAvailable = NO;
                        objArticle.thumbnailImage = Blank;
                    }
                    
                    if([posts objectForKey:Key_Forum_Category_Title] != [NSNull null])
                        objArticle.categoryTitle = [posts objectForKey:Key_Forum_Category_Title];
                    else
                        objArticle.categoryTitle = Blank;
                    
                    if([posts objectForKey:Key_Article_Title] != [NSNull null])
                        objArticle.title = [[posts objectForKey:Key_Article_Title]
                                            kv_decodeHTMLCharacterEntities];
                    else
                        objArticle.title = Blank;
                    
                    if([posts objectForKey:Key_Article_Content] != [NSNull null])
                    {
                        NSString *postContent = [self stringByStrippingHTML:[[posts objectForKey:Key_Article_Content] kv_decodeHTMLCharacterEntities]];
                        objArticle.nonHTMLContent = [[postContent componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
                    }
                    else
                    {
                        objArticle.nonHTMLContent = Blank;
                    }
                    
                    if([posts objectForKey:Key_Forum_Post_UserName] != [NSNull null])
                        objArticle.author = [posts objectForKey:Key_Forum_Post_UserName];
                    else
                        objArticle.author = Blank;
                    
                    if([posts objectForKey:Key_Article_Date] != [NSNull null])
                        objArticle.date = [posts objectForKey:Key_Article_Date];
                    else
                        objArticle.date = Blank;
                    
                    if([posts objectForKey:Key_Forum_Post_Date_Timestamp] != [NSNull null])
                        objArticle.forumPostDateTime = [posts objectForKey:Key_Forum_Post_Date_Timestamp];
                    else
                        objArticle.forumPostDateTime = Blank;
                    
                    if([posts objectForKey:@"link"] != [NSNull null])
                        objArticle.shareArticleURL = [posts objectForKey:@"link"];
                    else
                        objArticle.shareArticleURL = Blank;
                }
                else if([objArticle.categoryType isEqualToString:Key_Parent_Profile])
                {
                    //profile_id
                    if([[posts objectForKey:@"profile_id"] length] > 0)
                        objArticle.articleId = [posts objectForKey:@"profile_id"];
                    else
                        objArticle.articleId = Blank;
                    
                    if([[posts objectForKey:@"location"] length] > 0)
                        objArticle.categoryTitle = [NSString stringWithFormat:@"%@ / %@",Parent_Profile_Title,[posts objectForKey:@"location"]];
                    else
                        objArticle.categoryTitle = [NSString stringWithFormat:Parent_Profile_Title];
                    
                    if([posts objectForKey:@"link"] != [NSNull null])
                    {
                        //This check is due to parent profile URL does not contain http:// due to which URL loading fails
                        if([[posts objectForKey:@"link"] hasPrefix:@"http://"])
                            objArticle.shareArticleURL = [posts objectForKey:@"link"];
                        else
                            objArticle.shareArticleURL = [NSString stringWithFormat:@"http://%@",[posts objectForKey:@"link"]];
                    }
                    else
                        objArticle.shareArticleURL = Blank;
                    
                    if([posts objectForKey:Key_Article_Title] != [NSNull null])
                        objArticle.title = [[posts objectForKey:Key_Article_Title] kv_decodeHTMLCharacterEntities];
                    else
                        objArticle.title = Blank;
                    
                    if([posts objectForKey:@"image"] != [NSNull null])
                    {
                        //I have added this check, due to parent profile URL does not contain http:// and due to which image download was failing
                        if([[posts objectForKey:@"image"] hasPrefix:@"http://"])
                            objArticle.thumbnailImage = [posts objectForKey:@"image"];
                        else
                            objArticle.thumbnailImage = [NSString stringWithFormat:@"http://%@",[posts objectForKey:@"image"]];
                        
                        if([objArticle.thumbnailImage length] > 0)
                        {
                            objArticle.isImageAvailable = YES;
                            NSDictionary *dicImageSize = [posts objectForKey:@"image_size"];
                            if([dicImageSize count] > 0)
                            {
                                objArticle.imageWidth = [dicImageSize objectForKey:@"width"];
                                objArticle.imageHeight = [dicImageSize objectForKey:@"height"];
                            }
                        }
                    }
                    else
                    {
                        objArticle.isImageAvailable = NO;
                        objArticle.thumbnailImage = Blank;
                    }
                    
                    NSString *postContent = [self stringByStrippingHTML:[[posts objectForKey:@"description"] kv_decodeHTMLCharacterEntities]];
                    objArticle.nonHTMLContent = [[postContent componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
                }
                else if([objArticle.categoryType isEqualToString:Key_Adoptable_Kids])
                {
                    if([posts objectForKey:@"cid"] != [NSNull null])
                        objArticle.articleId =[posts objectForKey:@"child_id"];
                    else
                        objArticle.articleId = Blank;
                    
                    //agency
                    if([posts objectForKey:Key_Agency] != [NSNull null])
                        objArticle.agency =[posts objectForKey:Key_Agency];
                    else
                        objArticle.agency = Blank;
                    
                    if([posts objectForKey:Key_Region] != [NSNull null])
                        objArticle.region =[posts objectForKey:Key_Region];
                    else
                        objArticle.region = Blank;
                    
                    if([posts objectForKey:Key_Child_Id] != [NSNull null])
                        objArticle.childId =[posts objectForKey:Key_Child_Id];
                    else
                        objArticle.childId = Blank;
                    
                    if([posts objectForKey:Key_Child_Age] != [NSNull null])
                        objArticle.childAge =[posts objectForKey:Key_Child_Age];
                    else
                        objArticle.childAge = Blank;
                    
                    if([posts objectForKey:Key_Article_Title] != [NSNull null])
                        objArticle.title = [[posts objectForKey:Key_Article_Title]
                                            kv_decodeHTMLCharacterEntities];
                    else
                        objArticle.title = Blank;
                    
                    //Need to add on server and also content coming form the server is incomplete
                    objArticle.childGender = @"Female";
                    objArticle.content = [posts objectForKey:@"post_excerpt"];
                    
                    NSString *postContent = [self stringByStrippingHTML:[[posts objectForKey:@"post_excerpt"] kv_decodeHTMLCharacterEntities]];
                    objArticle.nonHTMLContent = [[postContent componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
                    
                    objArticle.subTitle = [[posts objectForKey:@"post_sub_title"] kv_decodeHTMLCharacterEntities];
                    
                    if([[posts objectForKey:@"post_content"] length] > 0)
                        objArticle.categoryTitle = [NSString stringWithFormat:@"ADOPTABLE KIDS / %@",[posts objectForKey:@"post_content"]];
                    else
                        objArticle.categoryTitle = [NSString stringWithFormat:@"ADOPTABLE KIDS"];
                    
                    objArticle.isImageAvailable = NO;
                    
                    if([posts objectForKey:@"image"] != [NSNull null])
                    {
                        objArticle.thumbnailImage = [posts objectForKey:@"image"];
                        if([objArticle.thumbnailImage length] > 0)
                            objArticle.isImageAvailable = YES;
                        
                        NSDictionary *dicImageSize = [posts objectForKey:@"image_size"];
                        if([dicImageSize count] > 0)
                        {
                            objArticle.imageWidth = [dicImageSize objectForKey:@"width"];
                            objArticle.imageHeight = [dicImageSize objectForKey:@"height"];
                        }
                    }
                    else
                    {
                        objArticle.isImageAvailable = NO;
                        objArticle.thumbnailImage = Blank;
                    }
                    
                    if([posts objectForKey:@"link"] != [NSNull null])
                        objArticle.shareArticleURL = [posts objectForKey:@"link"];
                    else
                        objArticle.shareArticleURL = Blank;
                    
                    objArticle.isUpdated = @"0";
                    
                    NSMutableArray *arrAvailableObject = [objDBOperations getArticleLocallyByCategoryId:objArticle.childId] ;
                    
                    //If available then fetch and display the content locally and dont make a server call
                    if([arrAvailableObject count] > 0)
                    {
                        Article *objChild = [arrAvailableObject objectAtIndex:0];
                        if([objChild.isUpdated isEqualToString:@"1"])
                        {
                            objArticle.childGender = objChild.childGender;
                            objArticle.content = objChild.content;
                            objArticle.isUpdated = objChild.isUpdated;
                        }
                    }
                }
                else
                {
                    if([posts objectForKey:Key_Article_Id] != [NSNull null])
                        objArticle.articleId = [posts objectForKey:Key_Article_Id];
                    else
                        objArticle.articleId = Blank;
                    
                    //Article Title
                    if([posts objectForKey:Key_Article_Title] != [NSNull null])
                        objArticle.title = [[posts objectForKey:Key_Article_Title]
                                            kv_decodeHTMLCharacterEntities];
                    else
                        objArticle.title = Blank;
                    
                    //Article Content
                    if([posts objectForKey:Key_Article_Content] != [NSNull null])
                    {
                        NSString *strContent = [posts objectForKey:Key_Article_Content];
                        //[[posts objectForKey:Key_Article_Content] kv_decodeHTMLCharacterEntities];
                        strContent = [NSString stringWithFormat:@"<style type=\"text/css\">%@</style>%@",StyleCSS,strContent];
                        strContent = [strContent stringByReplacingOccurrencesOfString:@"<span style=\"line-height: 1.714285714; font-size: 1rem;\">" withString:@""];
                        strContent = [strContent stringByReplacingOccurrencesOfString:@"<span style=\"font-size: 1rem; line-height: 1.714285714;\">" withString:@""];
                        strContent = [strContent stringByReplacingOccurrencesOfString:@"<p><a href=\"" withString:@"<a href=\""];
                        strContent = [strContent stringByReplacingOccurrencesOfString:@"/></a>" withString:@"/></a><p>"];
                        strContent = [strContent stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
                        
                        strContent = [strContent stringByReplacingOccurrencesOfString:@"<p>&nbsp;</p>" withString:@""];
                        strContent = [strContent stringByReplacingOccurrencesOfString:@"<p> </p>" withString:@""];
                        
                        //as per analysis rem doesnt support web view, due to which links are not visible
                        strContent = [strContent stringByReplacingOccurrencesOfString:@"font-size: 1rem;" withString:@""];
                        
                        objArticle.content = [NSString stringWithFormat:@"%@",strContent];
                    }
                    
                    objArticle.isImageAvailable = NO;
                    
                    if([posts objectForKey:Key_Article_Thumbnail] != [NSNull null])
                    {
                        objArticle.thumbnailImage = [posts objectForKey:Key_Article_Thumbnail];
                        if([objArticle.thumbnailImage length] > 0)
                            objArticle.isImageAvailable = YES;
                    }
                    else
                        objArticle.thumbnailImage = Blank;
                    
                    if([posts objectForKey:Key_Article_Url] != [NSNull null])
                        objArticle.shareArticleURL = [posts objectForKey:Key_Article_Url];
                    else
                        objArticle.shareArticleURL = Blank;
                    
                    if([posts objectForKey:Key_Article_Date] != [NSNull null])
                        objArticle.date = [posts objectForKey:Key_Article_Date];
                    else
                        objArticle.date = Blank;
                    
                    if([posts objectForKey:Key_Article_Modified] != [NSNull null])
                        objArticle.modified = [posts objectForKey:Key_Article_Modified];
                    else
                        objArticle.modified = Blank;
                    
                    if([posts objectForKey:Key_Name] != [NSNull null])
                        objArticle.name = [posts objectForKey:Key_Name];
                    else
                        objArticle.name = Blank;
                    
                    if([posts objectForKey:Key_Author] != [NSNull null])
                        objArticle.author = [posts objectForKey:Key_Author];
                    else
                        objArticle.author = Blank;
                    
                    NSString *strCategoryTitle = @"";
                    if(([posts objectForKey:Key_Category_Title_Key] != [NSNull null]) && ([posts objectForKey:Key_Category_Title_Key] != nil))
                        strCategoryTitle = [[posts objectForKey:Key_Category_Title_Key] kv_decodeHTMLCharacterEntities];
                    else
                        strCategoryTitle = Blank;
                    
                    //For Category
                    if([posts objectForKey:Key_Category] != [NSNull null])
                    {
                        NSArray *arrCategories = [posts objectForKey:Key_Category];
                        NSDictionary *dicCategories;
                        
                        if([arrCategories count] > 0)
                        {
                            dicCategories = [arrCategories objectAtIndex:0];
                            
                            if([posts objectForKey:Key_Category_Type] != [NSNull null])
                                objArticle.articleType = [self getArticleCategoryType:[posts objectForKey:Key_Category_Type]];
                            else
                                objArticle.articleType = Blank;
                            
                            if([dicCategories objectForKey:Key_Category_Title] != [NSNull null])
                            {
                                if([strCategoryTitle length] > 0)
                                    objArticle.categoryName = strCategoryTitle;
                                else
                                    objArticle.categoryName = [[dicCategories objectForKey:Key_Category_Title] kv_decodeHTMLCharacterEntities];
                            }
                            else
                                objArticle.categoryName = Blank;
                            
                            //This is to identify as article type is Parent Profile and remove article category title - reffered from adoption.com
                            if([objArticle.articleType isEqualToString:ParentProfileSuccessStory])
                                objArticle.categoryTitle = [NSString stringWithFormat:@"%@",objArticle.articleType];
                            else
                            {
                                if([objArticle.articleType length] > 0)
                                    objArticle.categoryTitle = [NSString stringWithFormat:@"%@ / %@",[objArticle.categoryName uppercaseString],objArticle.articleType];
                                else
                                    objArticle.categoryTitle = [NSString stringWithFormat:@"%@",[objArticle.categoryName uppercaseString]];
                            }
                            
                            NSString *strCategoriesIds = @"";
                            //To get category ids to which article is associated
                            for(int index = 0; index < [arrCategories count]; index++)
                            {
                                dicCategories = [arrCategories objectAtIndex:index];
                                if([strCategoriesIds length] == 0)
                                    strCategoriesIds = [NSString stringWithFormat:@"%@",[dicCategories objectForKey:Key_Category_ID]];
                                else
                                    strCategoriesIds = [NSString stringWithFormat:@"%@,%@",strCategoriesIds,[dicCategories objectForKey:Key_Category_ID]];
                            }
                            
                            objArticle.categoryIds = strCategoriesIds;
                        }
                    }
                    
                    if([posts objectForKey:Key_Custom_Fields] != [NSNull null])
                    {
                        //For Subtitle
                        NSDictionary *dicCustomField = [posts objectForKey:Key_Custom_Fields];
                        //NSDictionary *dicCustomField;
                        
                        if(dicCustomField != nil)
                        {
                            if([dicCustomField objectForKey:Key_Custom_SubTitle] != [NSNull null])
                            {
                                NSArray *arrSubTitle = [dicCustomField objectForKey:Key_Custom_SubTitle];
                                if([arrSubTitle count] > 0)
                                    objArticle.subTitle = [arrSubTitle objectAtIndex:0];
                                else
                                    objArticle.subTitle = Blank;
                                
                                if([dicCustomField objectForKey:Key_Custom_Youtube_Video_Id] != [NSNull null])
                                {
                                    NSArray *arrYoutubeVideoId = [dicCustomField objectForKey:Key_Custom_Youtube_Video_Id];
                                    
                                    if([[arrYoutubeVideoId objectAtIndex:0] length] == 11)
                                        objArticle.youtubeVideoID = [arrYoutubeVideoId objectAtIndex:0];
                                    else
                                    {
                                        if([arrYoutubeVideoId count] > 0)
                                            objArticle.youtubeVideoID = [self getYoutubeKey:[arrYoutubeVideoId objectAtIndex:0]];
                                        else
                                            objArticle.youtubeVideoID = Blank;
                                    }
                                }
                                else
                                    objArticle.youtubeVideoID = Blank;
                                
                                //VERY IMPORTANT - Below code is to handlea video case for PARENT PROFILE SUCCESS STORY
                                if(([objArticle.youtubeVideoID length] == 0) && ([dicCustomField objectForKey:Key_Custom_Youtube_Video_Id_PP] != [NSNull null]))
                                {
                                    NSArray *arrYoutubeVideoId = [dicCustomField objectForKey:Key_Custom_Youtube_Video_Id_PP];
                                    
                                    if([[arrYoutubeVideoId objectAtIndex:0] length] == 11)
                                        objArticle.youtubeVideoID = [arrYoutubeVideoId objectAtIndex:0];
                                    else
                                    {
                                        if([arrYoutubeVideoId count] > 0)
                                            objArticle.youtubeVideoID = [self getYoutubeKey:[arrYoutubeVideoId objectAtIndex:0]];
                                        else
                                            objArticle.youtubeVideoID = Blank;
                                    }
                                }
                            }
                            else
                                objArticle.subTitle = @"";
                        }
                    }
                }
                
                //Advertisement details for the detail screen
                if([posts objectForKey:@"dfp_ads"] != [NSNull null])
                {
                    NSDictionary *dicCategories = [posts objectForKey:@"dfp_ads"];
                    if([dicCategories count] > 0)
                    {
                        if([objArticle.categoryType isEqualToString:Key_Adoptable_Kids])
                        {
                            if([posts objectForKey:@"domestic"] != [NSNull null])
                            {
                                NSDictionary *dicDomesticAds = [dicCategories objectForKey:@"domestic"];
                                objArticle.dfpAdUnit = [self appendAdvertisementPrefix:[dicDomesticAds objectForKey:@"ad_unit"]];
                                
                                NSDictionary *dicInternationalAds = [dicCategories objectForKey:@"international"];
                                objArticle.dfpInternationalAdUnit = [self appendAdvertisementPrefix:[dicInternationalAds objectForKey:@"ad_unit"]];
                            }
                            else
                            {
                                objArticle.dfpAdUnit = Blank;
                                objArticle.dfpInternationalAdUnit= Blank;
                            }
                        }
                        else
                        {
                            if([posts objectForKey:@"ad_unit"] != [NSNull null])
                                objArticle.dfpAdUnit = [self appendAdvertisementPrefix:[dicCategories objectForKey:@"ad_unit"]];
                            else
                                objArticle.dfpAdUnit = Blank;
                        }
                    }
                }
                
                if([posts objectForKey:@"dfp_banner"] != [NSNull null])
                {
                    NSDictionary *dicCategories = [posts objectForKey:@"dfp_banner"];
                    
                    if([dicCategories count] > 0)
                    {
                        if([objArticle.categoryType isEqualToString:Key_Adoptable_Kids])
                        {
                            if([posts objectForKey:@"domestic"] != [NSNull null])
                            {
                                NSDictionary *dicDomesticAds = [dicCategories objectForKey:@"domestic"];
                                objArticle.dfpBannerAdUnit = [self appendAdvertisementPrefix:[dicDomesticAds objectForKey:@"ad_unit"]];
                                
                                NSDictionary *dicInternationalAds = [dicCategories objectForKey:@"international"];
                                objArticle.dfpInternationalBannerAdUnit = [self appendAdvertisementPrefix:[dicInternationalAds objectForKey:@"ad_unit"]];
                            }
                            else
                            {
                                objArticle.dfpBannerAdUnit = Blank;
                                objArticle.dfpInternationalBannerAdUnit= Blank;
                            }
                        }
                        else
                        {
                            if([posts objectForKey:@"ad_unit"] != [NSNull null])
                                objArticle.dfpBannerAdUnit = [self appendAdvertisementPrefix:[dicCategories objectForKey:@"ad_unit"]];
                            else
                                objArticle.dfpBannerAdUnit = Blank;
                        }
                    }
                }
                
                if(![objArticle.categoryType isEqualToString:Key_Advertisement])
                {
                    //Adoptable Kid is not upda
                    if([objDBOperations checkArticleExists:objArticle.articleId created:objArticle.date modified:objArticle.modified postType:objArticle.categoryType])
                    {
                        //isModified functionality is commented for testing purpose
                        //BOOL isModified = (![[[Global defaultGlobal] dbArticleCreatedDate] isEqualToString:objArticle.date] || ![[[Global defaultGlobal] dbArticleModifiedDate] isEqualToString:objArticle.modified]);
                        
                        if(([objArticle.categoryType isEqualToString:Key_Adoptable_Kids]))
                        {
                            objArticle.caseId = [objDBOperations getCaseIdForArticle:objArticle.articleId forPost:objArticle.categoryType];
                            
                            [objDBOperations updateArticleWithoutDetails:objArticle.articleId created:objArticle.date modified:objArticle.modified categoryIds:objArticle.categoryIds postType:objArticle.categoryType];
                        }
                        else
                        {
                            //Here we consider article is new and not present in DB, so we save this article to DB
                            NSString *strArticleDetailsJSON =  [[Global defaultGlobal] convertDictionaryToJSON:[objArticle toNSDictionary]];
                            [objDBOperations updateArticle:objArticle.articleId  withDetails:strArticleDetailsJSON created:objArticle.date modified:objArticle.modified categoryIds:objArticle.categoryIds postType:objArticle.categoryType];
                        }
                    }
                    else
                    {
                        if(objArticle.categoryIds == nil || [objArticle.categoryIds isEqual:[NSNull null]])
                        {
                            objArticle.categoryIds = menuCategoryId;
                        }
                        
                        //Here we consider article is new and not present in DB, so we save this article to DB
                        NSString *strArticleDetailsJSON =  [[Global defaultGlobal] convertDictionaryToJSON:[objArticle toNSDictionary]];
                        [objDBOperations addArticle:objArticle.articleId  withDetails:strArticleDetailsJSON created:objArticle.date modified:objArticle.modified categoryIds:objArticle.categoryIds postType:objArticle.categoryType];
                    }
                }
                
                NSLog(@"parseArticleListingData --- end %d",index);
                [arrArticleListing addObject:objArticle];
            }
        }
    }
    
    NSLog(@"--- parseArticleListingData --- end --------------");
    return arrArticleListing;
}

-(NSString*)getYoutubeKey:(NSString *)url
{
    NSString *strYoutubeVideoKey = @"";
    if([url length] > 0)
    {
        if([url hasPrefix:@"http://youtu.be/"])
            strYoutubeVideoKey = [url stringByReplacingOccurrencesOfString:@"http://youtu.be/" withString:@""];
        
        if([url hasPrefix:@"http://www.youtube.com/v/"])
            strYoutubeVideoKey = [url stringByReplacingOccurrencesOfString:@"http://www.youtube.com/v/" withString:@""];
        
        if([url hasPrefix:@"https://www.youtube.com/v/"])
            strYoutubeVideoKey = [url stringByReplacingOccurrencesOfString:@"https://www.youtube.com/v/" withString:@""];
        
        
        if([url hasPrefix:@"http://www.youtube.com/watch?v="])
            strYoutubeVideoKey = [url stringByReplacingOccurrencesOfString:@"http://www.youtube.com/watch?v=" withString:@""];
        
        if([url hasPrefix:@"https://www.youtube.com/watch?v="])
            strYoutubeVideoKey = [url stringByReplacingOccurrencesOfString:@"https://www.youtube.com/watch?v=" withString:@""];
        
        if([strYoutubeVideoKey length] == 0)
            strYoutubeVideoKey = url;
        
        if([strYoutubeVideoKey length] > 11)
        {
            NSArray *arrTemp = [strYoutubeVideoKey componentsSeparatedByString:@"&"];
            strYoutubeVideoKey = [arrTemp objectAtIndex:0];
        }
    }
    return strYoutubeVideoKey;
}

-(NSString*)appendAdvertisementPrefix:(NSString*)strAdUnit
{
    return [NSString stringWithFormat:@"%@%@",Advertisement_Prefix,strAdUnit];
}

-(void)reloadListingView:(NSMutableArray*)arrArticleListing
{
    [arrArticleDetails addObjectsFromArray:arrArticleListing];
    [tblArticleListing reloadData];
    [lblNoArticles setHidden:YES];
    tblArticleListing.tableFooterView = nil;
}

-(void)loadCachedArticleForError
{
    if([arrArticleDetails count] == 0)
    {
        [self loadCachedArticlesForOfflineMode];
    }
}

-(void)loadCachedArticlesForOfflineMode
{
    arrArticleDetails = [[NSMutableArray alloc] init];
    rowIndex = 0;
    if([objDBOperations deleteCacheArticleFromLongDays])
    {
        [self recordEvents:@"Delete 15 days cached contents" action:@"loadCachedArticlesForOfflineMode" label:@"Success" value:nil];
        NSLog(@"Executed Delete cache query sucessfully");
    }
    else
    {
        [self recordEvents:@"Delete 15 days cached contents" action:@"loadCachedArticlesForOfflineMode" label:@"Fail" value:nil];
        NSLog(@"Not Executed Delete cache query");
    }
    
    arrArticleDetails = [objDBOperations getCachedArticles:menuCategoryId];
    if([arrArticleDetails count] == 0)
        [self displayNoPostsAvailble];
    else
        [lblNoArticles setHidden:YES];
    
    tblArticleListing.tableFooterView = nil;
    [tblArticleListing reloadData];
}

- (void)getPostsError:(NSString*)error
{
    [self.refreshControl endRefreshing];
    [activityProgress stopAnimating];
    [activityProgress setHidden:YES];
    lblProcess.hidden = YES;
    [self loadCachedArticleForError];
    [self displayAlertForErrorOccuredWhileConnecting];
    isAsyncCallInProgress = NO;
}

#pragma mark - Image download Delegate

- (void)imageDownloadedSuccessfullyWith:(NSIndexPath*)indexPath
{
    if([tblArticleListing numberOfRowsInSection:0] > indexPath.row)
    {
        NSArray *indexArray = [NSArray arrayWithObjects:indexPath, nil];
        [tblArticleListing reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - Private Methods

-(NSString *) stringByStrippingHTML:(NSString*)strText {
    NSRange r;
    while ((r = [strText rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        strText = [strText stringByReplacingCharactersInRange:r withString:@""];
    return strText;
}

-(void)displayAlertForErrorOccuredWhileConnecting
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Error occured while connecting to server." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

-(void)displayNoPostsAvailble
{
    [lblNoArticles setHidden:NO];
    [self.refreshControl endRefreshing];
    [activityProgress stopAnimating];
    [activityProgress setHidden:YES];
    lblProcess.hidden = YES;
}

-(void)openWebURL:(NSURL *)linkURL withTitle:(NSString*)strTitle withAnalyticsTitle:(NSString*)strAnalyticsTitle
{
    [appDelegate inititalizeReachability];
    if(appDelegate.isInternetConnectionAvailable)
    {
        webViewController = [[SVWebViewController alloc] initWithAddress:[linkURL absoluteString]];
        NSLog(@"Analytics Screen Name - %@",strAnalyticsTitle);
        webViewController.strShareText = strAnalyticsTitle;
        [self.navigationController pushViewController:webViewController animated:YES];
        webViewController.navigationItem.title = strTitle;
        webViewController.navigationController.navigationBar.topItem.title = @"";
    }
    else
    {
        [self handleClickForOfflineMode];
    }
}

-(void)handleClickForOfflineMode
{
    [self showMessage:NSLocalizedString(@"Warning",nil) forMessage:NSLocalizedString(@"NoInternetConn", nil)];
}

-(CGSize)getImageSize:(NSString*)strUrl
{
    NSString *fileName =  [[Global defaultGlobal] getFileName:strUrl];
    
    if([appDelegate  checkFileExists:fileName atDirectory:ArticleImageFolderLocation])
    {
        NSString *dataPath = [NSString stringWithFormat:@"%@/%@",appDelegate.preCacheDirectoryPath,ArticleImageFolderLocation];
        NSString *filePath = [dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
        
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        return image.size;
    }
    
    return CGSizeZero;
}

-(IBAction)handleRightSwipeToOpenArticle:(UIGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint swipeLocation = [gestureRecognizer locationInView:tblArticleListing];
        NSIndexPath *swipedIndexPath = [tblArticleListing indexPathForRowAtPoint:swipeLocation];
        [self loadArticleDetailsScreen:swipedIndexPath.row];
    }
}

-(CGFloat)calculateRowHeight
{
    return 0.0;
}


-(void)loadArticleDetailsScreen:(NSInteger)forRow
{
    //forRow will be -1 if objCurrentArticle is already initialized
    if(forRow != -1)
    {
        objSelectedArticle = [[Article alloc] init];
        objSelectedArticle = (Article*)[arrArticleDetails objectAtIndex:forRow];
    }
    //else
    //    objSelectedArticle = objCurrentArticle;
    
    if((appDelegate.isInternetConnectionAvailable) && [objSelectedArticle.categoryType isEqualToString:Key_Adoptable_Kids] && [objSelectedArticle.isUpdated isEqualToString:@"0"])
    {
        NSLog(@"Adoptable_Kids loading from server");
        [self loadAdoptableKidDetails:objSelectedArticle.childId];
    }
    else if([objSelectedArticle.categoryType isEqualToString:Key_Forum])
    {
        NSLog(@"We have it locally Adoptable_Kids loading from server");
        //NSLog(@"%@",objCurrentArticle.shareArticleURL);
        NSString *strAnalyticsTitle = [NSString stringWithFormat:@"%@ - %@",Forum,objSelectedArticle.title];
        [self openWebURL:[NSURL URLWithString:objSelectedArticle.shareArticleURL] withTitle:Forum withAnalyticsTitle:strAnalyticsTitle];
    }
    else if([objSelectedArticle.categoryType isEqualToString:Key_Parent_Profile])
    {
        //NSLog(@"%@",objSelectedArticle);
        NSString *strAnalyticsTitle = [NSString stringWithFormat:@"%@ - %@",PARENT_PROFILES,objSelectedArticle.title];
        [self openWebURL:[NSURL URLWithString:objSelectedArticle.shareArticleURL] withTitle:PARENT_PROFILES withAnalyticsTitle:strAnalyticsTitle];
    }
    else
    {
        [[iRate sharedInstance] logEvent:NO];
        NSString *strNibFileName = @"ArticleDetailViewController_iPhone";
        if(IS_IPAD)
            strNibFileName = @"ArticleDetailViewController_iPad";
        
        self.navigationItem.title = Blank;
        
        articleDetailViewController = [[ArticleDetailViewController alloc] initWithNibName:strNibFileName bundle:nil];
        articleDetailViewController.objCurrentArticle = objSelectedArticle;
        NSString *imageFolderPath = [NSString stringWithFormat:@"%@/%@",appDelegate.preCacheDirectoryPath,[NSString stringWithFormat:ArticleImageFolderLocation]];
        
        NSString *fileName =  [[Global defaultGlobal] getFileName:objSelectedArticle.thumbnailImage];
        
        NSString *imagePath = [NSString stringWithFormat:@"%@%@",imageFolderPath,fileName];
        UIImage *imgArticleDetail;
        
        //This is to handle the case, where image is not downloaded and also internet connection is not available
        if([[Global defaultGlobal] checkFileExists:imagePath])
            imgArticleDetail = [UIImage imageWithContentsOfFile:imagePath];
        else
            imgArticleDetail = [UIImage imageNamed:@"placeholder.png"];
        
        //NSLog(@"%@",objCurrentArticle.content);
        articleDetailViewController.imgArticle = imgArticleDetail;
        
        if([objSelectedArticle.categoryType isEqualToString:Key_Adoptable_Kids])
            articleDetailViewController.navigationItem.title = @"Adoptable Kids";
        else if([objSelectedArticle.categoryType isEqualToString:ParentProfileSuccessStory])
            articleDetailViewController.navigationItem.title = PARENT_PROFILES;
        else if([objSelectedArticle.articleType isEqualToString:ParentProfileSuccessStory])
            articleDetailViewController.navigationItem.title = PARENT_PROFILES;
        else
            articleDetailViewController.navigationItem.title = objSelectedArticle.articleType;
        
        [self.navigationController pushViewController:articleDetailViewController animated:YES];
    }
}

-(NSString*)getArticleCategoryType:(NSString*)strCategoryName
{
    NSString *strCategory = @"";
    
    if([strCategoryName isEqualToString:ServerArticleTag])
        strCategory = ArticleTag;
    else if([strCategoryName isEqualToString:ServerVideoTag])
        strCategory = VideoTag;
    else if([strCategoryName isEqualToString:ServerSlideshowsTag])
        strCategory = SlideshowsTag;
    else if([strCategoryName isEqualToString:ServerNewsTag])
        strCategory = NewsTag;
    else if([strCategoryName isEqualToString:ServerParentProfileSuccessStory])
        strCategory = ParentProfileSuccessStory;
    
    return strCategory;
}

- (void)showMessage:(NSString*)strTitle forMessage:(NSString*)strMessage {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:strTitle
                                                      message:strMessage
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    [message show];
}

-(void) refreshArticleListing
{
    [appDelegate inititalizeReachability];
    if(appDelegate.isInternetConnectionAvailable)
    {
        [lblNoArticles setHidden:YES];
        
        //This invokes the get category web service call
        ArticleCategoryManager *articleCategory = [ArticleCategoryManager defaultManager];
        articleCategory.delegate = self;
        isAsyncCallInProgress = YES;
        
        if([[[Global defaultGlobal] getUserDefaultValue:Key_Current_Page] integerValue] == 1)
            isFirstServerCall = YES;
        [articleCategory getRecentPosts:[[[Global defaultGlobal] getUserDefaultValue:Key_Current_Page] integerValue] forCategory:lastSelectedCategoryId];
        
        //Initialize color array to match web site color theme if table is reset
        if(shouldTableReset)
            [self initializeRandomColors];
    }
    else
    {
        [[Global defaultGlobal] setUserDefaultValue:@"YES" forKey:Offline_Mode];
        [self loadCachedArticlesForOfflineMode];
        isAsyncCallInProgress = NO;
        [activityProgress stopAnimating];
        [activityProgress setHidden:YES];
        lblProcess.hidden = YES;
        if ([arrArticleDetails count] == 0) {
            [self displayNoPostsAvailble];
        }
        else
        {
            //Initialize color array to match web site color theme if table is reset
            if(shouldTableReset)
                [self initializeRandomColors];
        }
        
        [self.refreshControl endRefreshing];
        [tblArticleListing.infiniteScrollingView stopAnimating];
        
        [self showMessage:NSLocalizedString(@"Warning",nil) forMessage:NSLocalizedString(@"NoInternetConn", nil)];
    }
}

-(void)configureView
{
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"Recent Posts";
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    objDBOperations = [[DBOperations alloc] init];
    isFirstServerCall = NO;
    
    [lblNoArticles setHidden:YES];
    [lblProcess setHidden:YES];
    [activityProgress setHidesWhenStopped:YES];
    isAsyncCallInProgress = NO;
    menuCategoryId = RecentArticle;
    lastSelectedCategoryId = RecentArticle;
    
   
    
    if(IS_IPAD)
    {
        menuViewController = [[MenuViewController alloc] init];
        leftView.hidden = NO;
        menuViewController.view.frame = CGRectMake(leftView.frame.origin.x, leftView.frame.origin.y, leftView.frame.size.width, menuViewController.view.frame.size.height);
        [leftView addSubview:menuViewController.view];
       
        CGRect rightRect = CGRectMake(0, 0, 31, 31);
        self.btnAdoption = [[UIButton alloc] initWithFrame:rightRect];
        [self.btnAdoption setImage:[UIImage imageNamed:@"sidebar_button.png"]
                          forState:UIControlStateNormal];
        self.btnAdoption.contentMode = UIViewContentModeScaleAspectFit;
        [self.btnAdoption addTarget:self
                             action:@selector(showMenu)
                   forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnAdoption];
        self.navigationItem.leftBarButtonItem = backButtonItem;
    }
    else
    {
        CGRect rightRect = CGRectMake(0, 0, 31, 31);
        self.btnAdoption = [[UIButton alloc] initWithFrame:rightRect];
        self.btnAdoption.imageEdgeInsets = UIEdgeInsetsMake(0, 4, 0, -4);
        [self.btnAdoption setImage:[UIImage imageNamed:@"sidebar_button.png"]
                          forState:UIControlStateNormal];
        self.btnAdoption.contentMode = UIViewContentModeScaleAspectFit;
        [self.btnAdoption addTarget:self
                             action:@selector(showMenu)
                   forControlEvents:UIControlEventTouchUpInside];
        
        leftView.hidden = YES;
        CGRect rect = CGRectMake(0, 0, 25, 25);
        self.btnBackHeart = [[UIButton alloc] initWithFrame:rect];
        self.btnBackHeart.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 8);
        self.btnBackHeart.contentMode = UIViewContentModeScaleAspectFill;
        [self.btnBackHeart setImage:[UIImage imageNamed:@"hamburger.png"]
                           forState:UIControlStateNormal];
        [self.btnBackHeart addTarget:(BaseNavigationController *)self.navigationController
                              action:@selector(showMenu)
                    forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnBackHeart];
        self.navigationItem.leftBarButtonItem = backButtonItem;
        
        UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnAdoption];
        self.navigationItem.rightBarButtonItem = rightButtonItem;
        self.navigationItem.hidesBackButton = YES;
    }
    
    tblArticleListing.separatorStyle = UITableViewCellSeparatorStyleNone;
    arrArticleDetails = [[NSMutableArray alloc] init];
    rowIndex = 0;
    objCurrentArticle = [[Article alloc] init];
    
    shouldTableReset = YES;
    
    //if([[Global defaultGlobal] getUserDefaultValue:Key_Current_Page] == 0)
    [[Global defaultGlobal] setUserDefaultValue:@"1" forKey:Key_Current_Page];
    
    if([arrArticleDetails count] == 0)
    {
        [lblProcess setHidden:NO];
        [activityProgress setHidden:NO];
        [activityProgress startAnimating];
    }
    
    if(appDelegate.isIphone4)
    {
        [lblProcess setFrame:CGRectMake(lblProcess.frame.origin.x, lblProcess.frame.origin.y - 40, lblProcess.frame.size.width, lblProcess.frame.size.height)];
        [activityProgress setFrame:CGRectMake(activityProgress.frame.origin.x, activityProgress.frame.origin.y - 40, activityProgress.frame.size.width, activityProgress.frame.size.height)];
    }
    
    [self refreshArticleListing];
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.tblArticleListing;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(reloadFromTop) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = self.refreshControl;
    
    __weak ArticleMasterViewController *weakSelf = self;
    [self.tblArticleListing addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtBottom];
    }];
    
    if([strPageTitle length] > 0)
        self.navigationItem.title = strPageTitle;
    
    if([self.navigationItem.title length] == 0)
        self.navigationItem.title = @"Recent Posts";
    if([self.navigationItem.title length] > 0)
    {
        self.screenName = [NSString stringWithFormat:@"Masonry Listing - %@",self.navigationItem.title];
    }
}

- (void)showMenu
{
    if(IS_IPAD)
        followUsViewController = [[FollowUsViewController alloc] initWithNibName:@"FollowUsViewController_iPad" bundle:nil];
    else
        followUsViewController = [[FollowUsViewController alloc] initWithNibName:@"FollowUsViewController_iPhone" bundle:nil];
   [self.navigationController pushViewController:followUsViewController animated:YES];
}

-(void)reloadFromTop
{
    if(!isAsyncCallInProgress)
    {
        //Below check has been added because of the
        [appDelegate inititalizeReachability];
        if(appDelegate.isInternetConnectionAvailable)
        {
            shouldTableReset = YES;
            [[Global defaultGlobal] setUserDefaultValue:@"1" forKey:Key_Current_Page];
            
            [self recordEvents:self.navigationItem.title action:@"Reload" label:@"Top" value:[NSNumber numberWithInt:1]];
        }
        [self refreshArticleListing];
    }
    else
    {
        [self.refreshControl endRefreshing];
    }
}

-(void)recordEvents:(NSString*)strCategory  action:(NSString *)strAction label:(NSString*)strLabel value:(NSNumber *)value
{
    // May return nil if a tracker has not already been initialized with a property
    // ID.
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:strCategory     // Event category (required)
                                                          action:strAction  // Event action (required)
                                                           label:strLabel          // Event label
                                                           value:value] build]];    // Event value
}

- (void)insertRowAtBottom
{
    if(!isAsyncCallInProgress)
    {
        Article *objTempArticle;//
        if([arrArticleDetails count] > 0)
        {
            objTempArticle = [arrArticleDetails objectAtIndex:[arrArticleDetails count] - 1];
        }
        
        if([objTempArticle.title isEqualToString:No_More_Content_To_Display])
        {
            [tblArticleListing.infiniteScrollingView stopAnimating];
        }
        else
        {
            if([arrArticleDetails count] > 0)
            {
                //This is to avoid repeated articles when user comes from offline to online mode
                [appDelegate inititalizeReachability];
                if((appDelegate.isInternetConnectionAvailable) && [[[Global defaultGlobal] getUserDefaultValue:Offline_Mode] isEqualToString:@"YES"])
                {
                    [[Global defaultGlobal] setUserDefaultValue:@"No" forKey:Offline_Mode];
                    [self reloadFromTop];
                }
                else
                {
                    shouldTableReset = NO;
                    if([[Global defaultGlobal] getUserDefaultValue:Key_Current_Page]  > 0)
                        [self recordEvents:self.navigationItem.title action:@"Reload" label:@"Bottom" value:[NSNumber numberWithInt:[[[Global defaultGlobal] getUserDefaultValue:Key_Current_Page] integerValue]]];
                    [self refreshArticleListing];
                }
            }
        }
    }
    else
    {
        [tblArticleListing.infiniteScrollingView stopAnimating];
    }
}

-(NSAttributedString*)getFromattedTextFromHTML:(NSString*)htmlContent
{
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlContent dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    return attrStr;
}

-(void)initializeRandomColors
{
    //Added by rakesh biradar for romdomize blog color - (Start)
    arrColors = [[NSMutableArray alloc] initWithObjects:[[Global defaultGlobal] getUIColorObjectFromHexString:@"EEB32E" alpha:1],[[Global defaultGlobal] getUIColorObjectFromHexString:@"EE783A" alpha:1],[[Global defaultGlobal] getUIColorObjectFromHexString:@"815077" alpha:1],[[Global defaultGlobal] getUIColorObjectFromHexString:@"7FAF41" alpha:1],[[Global defaultGlobal] getUIColorObjectFromHexString:@"74ADA1" alpha:1],[[Global defaultGlobal] getUIColorObjectFromHexString:@"7DC0D8" alpha:1],[[Global defaultGlobal] getUIColorObjectFromHexString:@"3F86AA" alpha:1], nil];
    
    NSUInteger count = [arrColors count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        int nElements = count - i;
        int n = (arc4random() % nElements) + i;
        [arrColors exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    //Added by rakesh biradar for romdomize blog color - (End)
}

-(UIColor *)getBackgorundColorForRow:(NSInteger)indexRowValue
{
    UIColor *backgroundColor;
    
    if((indexRowValue % 7) == 0)
        backgroundColor = [arrColors objectAtIndex:0];
    else if((indexRowValue % 7) == 1)
        backgroundColor = [arrColors objectAtIndex:1];
    else if((indexRowValue % 7) == 2)
        backgroundColor = [arrColors objectAtIndex:2];
    else if((indexRowValue % 7) == 3)
        backgroundColor = [arrColors objectAtIndex:3];
    else if((indexRowValue % 7) == 4)
        backgroundColor = [arrColors objectAtIndex:4];
    else if((indexRowValue % 7) == 5)
        backgroundColor = [arrColors objectAtIndex:5];
    else if((indexRowValue % 7) == 6)
        backgroundColor = [arrColors objectAtIndex:6];
    
    return backgroundColor;
}

-(AsyncImageView*)downloadImageForRowIndex:(NSInteger)tempRowIndex withImageUrl:(NSString*)strImageURL withImageDirectory:(NSString*)imageDirectoryPath withRect:(CGRect)imgProfilePosition resizeTo:(CGSize)imageSize
{
    NSLog(@"%@",NSStringFromCGRect(imgProfilePosition));
    CGRect localImagePosition = imgProfilePosition;
    
    NSString *imagePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *finalImagePath = [NSString stringWithFormat:@"%@/%@",imagePath,imageDirectoryPath];
    NSError *error;
    if(![[NSFileManager defaultManager] fileExistsAtPath:finalImagePath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:finalImagePath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    NSLog(@"%@",NSStringFromCGRect(imgProfilePosition));
    
    AsyncImageView *asyncImage = [[AsyncImageView alloc] initWithFrame:localImagePosition];
    NSLog(@"%@",NSStringFromCGRect(imgProfilePosition));
    
    asyncImage.imageSize = imageSize;
    asyncImage.pathOfImageTobeSaved = finalImagePath;
    asyncImage.tag = tempRowIndex;
    asyncImage.delegate = self;
    asyncImage.indexPath = [NSIndexPath indexPathForRow:tempRowIndex inSection:0];
    if([strImageURL length] > 0)
    {
        NSString *fileName =  [appDelegate getFileName:strImageURL];
        
        if([appDelegate checkFileExists:fileName atDirectory:imageDirectoryPath])
        {
            [asyncImage setImage:fileName directory:finalImagePath];
        }
        else
        {
            [appDelegate inititalizeReachability];
            if(appDelegate.isInternetConnectionAvailable)
            {
                //here we need to check and
                NSURL *url = [NSURL URLWithString:strImageURL];
                [asyncImage loadImageFromURL:url];
            }
            else
            {
                //make an image view for the image
                UIImageView *placeholderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder.png"]];
                
                //make sizing choices based on your needs, experiment with these. maybe not all the calls below are needed.
                placeholderImageView.contentMode = UIViewContentModeScaleAspectFill;
                placeholderImageView.clipsToBounds = YES;
                [asyncImage addSubview:placeholderImageView];
                placeholderImageView.frame = asyncImage.bounds;
                [placeholderImageView setNeedsLayout];
                [asyncImage setNeedsLayout];
                
                asyncImage.imageView.image = [UIImage imageNamed:@"placeholder.png"];
            }
        }
    }
    else
    {
        asyncImage.imageView.image = [UIImage imageNamed:@"placeholder.png"];
    }
    
    return asyncImage;
}

//Below method is not used because its draining more memory
-(CGSize)getImagePropertiesWithoutLoadingInMemory:(NSString*)strImageUrl
{
    NSURL *imageFileURL = [NSURL fileURLWithPath:strImageUrl];
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((__bridge CFURLRef)imageFileURL, NULL);
    if (imageSource == NULL) {
        // Error loading image
        
        return CGSizeZero;
    }
    
    CGFloat width = 0.0f, height = 0.0f;
    CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL);
    if (imageProperties != NULL) {
        CFNumberRef widthNum  = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
        if (widthNum != NULL) {
            CFNumberGetValue(widthNum, kCFNumberCGFloatType, &width);
        }
        
        CFNumberRef heightNum = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
        if (heightNum != NULL) {
            CFNumberGetValue(heightNum, kCFNumberCGFloatType, &height);
        }
        
        CFRelease(imageProperties);
    }
    
    //NSLog(@"Image dimensions: %.0f x %.0f px", width, height);
    return CGSizeMake(width, height);
}

#pragma mark - Button click event

//For sharekit implementation details refer below URL
//https://github.com/ShareKit/ShareKit/wiki/Installing-sharekit
//https://github.com/ShareKit/ShareKit/wiki/Configuration
///http://abhilashreddykallepu.wordpress.com/2012/10/11/using-sharekit-in-ios/

-(IBAction)shareButtonCliked:(id)sender
{
    [appDelegate inititalizeReachability];
    if(appDelegate.isInternetConnectionAvailable)
    {
        UIButton *btnSender = (UIButton *)sender;
        objCurrentArticle = (Article*)[arrArticleDetails objectAtIndex:btnSender.tag];
        
        CFSharer *googlePlusSharer = [[CFSharer alloc] initWithName:@"Google Plus" imageName:@"google_plus.png"];
        if(!objCurrentArticle.isImageAvailable || ([objCurrentArticle.categoryType isEqualToString:Key_Adoptable_Kids]) || ([objCurrentArticle.categoryType isEqualToString:Key_Parent_Profile]))
            shareCircleView = [[CFShareCircleView alloc] initWithSharers:@[googlePlusSharer, [CFSharer twitter],[CFSharer facebook],[CFSharer mail]]];
        else
            shareCircleView = [[CFShareCircleView alloc] initWithSharers:@[googlePlusSharer, [CFSharer twitter],[CFSharer facebook],[CFSharer pinterest],[CFSharer mail]]];
        
        shareCircleView.delegate = self;
        [shareCircleView showAnimated:YES];
    }
    else
    {
        [self showMessage:NSLocalizedString(@"Warning",nil) forMessage:NSLocalizedString(@"NoInternetConn", nil)];
    }
}

#pragma mark MFMailComposeViewControllerDelegate methods

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif
    
#ifdef DEBUG
    if ((result == MFMailComposeResultFailed) && (error != NULL)) NSLog(@"%@", error);
#endif
    
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark Share Circle View
- (void)shareCircleView:(CFShareCircleView *)shareCircleView didSelectSharer:(CFSharer *)sharer {
    
    NSLog(@"Selected sharer: %@", sharer.name);
    
    NSURL *url = [NSURL URLWithString:objCurrentArticle.shareArticleURL];
    
    //For recording the sharing things in google analytics
    [self recordSocialShare:sharer.name withURL:objCurrentArticle.shareArticleURL];
    
    if([sharer.name isEqualToString:@"Facebook"])
    {
        SHKItem *item = [SHKItem URL:url title:objCurrentArticle.title contentType:SHKURLContentTypeWebpage];
        
        // ShareKit detects top view controller (the one intended to present ShareKit UI) automatically,
        // but sometimes it may not find one. To be safe, set it explicitly
        [SHK setRootViewController:self];
        [SHKiOSFacebook shareItem:item];
    }
    else if([sharer.name isEqualToString:@"Mail"])
    {
        if ([MFMailComposeViewController canSendMail] == NO)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"This device is not able to send mail. Please check your Mail Settings."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
        mailComposer.mailComposeDelegate = self;
        //[controller setToRecipients:[NSArray arrayWithObject:@"rakesh@elevati.com"]];
        [mailComposer setSubject:objCurrentArticle.title];
        [mailComposer setMessageBody:[NSString stringWithFormat:@"%@\n%@",objCurrentArticle.title,objCurrentArticle.shareArticleURL] isHTML:NO];
        mailComposer.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        mailComposer.modalPresentationStyle = UIModalPresentationFormSheet;
        
        mailComposer.mailComposeDelegate = self; // Set the delegate
        
        [self presentModalViewController:mailComposer animated:YES];
    }
    else if([sharer.name isEqualToString:@"Twitter"])
    {
        SHKItem *item = [SHKItem URL:url title:objCurrentArticle.title contentType:SHKURLContentTypeWebpage];
        [SHK setRootViewController:self];
        [SHKiOSTwitter shareItem:item];
    }
    else if([sharer.name isEqualToString:@"Google Plus"])
    {
        SHKItem *item = [SHKItem URL:url title:objCurrentArticle.title contentType:SHKURLContentTypeWebpage];
        [SHK setRootViewController:self];
        [SHKGooglePlus shareItem:item];
    }
    else if([sharer.name isEqualToString:@"Pinterest"])
    {
        NSString *fileName =  [[Global defaultGlobal] getFileName:objCurrentArticle.thumbnailImage];
        NSString *imageFolderPath = [NSString stringWithFormat:@"%@/%@",appDelegate.preCacheDirectoryPath,[NSString stringWithFormat:ArticleImageFolderLocation]];
        
        NSString *imagePath = [NSString stringWithFormat:@"%@%@",imageFolderPath,fileName];
        UIImage *imgArticleDetail;
        
        //This is to handle the case, where image is not downloaded and also internet connection is not available
        if([[Global defaultGlobal] checkFileExists:imagePath])
            imgArticleDetail = [UIImage imageWithContentsOfFile:imagePath];
        
        SHKItem *item = [SHKItem image:imgArticleDetail title:objCurrentArticle.subTitle];
        item.URLPictureURI = [NSURL URLWithString:objCurrentArticle.thumbnailImage];
        
        [SHK setRootViewController:self];
        [SHKPinterest shareItem:item];
    }
}

-(void)recordSocialShare:(NSString *)strShareNetwork withURL:(NSString*)targetUrl
{
    // May return nil if a tracker has not already been initialized with a property
    // ID.
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createSocialWithNetwork:strShareNetwork action:@"Share" target:targetUrl] build]];
    
}

- (void)shareCircleCanceled:(NSNotification *)notification{
    NSLog(@"Share circle view was canceled.");
}

@end
