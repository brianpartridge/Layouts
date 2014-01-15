//
//  UICollectionViewLayout+Layouts.m
//  LayoutDemo
//
//  Created by Brian Partridge on 1/14/14.
//  Copyright (c) 2014 Pear Tree Labs. All rights reserved.
//

#import "UICollectionViewLayout+Layouts.h"

@implementation UICollectionViewLayout (Layouts)

+ (UICollectionViewFlowLayout *)defaultLayout {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(50, 50);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    return layout;
}

@end
