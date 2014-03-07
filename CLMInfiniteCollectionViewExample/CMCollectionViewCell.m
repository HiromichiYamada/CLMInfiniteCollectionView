//
//  CMCollectionViewCell.m
//  CLMInfiniteCollectionViewExample
//
//  Created by Andrew Hulsizer on 2/20/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "CMCollectionViewCell.h"


@implementation CMCollectionViewCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect  frameLabel  = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        _label  = [[UILabel alloc] initWithFrame:frameLabel];
        _label.textAlignment    = NSTextAlignmentCenter;
        _label.text = @"default";
        [self addSubview:_label];
    }
    return self;
}

@end
