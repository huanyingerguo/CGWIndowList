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
    return [super layoutAttributesForElementsInRect:rect];
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
