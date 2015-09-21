//
//  FeedTableCellsTableViewCell.m
//  PacteraProficiencyTest
//
//  Created by Developer on 20/09/2015.
//  Copyright (c) 2015 Learning. All rights reserved.
//

#import "FeedTableCellsTableViewCell.h"

@interface FeedTableCellsTableViewCell ()

@property (nonatomic, strong) UILabel *feedTitleLabel;
@property (nonatomic, strong) UILabel *feedDetailLabel;

@end

@implementation FeedTableCellsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier feed:(Feed *) feed {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _feedTitleLabel = [[UILabel alloc] init];
        [_feedTitleLabel setTextColor:[UIColor blackColor]];
        [_feedTitleLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [_feedTitleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_feedTitleLabel setTextColor:[UIColor blueColor]];
        [self.contentView addSubview:_feedTitleLabel];
        
        _feedDetailLabel = [[UILabel alloc] init];
        [_feedDetailLabel setTextColor:[UIColor blackColor]];
        [_feedDetailLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_feedDetailLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_feedDetailLabel setNumberOfLines:0];
        [self.contentView addSubview:_feedDetailLabel];
        
        if (feed.feedImageURL.length > 0) {
            _feedImage = [[UIImageView alloc] init];
            _feedImage.contentMode = UIViewContentModeScaleAspectFit;
            [_feedImage setTranslatesAutoresizingMaskIntoConstraints:NO];
            [_feedImage setImage:[UIImage imageNamed:@"default-placeholder"]];
            [self.contentView addSubview:_feedImage];
        }
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self updateCellConstraintsForFact:feed];
    }
    
    return self;
}

- (void) configureCell: (Feed *) feed {
    self.feedTitleLabel.text = feed.feedTitle;
    self.feedDetailLabel.text = feed.feedDescription;
    
    [self layoutIfNeeded];
    
    CGFloat y = CGRectGetMaxY(self.feedDetailLabel.frame);
    
    if (y < 60) { // Default case: cell height should be equivant to image height
        y = 60;
    }
    self.height = y + 10;
}

- (void)setHeight:(CGFloat)newHeight
{
    CGRect frameRect = [self.contentView frame];
    frameRect.size.height = newHeight;
    [self.contentView setFrame:frameRect];
}

- (void) updateCellConstraintsForFact:(Feed *) feed {
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_feedTitleLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1
                                                                  constant:10]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_feedTitleLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTopMargin
                                                                multiplier:.5
                                                                  constant:10]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_feedDetailLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_feedTitleLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1
                                                                  constant:10]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_feedDetailLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_feedTitleLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1
                                                                  constant:0]];
    
    if (feed.feedImageURL.length > 0) {
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_feedDetailLabel
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_feedImage
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1
                                                                      constant:-5]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_feedImage
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1
                                                                      constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_feedImage
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1
                                                                      constant:-10]];
        self.feedImageWidthConstraint = [NSLayoutConstraint constraintWithItem:_feedImage
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1
                                                                      constant:60];
        [self.contentView addConstraint:self.feedImageWidthConstraint];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_feedImage
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1
                                                                      constant:60]];
    } else {
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_feedDetailLabel
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1
                                                                      constant:0]];
    }
    [self layoutIfNeeded];
}

@end
