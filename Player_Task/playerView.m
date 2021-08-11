//
//  playerView.m
//  Player_Task
//
//  Created by 赵运泽 on 2021/8/2.
//

#import "playerView.h"
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@implementation playerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(AVPlayer*)player{
    return  self.playerlayer.player;
}
-(void)setPlayer:(AVPlayer *)player{
    self.playerlayer.player=player;
}
+(Class) layerClass{
    return [AVPlayerLayer class];
}
-(AVPlayerLayer*) playerlayer{
    return (AVPlayerLayer*) self.layer;
}

@end
