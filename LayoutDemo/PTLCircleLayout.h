//
//  PTLCircleLayout.h
//  LayoutDemo
//
//  Created by Brian Partridge on 1/14/14.
//  Copyright (c) 2014 Pear Tree Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PTLCircleLayoutAnimation) {
    PTLCircleLayoutAnimationNone,
    PTLCircleLayoutAnimationCenter,
    PTLCircleLayoutAnimationPop,
};

@interface PTLCircleLayout : UICollectionViewLayout

/**
 * The angle, in radians where the circle starts.
 * @default -M_PI / 2.0 (aka: -90° or 12 o'clock)
 */
@property (nonatomic, assign) CGFloat startingAngle;

/**
 * The size of each cell in the circle.
 * @default 50x50
 */
@property (nonatomic, assign) CGSize itemSize;

/**
 * The animation to use when presenting inserted cells.
 * @default PTLCircleLayoutAnimationCenter
 */
@property (nonatomic, assign) PTLCircleLayoutAnimation insertionAnimation;

/**
 * The animation to use when removing deleted cells.
 * @default PTLCircleLayoutAnimationCenter
 */
@property (nonatomic, assign) PTLCircleLayoutAnimation deletionAnimation;

@end
