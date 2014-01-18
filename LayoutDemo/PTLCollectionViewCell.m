//
//  PTLCollectionViewCell.m
//  LayoutDemo
//
//  Created by Brian Partridge on 1/14/14.
//  Copyright (c) 2014 Pear Tree Labs. All rights reserved.
//

#import "PTLCollectionViewCell.h"

@implementation PTLCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
	    [self commonInit];
	}

	return self;
}

- (void)commonInit {
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 1;
}

@end
