//
//  CNCollectionViewGridLayout.m
//  CGWindowList
//
//  Created by jinglin sun on 2022/7/14.
//  Copyright © 2022 sunjinglin. All rights reserved.
//

#import "CNCollectionViewGridLayout.h"

@interface CNCollectionViewGridLayout ()
@property (assign, nonatomic) int rowCnt;
@property (assign, nonatomic) int columnCnt;
@property (assign, nonatomic) NSSize cellSize;
@end

@implementation CNCollectionViewGridLayout
- (void)prepareLayout {
    self.minimumInteritemSpacing = 2;
    self.minimumLineSpacing = 2;
    [super prepareLayout];
}

- (void)updateElementSize:(NSSize)size {
    //最小+最大，等于约束了最终宽高
    NSSize expectSize = [self _expectedCellSize:size];
    self.minimumItemSize = expectSize;
    self.maximumItemSize = expectSize;
    
    self.size = expectSize;
}

- (NSSize)adaptivedContainerSize {
    CGFloat horizontalSpacing = (self.rowCnt - 1) * self.minimumInteritemSpacing; //整体水平的间隔
    CGFloat verticalSpacing = (self.columnCnt - 1) * self.minimumInteritemSpacing; //整体垂直的间隔

    CGFloat cellWidth = self.cellSize.width;
    CGFloat cellheight = self.cellSize.height;
    if (self.cellRefer == ECellRefer_Height) {
        cellWidth += 1; //因为计算float数的时候，最后算出来的肯定是有省略的(一般是小数点后N位，N>=1)，故这里强制补充
    } else if (self.cellRefer == ECellRefer_Width) {
        cellheight += 1;
    }
    
    return NSMakeSize(cellWidth * self.rowCnt + horizontalSpacing,
                      cellheight * self.columnCnt + verticalSpacing);
}

- (NSSize)_expectedCellSizeV0:(NSSize)size {
    CGFloat width = 0;
    CGFloat height = 0;
    
    // 最小宽高
    if (self.totalCount == 1) {
    } else if (self.totalCount == 2) {
    } else if (self.totalCount == 3 ||
               self.totalCount == 4) {
    } else if (self.totalCount == 5 ||
               self.totalCount == 6) {
    } else {
        width = (size.width - 2 * self.minimumInteritemSpacing) / 3.0;
        height = (size.height - 2 * self.minimumLineSpacing) / 3.0; //除以3，最小高度会偏大，导致放不下
    }

    
    return NSMakeSize(width, height);
}

- (NSSize)_expectedCellSize:(NSSize)size {
    CGFloat cellWidth = size.width;
    CGFloat cellHeight = size.height;
        
    int rowCnt = 1;
    int columnCnt = 1;

    // 最小宽高
    if (self.totalCount == 1) {
        rowCnt = 1;
        columnCnt = 1;
        self.subLayout = ESubLayout_1X1;
    } else if (self.totalCount == 2) {
        rowCnt = 2;
        columnCnt = 1;
        self.subLayout = ESubLayout_1X2;
    } else if (self.totalCount == 3 ||
               self.totalCount == 4) {
        rowCnt = 2;
        columnCnt = 2;
        self.subLayout = ESubLayout_2X2;
    } else if (self.totalCount == 5 ||
               self.totalCount == 6) {
        rowCnt = 3;
        columnCnt = 2;
        self.subLayout = ESubLayout_2X3;
    } else {
        rowCnt = 3;
        columnCnt = 3;
        self.subLayout = ESubLayout_3X3;
    }
    
    cellWidth = (size.width - rowCnt * self.minimumInteritemSpacing) * 1.0 / rowCnt;
    cellHeight = (size.height - columnCnt * self.minimumInteritemSpacing) * 1.0 / columnCnt;
    
    float radio = cellHeight * 1.0 / cellWidth;
    if (radio > 9 / 16.0) { //高大了，以宽度为基准
        cellHeight = cellWidth * 9 / 16.0;
        self.cellRefer = ECellRefer_Width;
    } else {
        cellWidth = cellHeight * 16 / 9.0;
        self.cellRefer = ECellRefer_Height;
    }
    
    self.cellSize = NSMakeSize(cellWidth, cellHeight);
    self.rowCnt = rowCnt;
    self.columnCnt = columnCnt;
    return self.cellSize;
}

- (void)setTotalCount:(NSUInteger)totalCount {
    _totalCount = totalCount;
    if (self.totalCount == 5 ||
        self.totalCount == 6 ) { //最大2*3
        self.maximumNumberOfRows = 2;
        self.maximumNumberOfColumns = 3;
    } else if (self.totalCount <= 4) { //最大2*2
        self.maximumNumberOfRows = 2;
        self.maximumNumberOfColumns = 2;
    }  else { //最大3*3
        self.maximumNumberOfRows = 3;
        self.maximumNumberOfColumns = 3;
    }
}

- (NSArray<__kindof NSCollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(NSRect)rect {
    NSArray<NSCollectionViewLayoutAttributes *> *attrs = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
    
    for (NSCollectionViewLayoutAttributes *attr in attrs) {
        NSSize size = attr.frame.size;
        long height = size.height;
        if (!NSEqualSizes(self.cellSize, NSZeroSize) &&
            self.totalCount >= 1) {
            height = self.cellSize.height;
        }
        
        NSPoint point = attr.frame.origin;
        if (self.totalCount == 3) {
            if (attr.indexPath.item == 2) {
                point.x += size.width / 2;
            }
        } else if (self.totalCount == 5) {
            if (attr.indexPath.item == 3 ||
                attr.indexPath.item == 4) {
                point.x += size.width / 2;
            }
        } else if (self.totalCount == 7) {
            if (attr.indexPath.item == 6) {
                point.x += size.width;
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

- (nullable NSCollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 3) {
        NSCollectionViewLayoutAttributes *attribute = [super layoutAttributesForItemAtIndexPath:indexPath];
        NSPoint point =  attribute.frame.origin;
        point.x -= attribute.frame.size.width/2;
    
        return attribute;
    }
    
    return [super layoutAttributesForItemAtIndexPath:indexPath];
}
@synthesize cellRefer;

@end
