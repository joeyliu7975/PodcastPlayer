//
//  EpisodeFeedItem.h
//  PodcastPlayer
//
//  Created by Joey Liu on 3/7/21.
//

#import<Foundation/Foundation.h>
//#ifndef EpisodeHomeFeedItem_h
//#define EpisodeHomeFeedItem_h

@interface Episode: NSObject

@property (nonatomic, copy)NSURL *coverImage;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *releaseDate;
@property (nonatomic, copy)NSURL *soundURL;

-(instancetype)initWith;
@end

@interface ChannelFeed: NSObject
@property (nonatomic)NSArray * episodes;
@property (nonatomic, copy)NSURL *profileImage;

-(instancetype)initWith;

@end

#ifndef EpisodeFeedItem_h
#define EpisodeFeedItem_h


#endif /* EpisodeFeedItem_h */

