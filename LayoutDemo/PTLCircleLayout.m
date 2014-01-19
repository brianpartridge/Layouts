//
//  PTLCircleLayout.m
//  LayoutDemo
//
//  Created by Brian Partridge on 1/14/14.
//  Copyright (c) 2014 Pear Tree Labs. All rights reserved.
//

#import "PTLCircleLayout.h"

#define DegreesToRadians(degrees) (degrees * M_PI / 180.0)
#define RadiansToDegrees(radians) (radians * 180.0 / M_PI)

@interface PTLCircleLayout ()

@property (nonatomic, assign) CGPoint circleCenter;
@property (nonatomic, assign) CGFloat circleRadius;

@property (nonatomic, strong) NSMutableArray *deleteIndexPaths;
@property (nonatomic, strong) NSMutableArray *insertIndexPaths;

@end

@implementation PTLCircleLayout

#pragma mark - Lifecycle

- (id)init {
	self = [super init];
	if (self) {
        self.startingAngle = -M_PI / 2.0;
        self.itemSize = CGSizeMake(50, 50);
	}

	return self;
}

- (void)prepareLayout {
    [super prepareLayout];

    self.circleCenter = CGPointMake(CGRectGetMidX(self.collectionView.bounds),
                                    CGRectGetMidY(self.collectionView.bounds));
    CGFloat smallestDimension = MIN(self.collectionView.bounds.size.width - self.itemSize.width,
                                    self.collectionView.bounds.size.height - self.itemSize.height);
    self.circleRadius = smallestDimension / 2.0;
}

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems {
    [super prepareForCollectionViewUpdates:updateItems];

    self.deleteIndexPaths = [NSMutableArray array];
    self.insertIndexPaths = [NSMutableArray array];

    for (UICollectionViewUpdateItem *updateItem in updateItems) {
        switch (updateItem.updateAction) {
            case UICollectionUpdateActionDelete:
                [self.deleteIndexPaths addObject:updateItem.indexPathBeforeUpdate];
                break;
            case UICollectionUpdateActionInsert:
                [self.insertIndexPaths addObject:updateItem.indexPathAfterUpdate];
                break;
            default:
                break;
        }
    }
}

- (void)finalizeCollectionViewUpdates {
    [super finalizeCollectionViewUpdates];

    self.deleteIndexPaths = nil;
    self.insertIndexPaths = nil;
}

#pragma mark - Required Overrides

- (CGSize)collectionViewContentSize {
    return self.collectionView.bounds.size;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSUInteger count = [self.collectionView numberOfItemsInSection:0];
    NSMutableArray *attrs = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [attrs addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    return [attrs copy];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attr.size = self.itemSize;

    NSUInteger count = [self.collectionView numberOfItemsInSection:0];
    if (indexPath.item == 0 &&
        count == 1) {
        attr.center = self.circleCenter;
    } else {
        CGFloat percentage = 1.0 * indexPath.item / count;
        CGFloat angle = self.startingAngle + percentage * 2 * M_PI;

        attr.center = CGPointMake(self.circleCenter.x + self.circleRadius * cos(angle),
                                  self.circleCenter.y + self.circleRadius * sin(angle));
    }

    attr.transform = CGAffineTransformIdentity;

    return attr;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    CGRect oldBounds = self.collectionView.bounds;
    return !CGRectEqualToRect(oldBounds, newBounds);
}

#pragma mark - Animations

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attr = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];

    if ([self.insertIndexPaths containsObject:itemIndexPath]) {
        if (attr == nil) {
            attr = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
        }
        attr.center = self.circleCenter;
        attr.transform = CGAffineTransformMakeScale(0.001, 0.001);
    }

    return attr;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attr = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];

    if ([self.deleteIndexPaths containsObject:itemIndexPath]) {
        if (attr == nil) {
            attr = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
        }
        attr.center = self.circleCenter;
        attr.transform = CGAffineTransformMakeScale(0.001, 0.001);
    }

    return attr;
}

@end
