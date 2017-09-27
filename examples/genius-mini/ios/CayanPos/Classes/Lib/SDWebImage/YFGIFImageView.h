//
//  YFGIFImageView.h
//  UIImageView-PlayGIF
//
//  Created by Yang Fei on 14-3-26.
//  Copyright (c) 2014 yangfei.me. All rights reserved.
//

/*******************************************************
 *  Dependencies:
 *      - QuartzCore.framework
 *      - ImageIO.framework
 *  Parameters:
 *      Pass value to one of them:
 *      - gifData NSData from a GIF
 *      - gifPath local path of a GIF
 *  Usage:
 *      - startGIF
 *      - stopGIF
 *      - isGIFPlaying
 *  P.S.:
 *      Need category? Use UIImageView+PlayGIF.h/m
 *******************************************************/

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <ImageIO/ImageIO.h>

@interface YFGIFImageView : UIImageView
@property (nonatomic, strong) NSString          *gifPath;
@property (nonatomic, strong) NSData            *gifData;
- (void)startGIF;
- (void)stopGIF;
- (BOOL)isGIFPlaying;
@end
