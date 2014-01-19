//
//  PTLCollectionViewController.m
//  LayoutDemo
//
//  Created by Brian Partridge on 1/14/14.
//  Copyright (c) 2014 Pear Tree Labs. All rights reserved.
//

#import "PTLCollectionViewController.h"
#import "PTLCollectionViewCell.h"
#import "UIKit+PTLDatasource.h"

static NSString * const kCellId = @"Cell";

@interface PTLCollectionViewController () <PTLDatasourceObserver>

@property (nonatomic, strong) UIStepper *stepper;

@property (nonatomic, strong) PTLIndexDatasource *datasource;
@property (nonatomic, assign) NSUInteger datasourceUpdateCount;
@property (nonatomic, strong) NSMutableArray *datasourceChanges;

@end

@implementation PTLCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.title = @"Layout";

    self.collectionView.backgroundColor = [UIColor colorWithRed:0.200 green:0.558 blue:0.686 alpha:1.000];

    [self.collectionView registerNib:[UINib nibWithNibName:@"PTLCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kCellId];

    self.datasource = [[PTLIndexDatasource alloc] initWithIndecies:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 10)]];
    self.datasource.collectionViewCellIdentifier = kCellId;
    self.datasource.collectionViewCellConfigBlock = ^(UICollectionView *collectionView, UICollectionViewCell *cell, id item, NSIndexPath *indexPath) {
        PTLCollectionViewCell *aCell = (PTLCollectionViewCell *)cell;
        aCell.titleLabel.text = [NSString stringWithFormat:@"%@", item];
    };
    self.collectionView.dataSource = self.datasource;
    [self.datasource addChangeObserver:self];

    UIStepper *stepper = [[UIStepper alloc] init];
    stepper.value = self.datasource.numberOfItems;
    stepper.maximumValue = NSIntegerMax;
    [stepper addTarget:self action:@selector(countChanged:) forControlEvents:UIControlEventValueChanged];
    self.stepper = stepper;
    UIBarButtonItem *counter = [[UIBarButtonItem alloc] initWithCustomView:stepper];
    self.navigationItem.rightBarButtonItem = counter;
}

#pragma mark - Data Helpers

- (NSUInteger)lastIndexValue {
    id item = [self.datasource.allItems lastObject];
    return (item) ? [item unsignedIntegerValue] : NSNotFound;
}

- (NSUInteger)nextIndexValue {
    NSUInteger index = [self lastIndexValue];
    return (index == NSNotFound) ? 0 : ++index;
}

#pragma mark - User Interaction

- (void)countChanged:(UIStepper *)stepper {
    NSInteger newValue = stepper.value;
    if (newValue < self.datasource.numberOfItems) {
        [self.datasource removeIndexValue:[self lastIndexValue]];
    } else {
        [self.datasource addIndexValue:[self nextIndexValue]];
    }
    stepper.value = self.datasource.numberOfItems;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    id item = [self.datasource itemAtIndexPath:indexPath];
    [self.datasource removeIndexValue:[item unsignedIntegerValue]];

    // Update the stepper value accordingly
    self.stepper.value = self.datasource.numberOfItems;
}

#pragma mark - PTLDatasourceObserver

- (void)datasourceWillChange:(id<PTLDatasource>)datasource {
    self.datasourceUpdateCount++;
    if (self.datasourceUpdateCount == 1) {
        self.datasourceChanges = [NSMutableArray array];
    }
}

- (void)datasourceDidChange:(id<PTLDatasource>)datasource {
    self.datasourceUpdateCount--;
    if (self.datasourceUpdateCount != 0) {
        return;
    }

    [self.collectionView performBatchUpdates:^{
        for (NSDictionary *dict in self.datasourceChanges) {
            PTLChangeType change = [dict[@"change"] integerValue];
            if ([dict[@"isSectionChange"] boolValue]) {
                NSUInteger sectionIndex = [dict[@"sectionIndex"] integerValue];
                switch(change) {
                    case PTLChangeTypeInsert:
                        [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
                        break;
                    case PTLChangeTypeRemove:
                        [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
                        break;
                    default:
                        break;
                }
            } else {
                NSIndexPath *indexPath = dict[@"indexPath"];
                NSIndexPath *newIndexPath = dict[@"newIndexPath"];
                switch(change) {
                    case PTLChangeTypeInsert:
                        [self.collectionView insertItemsAtIndexPaths:@[newIndexPath]];
                        break;
                    case PTLChangeTypeRemove:
                        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
                        break;
                    case PTLChangeTypeUpdate:
                        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                        break;
                    case PTLChangeTypeMove:
                        [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];
                        break;
                }
            }
        }
        self.datasourceChanges = nil;
    } completion:nil];
}

- (void)datasource:(id<PTLDatasource>)datasource didChange:(PTLChangeType)change atIndexPath:(NSIndexPath *)indexPath newIndexPath:(NSIndexPath *)newIndexPath {
    [self.datasourceChanges addObject:@{ @"change" : @(change),
                                         @"indexPath" : indexPath ?: [NSNull null],
                                         @"newIndexPath" : newIndexPath ?: [NSNull null] }];
}

- (void)datasource:(id<PTLDatasource>)datasource didChange:(PTLChangeType)change atSectionIndex:(NSInteger)sectionIndex {
    [self.datasourceChanges addObject:@{ @"change" : @(change),
                                         @"isSectionChange" : @YES,
                                         @"sectionIndex" : @(sectionIndex) }];
}

@end
