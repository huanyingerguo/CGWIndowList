//
//  CNCollectionViewFlowLayout.m
//  CGWindowList
//
//  Created by jinglin sun on 2022/6/26.
//  Copyright © 2022 sunjinglin. All rights reserved.
//

#import "CNCollectionViewFlowLayout.h"

@implementation CNCollectionViewFlowLayout
- (void)prepareLayout {
    self.minimumInteritemSpacing = 1;
    self.minimumLineSpacing = 1;
    [super prepareLayout];
}

- (void)updateElementSize:(NSSize)size {
    CGFloat width = 0;
    CGFloat height = 0;
    
    // 最小宽高
    width = (size.width - 4 * self.minimumInteritemSpacing) / 3.1;
    height = (size.height - 2 * self.minimumLineSpacing) / 4; //除以3，最小高度会偏大，导致放不下
    /*
     
    // 最小宽高: 1*1 1*2 2*2 2*3 3*3
    if (self.totalCount == 1) {
        width = size.width;
        height = size.height;
    } else if (self.totalCount == 2) {
        width = (size.width - 1 * self.minimumInteritemSpacing) / 2;
        height = (size.height - 0 * self.minimumLineSpacing);
    } else if (self.totalCount == 3 ||
               self.totalCount == 4) {
        width = (size.width - 1 * self.minimumInteritemSpacing) / 2;
        height = (size.height - 1 * self.minimumLineSpacing) / 2;
    } else if (self.totalCount == 5 ||
               self.totalCount == 6) {
        width = (size.width - 2 * self.minimumInteritemSpacing) / 3;
        height = (size.height - 1 * self.minimumLineSpacing) / 2;
    } else {
        width = (size.width - 2 * self.minimumInteritemSpacing) / 3;
        height = (size.height - 2 * self.minimumLineSpacing) / 3;
    }
     */
    
    self.size = NSMakeSize(width, height);
    self.itemSize = NSMakeSize(width, height);
}

- (void)setTotalCount:(NSUInteger)totalCount {
    _totalCount = totalCount;
}

- (NSArray<__kindof NSCollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(NSRect)rect {
    NSArray<NSCollectionViewLayoutAttributes *> *attrs = [[NSArray alloc]initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
    
    for (NSCollectionViewLayoutAttributes *attr in attrs) {
        NSSize size = attr.frame.size;
        NSPoint point = attr.frame.origin;
        if (self.totalCount == 3) {
            if (attr.indexPath.item == 2) {
                point.x += size.width / 2;
                attr.frame = NSMakeRect(point.x, point.y, size.width, size.height);
            }
        } else if (self.totalCount == 5) {
            if (attr.indexPath.item == 3 ||
                attr.indexPath.item == 4) {
                point.x += size.width / 2;
                attr.frame = NSMakeRect(point.x, point.y, size.width, size.height);
            }
        } else if (self.totalCount == 3) {
            if (attr.indexPath.item == 2) {
                point.x += size.width / 2;
                attr.frame = NSMakeRect(point.x, point.y, size.width, size.height);
            }
        } else if (self.totalCount == 5) {
            if (attr.indexPath.item == 3 ||
                attr.indexPath.item == 4) {
                point.x += size.width / 2;
                attr.frame = NSMakeRect(point.x, point.y, size.width, size.height);
            }
        } else if (self.totalCount == 7) {
            if (attr.indexPath.item == 6) {
                point.x += size.width;
                attr.frame = NSMakeRect(point.x, point.y, size.width, size.height);
            }
        } else if (self.totalCount == 8) {
            if (attr.indexPath.item == 6 ||
                attr.indexPath.item == 7) {
                point.x += size.width / 2;
                attr.frame = NSMakeRect(point.x, point.y, size.width, size.height);
            }
        }
    }
    
    
    return attrs;
}

- (nullable NSCollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 3) {
        NSCollectionViewLayoutAttributes *attribute = [super layoutAttributesForItemAtIndexPath:indexPath];
        NSPoint point =  attribute.frame.origin;
        point.x -= attribute.frame.size.width/2;
    
        return attribute;
    }
    
    return [super layoutAttributesForItemAtIndexPath:indexPath];
}
@end
