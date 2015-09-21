//
//  Feed.m
//  PacteraProficiencyTest
//
//  Created by Developer on 20/09/2015.
//  Copyright (c) 2015 Learning. All rights reserved.
//

#import "FeedList.h"
#import "Feed.h"

static NSString* const kTitle = @"title";
static NSString* const kFeedKey = @"rows";

@implementation FeedList

-(id)init{
    self = [super init];
    if (self) {
        _feedArray = [[NSMutableArray alloc]init];
        _mainTitle = @"MainTitle";
    }
    return self;
}



-(id) initWithJSONData:(NSDictionary *)jsonDictionary{
    self = [super init];
    if (self) {
        _mainTitle = [jsonDictionary objectForKey:kTitle];
        NSArray *array = [jsonDictionary objectForKey:kFeedKey];
        self.feedArray = [NSMutableArray array];
        
        for (NSDictionary *dict in array) {
            Feed *feed = [[Feed alloc]initFeedWithDictionary:dict];
            [self.feedArray addObject:feed];
        }
        
    }
    return self;
}

@end
