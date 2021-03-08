//
//  EpisodeFeedItem.m
//  PodcastPlayer
//
//  Created by Joey Liu on 3/7/21.
//

#import <Foundation/Foundation.h>

#import "EpisodeFeedItem.h"

@implementation Episode

-(instancetype)initWith {
    self = [super init];
    
    if(self) {
        _title = @"";
        _releaseDate = @"";
        _content = @"";
        _coverImage = nil;
        _soundURL = nil;
    }
    return self;
}
@end

@implementation ChannelFeed

-(instancetype)initWith {
    self = [super init];
    
    if(self) {
        _episodes = [[NSMutableArray alloc]init];
        _profileImage = nil;
    }
    return self;
}

@end


