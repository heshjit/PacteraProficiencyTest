//
//  Feed.h
//  PacteraProficiencyTest
//
//  Created by Developer on 20/09/2015.
//  Copyright (c) 2015 Learning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Feed : NSObject

@property (nonatomic, copy) NSString *feedTitle;
@property (nonatomic, copy) NSString *feedDescription;
@property (nonatomic, copy) NSString *feedImageURL;
@property (nonatomic, strong) UIImage *feedImage;

-(id) initFeedWithDictionary:(NSDictionary*)feedDictionary;

@end
