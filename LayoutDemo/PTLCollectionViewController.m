//
//  PTLCollectionViewController.m
//  LayoutDemo
//
//  Created by Brian Partridge on 1/14/14.
//  Copyright (c) 2014 Pear Tree Labs. All rights reserved.
//

#import "PTLCollectionViewController.h"
#import "PTLCollectionViewCell.h"

static NSString * const kCellId = @"Cell";

@interface PTLCollectionViewController ()

@property (nonatomic, assign) NSInteger count;

@end

@implementation PTLCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.title = @"Layout";
    self.count = 10;
    self.collectionView.backgroundColor = [UIColor colorWithRed:0.200 green:0.558 blue:0.686 alpha:1.000];

    [self.collectionView registerNib:[UINib nibWithNibName:@"PTLCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kCellId];

    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTapped:)];
    self.navigationItem.rightBarButtonItem = add;

    UIStepper *stepper = [[UIStepper alloc] init];
    stepper.value = self.count;
    [stepper addTarget:self action:@selector(countChanged:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *counter = [[UIBarButtonItem alloc] initWithCustomView:stepper];
    self.navigationItem.rightBarButtonItem = counter;
}

#pragma mark - User Interaction

- (void)addTapped:(id)sender {
    self.count++;
    [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.count-1 inSection:0]]];
}

- (void)countChanged:(UIStepper *)stepper {
    NSInteger newValue = stepper.value;
    if (newValue < self.count) {
        self.count = newValue;
        [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:newValue inSection:0]]];
    } else {
        self.count = newValue;
        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.count-1 inSection:0]]];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PTLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellId forIndexPath:indexPath];
    cell.titleLabel.text = [NSString stringWithFormat:@"%d", indexPath.item];
    return cell;
}

@end
