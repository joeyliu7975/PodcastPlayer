//
//  AudibleProtocol.h
//  PodcastPlayer
//
//  Created by Joey Liu on 3/5/21.
//

#import <Foundation/Foundation.h>
#import <AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PlayPauseProtocol <NSObject>
    -(void)play;
    -(void)pause;
@end

@protocol EpisodeProgressTracking <NSObject>
    -(void)updatEpisodeCurrentDurationWith:(float)value;
@end

@protocol EpisodeSoundLoader <NSObject>
    -(void)loadWith:(NSURL *)url;
@end

@interface AudioPlayer: NSObject

@property (strong, nonatomic) id *timeObserver;
@property (strong, nonatomic) BOOL *isSeekInProgress;

@property (strong, nonatomic) AVPlayerItem.Status *playerCurrentItemStatus;

@property (strong, nonatomic) CMTime *chaseTime;

@property (nonatomic, copy) void (^trackDuration)((float,float));

@property (nonatomic, copy) void (^playNextEP)(void);

@property (nonatomic, copy) void(^updateProgress)(BOOL);

- (void)resetPlayer:void;

@end
NS_ASSUME_NONNULL_END
