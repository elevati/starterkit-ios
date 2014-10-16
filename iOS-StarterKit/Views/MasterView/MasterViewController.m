//
//  MasterViewController.m
//  iOS-StarterKit
//
//  Created by Rakesh B on 15/09/14.
//  Copyright (c) 2014 Elevati. All rights reserved.
//

#import "MasterViewController.h"

@implementation MasterViewController
@synthesize cell = cell;
@synthesize tblMemberListing = tblMemberListing;
@synthesize objMemberManager = objMemberManager;
@synthesize objMember = objMember;
@synthesize arrMemberDetails = arrMemberDetails;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self cofigureView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Registering the screen name for google analytics
    self.screenName = [NSString stringWithFormat:@"Member Screen"];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrMemberDetails count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(cell == nil) {
        if(IS_IPAD)
            [tableView registerNib:[UINib nibWithNibName:iPadMemberCell bundle:nil] forCellReuseIdentifier:MemberCell1];
        else
            [tableView registerNib:[UINib nibWithNibName:iPhoneMemberCell bundle:nil] forCellReuseIdentifier:MemberCell1];
    }
    objMember = [[Member alloc] init];
    objMember = [arrMemberDetails objectAtIndex:indexPath.row];
    
    cell = (MemberCell *)[tableView dequeueReusableCellWithIdentifier:MemberCell1];
    
    [cell.lblMemberName setText:objMember.memberName];
    [cell.lblMoreSubTitle setText:objMember.memberParty];
    [cell.lblConstituencyName setText:objMember.constituencyName];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(IS_IPAD)
        return 132;
    else
        return 110;
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)getMemberDetailsSuccessfullyWith:(NSMutableArray*)arrMembers
{
    arrMemberDetails = [[NSMutableArray alloc] init];
    
    if ([arrMembers count] > 0) {
        [self parseMemberListing:arrMembers completionHandler:^(NSMutableArray *arrFinalList){
            NSLog(@"Member details parsed");
            arrMemberDetails = arrFinalList;
            [tblMemberListing reloadData];
            [self.refreshControl endRefreshing];
        }];
    } else {
        NSLog(@"No records to parse");
    }
}

- (void)getMemberDetailsError:(NSString*)error
{
    NSLog(@"Error - %@",[error description]);
}

- (void)parseMemberListing:(NSMutableArray *)arrArticleList completionHandler:(void (^)(NSMutableArray *events))completionHandler
{
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(backgroundQueue, ^{
        NSMutableArray *mutable = [self parseMemberListing:arrArticleList];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler([mutable copy]);
        });
    });
}

-(NSMutableArray*)parseMemberListing:(NSMutableArray*)arrMembers
{
    NSMutableArray *arrParsedMembers = [[NSMutableArray alloc] init];
    
    for(int index = 0; index < [arrMembers count]; index++)
    {
        NSDictionary *dicMemberDetails = [arrMembers objectAtIndex:index];
        objMember = [[Member alloc] init];
        
        if ([dicMemberDetails objectForKey:@"constituency_name"] != (id)[NSNull null] || [[dicMemberDetails objectForKey:@"constituency_name"] length] != 0)
            objMember.constituencyName = [dicMemberDetails objectForKey:@"constituency_name"];
        else
            objMember.constituencyName = @"";
        
        if ([dicMemberDetails objectForKey:@"member_name"] != (id)[NSNull null] || [[dicMemberDetails objectForKey:@"member_name"] length] != 0)
            objMember.memberName = [dicMemberDetails objectForKey:@"member_name"];
        else
            objMember.memberName = @"";
       
        if ([dicMemberDetails objectForKey:@"member_party"] != (id)[NSNull null] || [[dicMemberDetails objectForKey:@"member_party"] length] != 0)
            objMember.memberParty = [dicMemberDetails objectForKey:@"member_party"];
        else
            objMember.memberParty = @"";
        [arrParsedMembers addObject:objMember];
        
        /*
            Alternate to this is we can use ORM. Below code stores the data in database
         */
        
        NSManagedObjectContext *context = [self managedObjectContext];
        
        // Create a new managed object
        NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Member" inManagedObjectContext:context];
        [newDevice setValue:objMember.memberName forKey:@"memberName"];
        [newDevice setValue:objMember.memberParty forKey:@"memberParty"];
        [newDevice setValue:objMember.constituencyName forKey:@"constituencyName"];
        
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
    }
    
    return arrParsedMembers;
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

-(void)cofigureView
{
    if(objMemberManager == nil)
    {
        objMemberManager = [[MemberManager alloc] init];
        objMemberManager.delegate = self;
    }
    
    objMember = [[Member alloc] init];
    arrMemberDetails = [[NSMutableArray alloc] init];
    
    self.navigationItem.title = @"Members";
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.tblMemberListing;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(reloadFromTop) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = self.refreshControl;
    
    [objMemberManager getMemberDetails];
}


-(void)reloadFromTop
{
    [objMemberManager getMemberDetails];
}

@end
