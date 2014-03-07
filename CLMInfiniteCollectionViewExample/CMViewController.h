//
//  CMViewController.h
//  CLMInfiniteCollectionViewExample
//
//  Created by Andrew Hulsizer on 2/20/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLMInfiniteCollectionView.h"

@interface CMViewController : UIViewController

@property (weak, nonatomic) IBOutlet CLMInfiniteCollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segRows;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segCols;

- (IBAction)segRowsChanged:(id)sender;
- (IBAction)segColsChanged:(id)sender;

@end
