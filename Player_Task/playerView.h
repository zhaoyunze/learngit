//
//  playerView.h
//  Player_Task
//
//  Created by 赵运泽 on 2021/8/2.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface playerView : UIView
@property AVPlayer* player;
@property (readonly) AVPlayerLayer *playerlayer;
@end

NS_ASSUME_NONNULL_END
