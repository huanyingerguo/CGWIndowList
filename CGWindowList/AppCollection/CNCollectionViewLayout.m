//
//  CNCollectionViewLayout.m
//  CGWindowList
//
//  Created by jinglin sun on 2022/6/24.
//  Copyright © 2022 sunjinglin. All rights reserved.
//

#import "CNCollectionViewLayout.h"

@implementation CNCollectionViewLayout

- (void)prepareLayout {
    [super prepareLayout];
}

- (void)updateElementSize:(NSSize)size {
}

- (NSSize)adaptivedContainerSize {
    return self.size;
}

- (void)setTotalCount:(NSUInteger)totalCount {
    _totalCount = totalCount;
}

- (NSArray<__kindof NSCollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(NSRect)rect {
    NSArray<NSCollectionViewLayoutAttributes *> *attrs = [[NSArray alloc]initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
    
    for (NSCollectionViewLayoutAttributes *attr in attrs) {
        NSSize size = attr.frame.size;
        long height = size.height;
        if (!NSEqualSizes(self.size, NSZeroSize) &&
            self.totalCount >= 9) {
            height = self.size.height;
        }
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
        } else if (self.totalCount == 7) {
            if (attr.indexPath.item == 6) {
                point.x += size.width;
                attr.frame = NSMakeRect(point.x, point.y, size.width, size.height);
            }
        } else if (self.totalCount == 8) {
            if (attr.indexPath.item == 6 ||
                attr.indexPath.item == 7) {
                point.x += size.width / 2;
            }
        }
        
        attr.frame = NSMakeRect(point.x, point.y, size.width, height);
    }
    
    
    return attrs;
}

@end
