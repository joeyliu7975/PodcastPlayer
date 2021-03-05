//
//  AudibleProtocol.h
//  PodcastPlayer
//
//  Created by Joey Liu on 3/5/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PlayPauseProtocol <NSObject>
    -(void)play;
    -(void)pause;
@end

@protocol EpisodeProgressTracking <NSObject>
    -(void)updatEpisodeCurrentDurationWith:(float)value;
@end

@protocol EpisodeSoundLoader <NSObject>
    -(void)loadWith:(NSURL)url;
@end

NS_ASSUME_NONNULL_END
