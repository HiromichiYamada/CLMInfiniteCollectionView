//
// CLMInfiniteCollectionView.m
// CLMInfiniteCollectionViewExample
//
// Created by Andrew Hulsizer on 3/24/13.
// Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "CLMInfiniteCollectionView.h"
#import "CLMInfinteGridLayout.h"

@interface CLMInfiniteCollectionView ()

@end

@implementation CLMInfiniteCollectionView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
        
    }
    return self;
}

// recenter content periodically to achieve impression of infinite scrolling
- (void)recenterIfNecessary
{
    CGPoint currentOffset = [self contentOffset];
	
	if (CGPointEqualToPoint(currentOffset, CGPointZero))
	{
		return;
	}
	
    CGFloat contentWidth = [self contentSize].width;
    CGFloat contentHeight = [self contentSize].height;
    CGFloat centerOffsetX = (contentWidth/2.0) - (self.bounds.size.width/2.0);
    CGFloat centerOffsetY = (contentHeight/2.0) - (self.bounds.size.height/2.0);
    CGFloat distanceFromCenterX = fabs(currentOffset.x - centerOffsetX);
    CGFloat distanceFromCenterY = fabs(currentOffset.y - centerOffsetY);
    
    if (distanceFromCenterX > (contentWidth / 4.0))
	{
		self.contentOffset = CGPointMake(centerOffsetX, self.contentOffset.y);
		
		NSAssert([self.collectionViewLayout isKindOfClass:[CLMInfinteGridLayout class]], @"Layout must be of type CLMInfiniteGridLayout");
		
        CLMInfinteGridLayout *layout = (CLMInfinteGridLayout*)self.collectionViewLayout;
		NSInteger newX = (currentOffset.x - centerOffsetX);
		
		
        layout.contentShift = CGPointMake(layout.contentShift.x + newX,layout.contentShift.y);
	}
	
	if (distanceFromCenterY > (contentHeight/ 4.0))
	{
		self.contentOffset = CGPointMake(self.contentOffset.x, centerOffsetY);
		
		NSAssert([self.collectionViewLayout isKindOfClass:[CLMInfinteGridLayout class]], @"Layout must be of type CLMInfiniteGridLayout");
		
        CLMInfinteGridLayout *layout = (CLMInfinteGridLayout*)self.collectionViewLayout;
		NSInteger newY = (currentOffset.y - centerOffsetY);
        layout.contentShift = CGPointMake(layout.contentShift.x,layout.contentShift.y + newY);
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
	[self recenterIfNecessary];
}

@end
