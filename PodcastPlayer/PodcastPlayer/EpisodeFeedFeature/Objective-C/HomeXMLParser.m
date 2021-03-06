//
//  EpisodeHomeParser.m
//  PodcastPlayer
//
//  Created by Joey Liu on 3/6/21.
//

#import <Foundation/Foundation.h>
#import "HomeXMLParser.h"
#include <stdlib.h>

@implementation HomeXMLParser
    
-(instancetype)initWithDefaultValue:(ChannelFeed)channel:(State)state {
    self = [super init];
    if(self){
        self.channelFeed = &(channel);
        self.state = state;
    }
    return self;
}

@end
