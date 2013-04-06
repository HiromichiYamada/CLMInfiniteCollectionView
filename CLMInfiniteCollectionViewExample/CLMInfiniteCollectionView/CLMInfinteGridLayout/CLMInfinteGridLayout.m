//
// CLMInfinteGridLayout.m
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

#import "CLMInfinteGridLayout.h"
#define GRID_SIZE_MULTIPLER 6

@interface CLMInfinteGridLayout ()

@property (nonatomic, strong) NSDictionary *layoutInfo;
@property (nonatomic, assign) CGSize halfItemSize;
@end

@implementation CLMInfinteGridLayout

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.edgeInsets = UIEdgeInsetsZero;
    self.itemSize = CGSizeMake(50.0f, 50.0f);
	self.halfItemSize = CGSizeMake(self.itemSize.width/2, self.itemSize.height/2);
    self.padding = CGSizeZero;
    self.numberOfColumns = 0;
    self.numberOfRows = 0;
}

- (CGPoint)currentOffset
{
	return CGPointMake(self.collectionView.contentOffset.x+(self.collectionView.bounds.size.width/2.0)+self.contentShift.x,self.collectionView.contentOffset.y+self.contentShift.y+(self.collectionView.bounds.size.height/2.0)) ;
}

- (CGPoint)getOffsetIndex
{
	CGPoint offset = [self currentOffset];
	
	NSInteger offsetRow = (((int)(offset.y)/((int)(self.itemSize.height+self.padding.height))));
    NSInteger offsetColumn = (((int)(offset.x)/((int)(self.itemSize.width+self.padding.width))));
	return CGPointMake(offsetColumn,offsetRow);
}

- (CGPoint)getCurrentIndex
{
	CGPoint offset = [self currentOffset];
	
	NSInteger offsetRow = (((int)(offset.y)/((int)(self.itemSize.height+self.padding.height)))) % self.numberOfRows;
    NSInteger offsetColumn = (((int)(offset.x)/((int)(self.itemSize.width+self.padding.width)))) % self.numberOfColumns;
	return CGPointMake(offsetColumn,offsetRow);
}

- (NSInteger)bound:(NSInteger)number within:(NSInteger)ceil
{
	while (number >= ceil)
	{
		number = number-ceil;
	}
	
	while (number < 0)
	{
		number += ceil;
	}
	
	return number;
}

- (NSInteger)shiftX:(NSInteger)x by:(NSInteger)shift
{
	x += shift;
	x = [self bound:x within:self.numberOfColumns];
	return x;
}

- (NSInteger)shiftY:(NSInteger)y by:(NSInteger)shift
{
	y += shift;
	y = [self bound:y within:self.numberOfRows];
	return y;
}

- (CGPoint)getDifferenceFromCurrentIndex:(CGPoint)index
{
	CGPoint currentIndex = [self getCurrentIndex];
	
	CGPoint shift = CGPointMake((self.numberOfColumns/2)-currentIndex.x,(self.numberOfRows/2)-currentIndex.y);
	NSInteger newX = [self shiftX:index.x by:shift.x];
	NSInteger newY = [self shiftY:index.y by:shift.y];
	
	return CGPointMake(newX-(self.numberOfColumns/2), newY-(self.numberOfRows/2));
}

- (CGRect)frameForIndexPath:(NSIndexPath*)indexPath
{
    NSInteger row = indexPath.item / self.numberOfColumns;
    NSInteger column = indexPath.item % self.numberOfColumns;
    
	CGPoint differenceColumnRow = [self getDifferenceFromCurrentIndex:CGPointMake(column,row)];
	CGPoint currentColumnRow = [self getOffsetIndex];
	
	
    CGSize itemSizeWithPadding = CGSizeMake((self.itemSize.width + self.padding.width), (self.itemSize.height + self.padding.height));
	
	//Even rows get offset by half the item size
	NSInteger differenceRow = row%2;
	
    CGFloat originX = (itemSizeWithPadding.width * currentColumnRow.x) + (itemSizeWithPadding.width * differenceColumnRow.x) + (differenceRow*(self.itemSize.width+self.padding.width)/2) - self.contentShift.x;
    
    CGFloat originY = (itemSizeWithPadding.height * currentColumnRow.y) + (itemSizeWithPadding.height * differenceColumnRow.y) - self.contentShift.y;


    return CGRectMake(originX, originY, self.itemSize.width, self.itemSize.height);
}

#pragma mark - AGCollectionViewLayout

- (void)prepareLayout
{
    NSMutableDictionary *cellLayoutInfo = [NSMutableDictionary dictionary];
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0  inSection:0];
    
    for(NSInteger section = 0; section < sectionCount; section++)
    {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        
        for(NSInteger item = 0; item < itemCount; item++)
        {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            
            itemAttributes.frame = [self frameForIndexPath:indexPath];
            cellLayoutInfo[indexPath] = itemAttributes;
        }
    }
    
    self.layoutInfo = cellLayoutInfo;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* attributes = [NSMutableArray array];
    for (NSInteger i=0 ; i < self.numberOfRows*self.numberOfColumns; i++)
	{
		NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
		UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
		
		if (CGRectIntersectsRect(layoutAttributes.frame, rect))
		{
			[attributes addObject:layoutAttributes];
		}
    }
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.layoutInfo[indexPath];
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
	NSAssert((itemIndexPath.item < self.numberOfColumns*self.numberOfRows), @"Cannot insert item at index larger than grid size");
	UICollectionViewLayoutAttributes *initial = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
	initial.alpha = 0.0;
	return initial;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
	NSAssert((itemIndexPath.item < self.numberOfColumns*self.numberOfRows), @"Cannot remove item at index larger than grid size");
	UICollectionViewLayoutAttributes *initial = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
	initial.alpha = 0.0;
	return initial;
}

- (CGSize)collectionViewContentSize
{
    CGSize size = CGSizeMake((((self.itemSize.width+self.padding.width)*self.numberOfColumns)*GRID_SIZE_MULTIPLER)+self.edgeInsets.left+self.edgeInsets.right,
                      (((self.itemSize.height+self.padding.height)*self.numberOfRows)*GRID_SIZE_MULTIPLER)+self.edgeInsets.top+self.edgeInsets.bottom);
    
    return size;
}

@end
