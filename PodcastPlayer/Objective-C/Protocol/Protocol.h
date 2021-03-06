//
//  Protocol.h
//  PodcastPlayer
//
//  Created by Joey Liu on 3/7/21.
//

#import <Foundation/Foundation.h>
#import "EpisodeFeedItem.h"

typedef ChannelFeed Feed;

#ifndef Protocol_h
#define Protocol_h


#endif /* Protocol_h */

@protocol FeedMapper
    -(Feed *)map:(NSData *) data:(NSHTTPURLResponse *) response:(NSError **)error;
@end

//AVPlayerController
@protocol PlayPauseProtocol
    -(void)play;
    -(void)pause;
    -(void)resetPlayer;
@property (nonatomic, nullable)void(^loadingFailed)();
@property (nonatomic, nullable)void(^notifyPlayerStatus)(BOOL);

@end
//
@protocol EpisodeProgressTracking
@property (nonatomic, nullable)void(^trackDuration)(float);
- (void)updateCurrentDurationWith:(float)sliderValue;
@end
//
@protocol EpisodeSoundLoader
    -(void) loadWith:(NSURL *)url;
@property (nonatomic, nullable)void(^playNextProject)(void);
@end


