//
//  LHCustomCell.h
//  Lifehacks
//
//  Created by Asep Bagja on 9/25/12.
//  Copyright (c) 2012 Milk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgMemberIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblMemberName;
@property (weak, nonatomic) IBOutlet UILabel *lblConstituencyName;
@property (weak, nonatomic) IBOutlet UILabel *lblMoreSubTitle;

@end
