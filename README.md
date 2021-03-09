# PodcastPlayer
[![Build Status](https://travis-ci.org/joeyliu7975/PodcastPlayer.svg?branch=main)](https://travis-ci.org/joeyliu7975/PodcastPlayer)

## Episode Feed Feature Specs (Homepage)

### Narrative#1
```
As a podcast audioence
I want the app to automatically load the lastest podcast epiosde
So I can always enjoy the newest feed of the channel
```

### Scenarios
```
Given the audioence has connectivity
 When the audioence requests to see the channel feed
 Then the app should display the latest feed from remote
```

## Use cases

### Load Episode Feed From Remote Use Case

#### Data:
* URL

#### Primary Course( happy path ):
1. Execute ‘func load’ and with data above. 
2. System download data with URL
3. System validates downloading data
4. System creates channel feed for validate data
5. System deliver channel feed

#### Invalid Data( sad path ):
System delivers invalidate data error
#### No Connectivity( sad path ):
System delivers connectivity error

***

## Flowchart
<img src="https://i.postimg.cc/26wHQjpg/Screen-Shot-2021-03-08-at-11-55-12-PM.png" alt="" width="350" height = "550" align="center" />


## Model Specs

### Channel Feed

|  Property  |  Type       |
| ---------- | :-----------:
|  ```profileImage```  |  ```URL(optional)```       |
|  ```episodes```  |  ```[Episode]```       |

### Episode

|  Property  |  Type       |
| ---------- | :-----------:
|  ```coverImage```  |  ```URL(optional)```       |
|  ```title```  |  ```String(optional)```       |
|  ```description```  |  ```String```       |
|  ```releaseDate```  |  ```String```       |
|  ```soundURL```  |  ```URL(optional)```       |


### Example
```
<channel>
        <image>
            <url>https://i1.sndcdn.com/avatars-000326154119-ogb1ma-original.jpg</url>
        </image>
        <item>
            <guid isPermaLink="false">tag:soundcloud,2010:tracks/1000284829</guid>
            <title>Ep. 135 流動的資金盛宴</title>
            <pubDate>Sun, 07 Mar 2021 22:00:12 +0000</pubDate>
            <description>現代金融理論加上現代科技，解放資本，將所有人捲入投資市場。人們有更多資訊、投資對象，以及比較的對象。就像手機讓人們滑臉書欲罷不能，閒不下來；科技也讓人們追逐投資報酬率，無法接受資本「閒置」。看似更有效率的市場背後，是更大的風險。

主題文章：博弈、科技與投資自己之必要
https://bit.ly/2MSu8Qk
首月一元訂閱，即可看網站全文
bit.ly/37Yi4D4</description>
            <enclosure type="audio/mpeg" url="https://feeds.soundcloud.com/stream/1000284829-daodutech-podcast-a-liquid-feast-of-capital.mp3" length="60557439"/>
            <itunes:image href="https://i1.sndcdn.com/artworks-Z7zJRFuDjv63KCHv-5W8whA-t3000x3000.jpg"/>
        </item>
```


## Episode Page Specs (Episode Page)

### Narrative#1
```
As a podcast audioence
I want to look into selected episode's description
So I can learn more about the topic and project
```

## Use cases

### Display episode detail
#### Data: 
* array of ```Episode```
* ```Int```

#### Primary Course( happy path ):

1.Load episode
2.```Kingfisher``` load episode coverImage with URL
3.Render UI component with episode

#### ```Episode``` property contains valid value ( sad path ):
System delivers invalid data error
#### Cover image’s URL couldn’t load ( sad path ):
```Kingfisher``` displays placeholder on UIImageView

***


### Transfer to player page and start to play audio

#### Primary Course( happy path ):
Transfer to player page

***

## Player

### Narrative

```
As an audience who already peruse episode's summary
Finally decided to listen to the content
The app should be able to let me play the podcast
```

## Use cases

### Load Sound URL

#### Data:
* URL ``` https://xxx.sound.mp3 ```

#### Primary Course( happy path ):
1.AVPlayerItem load url, and the url is valid
2.AVPlayerItem is ready to play
3.AVPlayer play the audio

#### The url is invlid ( sad path ):
System doesn't play the audio

***

### Play Audio

#### Primary Course( happy path ):
1.AVPlayerItem is ready to play
2.AVPlayer play the audio

#### The AVPlayerItem is not ready( sad path ):
System doesn't play the audio

***

### Pause Audio

#### Primary Course( happy path ):
1. AVPlayerItem is ready to play
2. AVPlayer pause the audio

#### The AVPlayerItem is not ready( sad path ):
System currently doesnt' do anything about it

***

### Switch to Next/Previous Episode

#### Data:
* Input:
  ```[Episode]```, Int
* Output:
  ```Result<( Episode, URL), Error>```
#### Primary Course( happy path ):
1.Execute ‘func loadEpisode’ 
2.PlayerModel retrieve episode and URL for Controller
3.Render interface with episode
4.AudioPlayer load sound URL
5.AVPlayerItem is read to play
6.AVPlayer start to play

#### Index out of range ( sad path ):
System delivers index out of range error

#### Sound URL is missing ( sad path ):
System delivers sound URL is missing error

***

### Manipulate episode with Slider

#### Data:
* Double

#### Default configuration for AVPlayerManager:
```
public final class AVPlayerManager {
    private var player:AVPlayer?
    
    private var timeObserver: Any?
        
    private var isSeekInProgress = false
    
    private var chaseTime: CMTime = .zero
```

#### Primary Course( happy path ):
1. AVPlayer currentItem's duration is not nil
2. Convert slider value to total second
3. Convert sldier value, the process is shown as below:
```
if let duration = player?.currentItem?.duration {
            let totalSecond = CMTimeGetSeconds(duration)
            
            let value = (sliderValue) * Float(totalSecond)
            
            let seekTime = CMTime(value: CMTimeValue(value), timescale: 1)
           }
```

4. Execute ```func stopPlayingAndSeekSmoothlyToTime(newChaseTime:)``` 
5. Pause AVPlayer
6.  Compare ```currentChaseTime``` with ```newChaseTime```
```
if CMTimeCompare(newChaseTime, chaseTime) != 0 {
            chaseTime = newChaseTime
            
            if !isSeekInProgress {
                trySeekToChaseTime()
            }
        }
```

7. Check statement ```isSeekInProgress```
```
if !isSeekInProgress {
                trySeekToChaseTime()
            }
```

8. Check AVPlayer currentItem's status.
```
if status == .unknown {
            // wait until item becomes ready
        } else if status == .readyToPlay {
            actuallySeekToTime()
        }
```

9. ```isSeekInProgress = true```
10. ```let seekTimeInProgress = chaseTime```
11. Execute ```AVPlayer.seekseek(to: seekTimeInProgress, toleranceBefore: .zero, toleranceAfter: .zero, completion:)```
12. Execute ```CMTimeCompare(seekTimeInProgress, self.chaseTime)```
13. 
```
if CMTimeCompare(seekTimeInProgress, self.chaseTime) == 0 {
                self.isSeekInProgress = false
            } else {
                self.trySeekToChaseTime()
            }
```

14. notify PlayerViewController to update

***


