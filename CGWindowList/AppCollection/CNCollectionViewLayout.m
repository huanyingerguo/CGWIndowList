//
//  CNCollectionViewLayout.m
//  CGWindowList
//
//  Created by jinglin sun on 2022/6/24.
//  Copyright © 2022 sunjinglin. All rights reserved.
//

#import "CNCollectionViewLayout.h"

@implementation CNCollectionViewLayout

- (NSArray<__kindof NSCollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(NSRect)rect {
    NSArray<NSCollectionViewLayoutAttributes *> *attrs = [[NSArray alloc]initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
    
    for (NSCollectionViewLayoutAttributes *attr in attrs) {
        if (self.totalCount == 3) {
            if (attr.indexPath.item == 2) {
                NSSize size = attr.frame.size;
                NSPoint point = attr.frame.origin;
                point.x += size.width / 2;
                attr.frame = NSMakeRect(point.x, point.y, size.width, size.height);
            }
        } else if (self.totalCount == 5) {
            if (attr.indexPath.item == 3) {
                NSSize size = attr.frame.size;
                NSPoint point = attr.frame.origin;
                point.x += size.width / 2;
                attr.frame = NSMakeRect(point.x, point.y, size.width, size.height);
            }
        } else if (self.totalCount == 7) {
            if (attr.indexPath.item == 6) {
                NSSize size = attr.frame.size;
                NSPoint point = attr.frame.origin;
                point.x += size.width;
                attr.frame = NSMakeRect(point.x, point.y, size.width, size.height);
            }
        } else if (self.totalCount == 8) {
            if (attr.indexPath.item == 6) {
                NSSize size = attr.frame.size;
                NSPoint point = attr.frame.origin;
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
