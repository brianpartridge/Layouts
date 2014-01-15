//
//  PTLCollectionViewCell.m
//  LayoutDemo
//
//  Created by Brian Partridge on 1/14/14.
//  Copyright (c) 2014 Pear Tree Labs. All rights reserved.
//

#import "PTLCollectionViewCell.h"

@implementation PTLCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 1;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
