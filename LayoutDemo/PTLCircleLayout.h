//
//  PTLCircleLayout.h
//  LayoutDemo
//
//  Created by Brian Partridge on 1/14/14.
//  Copyright (c) 2014 Pear Tree Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTLCircleLayout : UICollectionViewLayout

@property (nonatomic, assign) CGFloat startingAngle; // In radians
@property (nonatomic, assign) CGSize itemSize;

@end
