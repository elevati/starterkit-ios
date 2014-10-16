//
//  MasterViewController.h
//  iOS-StarterKit
//
//  Created by Rakesh B on 15/09/14.
//  Copyright (c) 2014 Elevati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+SVInfiniteScrolling.h"
#import "MBProgressHUD.h"
#import "MemberCell.h"
#import "MemberManager.h"
#import "Member.h"
#import "GAITrackedViewController.h"

@class DetailViewController;

@interface MasterViewController : GAITrackedViewController<MemberManagerDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) MemberCell *cell;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) IBOutlet UITableView *tblMemberListing;
@property (strong, nonatomic) MemberManager *objMemberManager;

@property (strong, nonatomic) Member *objMember;
@property (strong, nonatomic) NSMutableArray *arrMemberDetails;

@end
