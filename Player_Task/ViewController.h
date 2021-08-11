//
//  ViewController.h
//  Player_Task
//
//  Created by 赵运泽 on 2021/8/2.
//

#import <UIKit/UIKit.h>
#import "playerView.h"

@interface ViewController : UIViewController
@property (readonly) AVPlayer *player;
@property AVURLAsset *asset;
@property (weak, nonatomic) IBOutlet UIButton *videoList;
@property CMTime currentTime;
@property (readonly) CMTime duration;
@property float rate;
-(void) setByStr: (NSString*)str;
@property (nonatomic,copy) NSString* videoID;
@property (nonatomic) NSInteger videoNo;
@property (weak) IBOutlet UISlider *timeSlider;
@property (weak) IBOutlet UILabel *startTimeLabel;
@property (weak) IBOutlet UILabel *durationLabel;
@property (weak) IBOutlet UIButton *rewindButton;
@property (weak) IBOutlet UIButton *playPauseButton;
@property (weak) IBOutlet UIButton *nextButton;
@property (weak) IBOutlet UIButton *fastForwardButton;
@property (weak) IBOutlet playerView *playerView;
@property (weak, nonatomic) IBOutlet UIButton *PreButton;


@end

