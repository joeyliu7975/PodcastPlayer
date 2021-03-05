//
//  EpisodeHomeItem.h
//  PodcastPlayer
//
//  Created by Joey Liu on 3/5/21.
//

#import <Foundation/Foundation.h>

typedef struct {
    NSURL *coverImage;
    NSString *title = [NSString stringWithString:@""];
    NSString *description = [NSString stringWithString:@""];
    NSString *releaseDate = [NSString stringWithString:@""];
    NSURL *soundURL;
} Episode;

typedef struct {
    NSMutableArray<Episode> *episodes = [[NSMutableArray alloc] init];
    NSURL *profileImage;
} ChannelFeed;

NS_ASSUME_NONNULL_BEGIN
NS_ASSUME_NONNULL_END
