//
//  CMViewController.m
//  CLMInfiniteCollectionViewExample
//
//  Created by Andrew Hulsizer on 2/20/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "CMViewController.h"
#import "CLMInfinteGridLayout.h"
#import "CMCollectionViewCell.h"
#import "CLMInfiniteCollectionView.h"
#import <QuartzCore/QuartzCore.h>

@interface CMViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) CLMInfiniteCollectionView *collectionView;
@property (nonatomic, strong) CLMInfinteGridLayout *layout;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat check;

@property (nonatomic, strong) NSMutableArray *colors;
@end

//Random Color Generator
float randomColor(float percent)
{
    return (rand()%255)/255.0f;
}


@implementation CMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
	
	[self setupLayout];
	[self setupCollectionView];
	[self setupColorDictionary];

}

- (void)setupLayout
{
	//Setup Layout
    self.layout = [[CLMInfinteGridLayout alloc] init];
	//self.layout.itemSize = CGSizeMake(708, 300);
    self.layout.numberOfRows = 10;
	self.layout.numberOfColumns = 8;
	self.layout.padding = CGSizeMake(8, 8);
}

- (void)setupCollectionView
{
	//Setup Collection View
    self.collectionView = [[CLMInfiniteCollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:self.layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
	[self.collectionView setShowsHorizontalScrollIndicator:NO];
	[self.collectionView setShowsVerticalScrollIndicator:NO];
    [self.collectionView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
    [self.collectionView registerClass:[CMCollectionViewCell class]
            forCellWithReuseIdentifier:@"ID"];
	
    [self.view addSubview:self.collectionView];
}

- (void)setupColorDictionary
{
	//set up color dictionary
	self.colors = [[NSMutableArray alloc] init];
	for (int i = 0; i < (self.layout.numberOfRows*self.layout.numberOfColumns); i++)
	{
		[self.colors addObject:[UIColor colorWithRed:randomColor(0) green:randomColor(0) blue:randomColor(0) alpha:1]];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	
	//start at mid way
	[self.collectionView setContentOffset:CGPointMake(self.collectionView.contentSize.width/2.0, self.collectionView.contentSize.height/2.0)];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return (self.layout.numberOfRows*self.layout.numberOfColumns);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CMCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ID" forIndexPath:indexPath];
	cell.backgroundColor = [self.colors objectAtIndex:indexPath.item];
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.collectionView.collectionViewLayout invalidateLayout];
}
@end
