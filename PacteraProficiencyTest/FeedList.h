//
//  Feed.h
//  PacteraProficiencyTest
//
//  Created by Developer on 20/09/2015.
//  Copyright (c) 2015 Learning. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FeedList : NSObject
@property (nonatomic,strong) NSMutableArray *feedArray;
@property (nonatomic,strong) NSString *mainTitle;


-(id) initWithJSONData: (NSDictionary*) jsonDictionary;
@end
