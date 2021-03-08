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

##### Primary Course( happy path ):
1. Execute ‘func load’ and with data above. 
2. System download data with URL
3. System validates downloading data
4. System creates channel feed for validate data
5. System deliver channel feed

##### Invalid Data( sad path ):
System delivers invalidate data error
##### No Connectivity( sad path ):
System delivers connectivity error

## Flowchart
<img src="https://i.postimg.cc/26wHQjpg/Screen-Shot-2021-03-08-at-11-55-12-PM.png" alt="" width="450" height = "650" align="center" />
