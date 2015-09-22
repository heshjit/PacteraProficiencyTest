//
//  Feed.m
//  PacteraProficiencyTest
//
//  Created by Developer on 20/09/2015.
//  Copyright (c) 2015 Learning. All rights reserved.
//

#import "Feed.h"

#define NIL_OR_NSNull(obj) (obj == nil || obj == (id)[NSNull null])

static NSString* const kTitle=@"title";
static NSString* const kDescription=@"description";
static NSString* const kImageHref=@"imageHref";

@implementation Feed

-(id)init{
    self = [super init];
    if (self) {
        _feedTitle=kTitle;
        _feedDescription=kDescription;
        _feedImageURL=kImageHref;
    }
    return self;
}

-(id) initFeedWithDictionary:(NSDictionary *)feedDictionary{
    self = [super init];
    if (self) {
        _feedTitle = [[feedDictionary objectForKey: kTitle] copy];
        if (NIL_OR_NSNull(_feedTitle)) {
            _feedTitle = @"No Title";
        }
        _feedDescription = [[feedDictionary objectForKey:kDescription]copy];
        if (NIL_OR_NSNull(_feedDescription)) {
            _feedDescription = @"No Description";
        }
        _feedImageURL = [[feedDictionary objectForKey:kImageHref]copy];
        if (NIL_OR_NSNull(_feedImageURL)) {
            _feedImageURL = @"No Image URL";
        }
    }
    return self;
}

-(void)dealloc{   
    [_feedTitle release];
    [_feedDescription release];
    [_feedImageURL release];
    //[_feedImage release];
    [super dealloc];
}

@end
