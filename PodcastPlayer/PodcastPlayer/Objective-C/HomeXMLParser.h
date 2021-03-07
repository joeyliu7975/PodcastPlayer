//
//  EpisodeHomeItem.h
//  PodcastPlayer
//
//  Created by Joey Liu on 3/5/21.
//

#import <Foundation/Foundation.h>
#import "EpisodeFeedItem.h"

typedef NS_ENUM(NSInteger, State) {
    none,
    title,
    pubDate,
    myLink,
    image,
    protifleImage,
    description
};


NS_ASSUME_NONNULL_BEGIN

@interface HomeXMLParser: NSObject <NSXMLParserDelegate>

@property ChannelFeed *channelFeed;
@property State state;
@property Episode *episode;
@property (nonatomic, nullable) NSString *imageURLStr;

//初始化 property 的地方:
-(instancetype)initWithDefaultValue:(ChannelFeed*)channel
                                    state:(State)state;

//MARK: Protocol 之外的function:

// #1:  private func parse(data: Data) throws -> ChannelFeed
- (ChannelFeed * _Nullable)parse:(NSData*)data error:(NSError**)error;
@end
NS_ASSUME_NONNULL_END
