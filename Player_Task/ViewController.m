//
//  ViewController.m
//  Player_Task
//
//  Created by 赵运泽 on 2021/8/2.
//

#import "ViewController.h"
#import "playerView.h"
@import Foundation;
@import AVFoundation;
@import CoreMedia.CMTime;
@interface ViewController (){
    AVPlayer *_player;
    AVURLAsset *_asset;
    NSMutableArray *files ;
    NSString*_videoID;
    id<NSObject> _timeObserverToken;
    AVPlayerItem *_playerItem;
    NSInteger _videoNo;
}
@property AVPlayerItem *playerItem;

@property (readonly) AVPlayerLayer *playerLayer;
@end

@implementation ViewController

- (IBAction)NextButtonWasClicked {
    if(_videoNo<files.count-1)
    {
        _videoNo += 1;
        _videoID=files[_videoNo];
        NSLog(@"the change one is:%@",files[_videoNo+1]);
        [self setByStr:_videoID];
    }
}
static int AAPLPlayerViewControllerKVOContext = 0;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

  
    [self addObserver:self forKeyPath:@"asset" options:NSKeyValueObservingOptionNew context:&AAPLPlayerViewControllerKVOContext];
    [self addObserver:self forKeyPath:@"videoID" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:&AAPLPlayerViewControllerKVOContext];
    [self addObserver:self forKeyPath:@"player.currentItem.duration" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:&AAPLPlayerViewControllerKVOContext];
    [self addObserver:self forKeyPath:@"player.rate" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:&AAPLPlayerViewControllerKVOContext];
    [self addObserver:self forKeyPath:@"player.currentItem.status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:&AAPLPlayerViewControllerKVOContext];
    
    NSString *BASE_PATH  = [NSBundle mainBundle].bundlePath;
    NSFileManager *myFileManager = [NSFileManager defaultManager];
        NSDirectoryEnumerator *myDirectoryEnumerator = [myFileManager enumeratorAtPath:BASE_PATH];
    //新建数组，存放各个文件路径
        files = [[NSMutableArray alloc] init];
        //遍历目录迭代器，获取各个文件路径
        NSString *filename;
        while (filename = [myDirectoryEnumerator nextObject]) {
            if ([[filename pathExtension] isEqualToString:@"mp4"] || [[filename pathExtension] isEqualToString:@"m4a"] || [[filename pathExtension] isEqualToString:@"mov"] || [[filename pathExtension] isEqualToString:@"m4v"]) {//筛选出文件后缀名是htm的文件
                [files addObject:filename];
            }
        }
    [self setByStr:_videoID];
}
-(void) setByStr:(NSString *)str{
    self.playerView.playerlayer.player = self.player;

    NSURL *movieURL = [[NSBundle mainBundle] URLForResource:[_videoID stringByDeletingPathExtension] withExtension:[_videoID pathExtension]];
    
    self.asset = [AVURLAsset assetWithURL:movieURL];
   
    ViewController __weak *weakSelf = self;
    _timeObserverToken = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:
        ^(CMTime time) {
            weakSelf.timeSlider.value = CMTimeGetSeconds(time);
        }];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    if (_timeObserverToken) {
        [self.player removeTimeObserver:_timeObserverToken];
        _timeObserverToken = nil;
    }

    [self.player pause];

    [self removeObserver:self forKeyPath:@"asset" context:&AAPLPlayerViewControllerKVOContext];
    [self removeObserver:self forKeyPath:@"videoID" context:&AAPLPlayerViewControllerKVOContext];
    [self removeObserver:self forKeyPath:@"player.currentItem.duration" context:&AAPLPlayerViewControllerKVOContext];
    [self removeObserver:self forKeyPath:@"player.rate" context:&AAPLPlayerViewControllerKVOContext];
    [self removeObserver:self forKeyPath:@"player.currentItem.status" context:&AAPLPlayerViewControllerKVOContext];
}

+ (NSArray *)assetKeysRequiredToPlay {
    return @[ @"playable", @"hasProtectedContent" ];
}

- (AVPlayer *)player {
    if (!_player)
        _player = [[AVPlayer alloc] init];
    return _player;
}

- (CMTime)currentTime {
    return self.player.currentTime;
}
- (void)setCurrentTime:(CMTime)newCurrentTime {
    [self.player seekToTime:newCurrentTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (CMTime)duration {
    return self.player.currentItem ? self.player.currentItem.duration : kCMTimeZero;
}

- (float)rate {
    return self.player.rate;
}
- (void)setRate:(float)newRate {
    self.player.rate = newRate;
}

- (AVPlayerLayer *)playerLayer {
    return self.playerView.playerlayer;
}

- (AVPlayerItem *)playerItem {
    return _playerItem;
}

- (void)setPlayerItem:(AVPlayerItem *)newPlayerItem {
    if (_playerItem != newPlayerItem) {

        _playerItem = newPlayerItem;
    
        [self.player replaceCurrentItemWithPlayerItem:_playerItem];
    }
}

- (IBAction)prebuttonWasPressed {
    if(_videoNo>0)
    {
        _videoNo -= 1;
        _videoID=files[_videoNo];
        NSLog(@"the change one is:%@",files[_videoNo+1]);
        [self setByStr:_videoID];
        
    }
}

- (void)asynchronouslyLoadURLAsset:(AVURLAsset *)newAsset {

  
    [newAsset loadValuesAsynchronouslyForKeys:ViewController.assetKeysRequiredToPlay completionHandler:^{

        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (newAsset != self.asset) {
               
                return;
            }
        
            for (NSString *key in self.class.assetKeysRequiredToPlay) {
                NSError *error = nil;
                if ([newAsset statusOfValueForKey:key error:&error] == AVKeyValueStatusFailed) {

                    NSString *message = [NSString localizedStringWithFormat:NSLocalizedString(@"error.asset_key_%@_failed.description", @"Can't use this AVAsset because one of it's keys failed to load"), key];

                    [self handleErrorWithMessage:message error:error];

                    return;
                }
            }

           
            if (!newAsset.playable || newAsset.hasProtectedContent) {
                NSString *message = NSLocalizedString(@"error.asset_not_playable.description", @"Can't use this AVAsset because it isn't playable or has protected content");

                [self handleErrorWithMessage:message error:nil];

                return;
            }

          
            self.playerItem = [AVPlayerItem playerItemWithAsset:newAsset];
        });
    }];
}

- (IBAction)playPauseButtonWasPressed:(UIButton *)sender {
    if (self.player.rate != 1.0) {
      
        if (CMTIME_COMPARE_INLINE(self.currentTime, ==, self.duration)) {
        
            self.currentTime = kCMTimeZero;
        }
        [self.player play];
    } else {

        [self.player pause];
    }
}

- (IBAction)rewindButtonWasPressed:(UIButton *)sender {
    self.rate = MAX(self.player.rate - 2.0, -2.0);
}

- (IBAction)fastForwardButtonWasPressed:(UIButton *)sender {
    self.rate = MIN(self.player.rate + 2.0, 2.0);
}

- (IBAction)timeSliderDidChange:(UISlider *)sender {
    self.currentTime = CMTimeMakeWithSeconds(sender.value, 1000);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    if (context != &AAPLPlayerViewControllerKVOContext) {

        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }

    if ([keyPath isEqualToString:@"asset"]) {
        if (self.asset) {
            [self asynchronouslyLoadURLAsset:self.asset];
        }
    }
    else if ([keyPath isEqualToString:@"videoID"]) {
        if (self.videoID) {
            [self setByStr:_videoID];
            NSLog(@"%@",_videoID);
        }
        else{
            NSLog(@"no hing aaaaa!");
        }
    }
    else if ([keyPath isEqualToString:@"player.currentItem.duration"]) {

       
        NSValue *newDurationAsValue = change[NSKeyValueChangeNewKey];
        CMTime newDuration = [newDurationAsValue isKindOfClass:[NSValue class]] ? newDurationAsValue.CMTimeValue : kCMTimeZero;
        BOOL hasValidDuration = CMTIME_IS_NUMERIC(newDuration) && newDuration.value != 0;
        double newDurationSeconds = hasValidDuration ? CMTimeGetSeconds(newDuration) : 0.0;

        self.timeSlider.maximumValue = newDurationSeconds;
        self.timeSlider.value = hasValidDuration ? CMTimeGetSeconds(self.currentTime) : 0.0;
        self.rewindButton.enabled = hasValidDuration;
        self.playPauseButton.enabled = hasValidDuration;
        self.fastForwardButton.enabled = hasValidDuration;
        self.timeSlider.enabled = hasValidDuration;
        self.startTimeLabel.enabled = hasValidDuration;
        self.durationLabel.enabled = hasValidDuration;
        int wholeMinutes = (int)trunc(newDurationSeconds / 60);
        self.durationLabel.text = [NSString stringWithFormat:@"%d:%02d", wholeMinutes, (int)trunc(newDurationSeconds) - wholeMinutes * 60];

    }
    else if ([keyPath isEqualToString:@"player.rate"]) {
    
        double newRate = [change[NSKeyValueChangeNewKey] doubleValue];
        UIImage *buttonImage = (newRate == 1.0) ? [UIImage imageNamed:@"PauseButton"] : [UIImage imageNamed:@"PlayButton"];
        [self.playPauseButton setImage:buttonImage forState:UIControlStateNormal];

    }
    else if ([keyPath isEqualToString:@"player.currentItem.status"]) {
       
        NSNumber *newStatusAsNumber = change[NSKeyValueChangeNewKey];
        AVPlayerItemStatus newStatus = [newStatusAsNumber isKindOfClass:[NSNumber class]] ? newStatusAsNumber.integerValue : AVPlayerItemStatusUnknown;
        
        if (newStatus == AVPlayerItemStatusFailed) {
            [self handleErrorWithMessage:self.player.currentItem.error.localizedDescription error:self.player.currentItem.error];
        }

    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    if ([key isEqualToString:@"duration"]) {
        return [NSSet setWithArray:@[ @"player.currentItem.duration" ]];
    } else if ([key isEqualToString:@"currentTime"]) {
        return [NSSet setWithArray:@[ @"player.currentItem.currentTime" ]];
    } else if ([key isEqualToString:@"rate"]) {
        return [NSSet setWithArray:@[ @"player.rate" ]];
    } else {
        return [super keyPathsForValuesAffectingValueForKey:key];
    }
}

- (void)handleErrorWithMessage:(NSString *)message error:(NSError *)error {
    NSLog(@"Error occured with message: %@, error: %@.", message, error);

    NSString *alertTitle = NSLocalizedString(@"alert.error.title", @"Alert title for errors");
    NSString *defaultAlertMesssage = NSLocalizedString(@"error.default.description", @"Default error message when no NSError provided");
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:alertTitle message:message ?: defaultAlertMesssage preferredStyle:UIAlertControllerStyleAlert];

    NSString *alertActionTitle = NSLocalizedString(@"alert.error.actions.OK", @"OK on error alert");
    UIAlertAction *action = [UIAlertAction actionWithTitle:alertActionTitle style:UIAlertActionStyleDefault handler:nil];
    [controller addAction:action];

    [self presentViewController:controller animated:YES completion:nil];
}

@end

