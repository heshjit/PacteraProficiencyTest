//
//  FeedTableCellsTableViewCell.h
//  PacteraProficiencyTest
//
//  Created by Developer on 20/09/2015.
//  Copyright (c) 2015 Learning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feed.h"

@interface FeedTableCellsTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *feedImage;
@property (nonatomic, strong) NSLayoutConstraint *feedImageWidthConstraint;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier feed:(Feed *) feed;
- (void) configureCell: (Feed *) feed;
@end
