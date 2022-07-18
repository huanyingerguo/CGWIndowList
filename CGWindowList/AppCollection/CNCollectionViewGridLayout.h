//
//  CNCollectionViewGridLayout.h
//  CGWindowList
//
//  Created by jinglin sun on 2022/6/26.
//  Copyright © 2022 sunjinglin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CNCollectionViewLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNCollectionViewGridLayout : NSCollectionViewGridLayout <CNCollectionViewLayout>
@property (assign, nonatomic) NSUInteger totalCount;
@property (assign, nonatomic) NSSize size;
@property (assign, nonatomic) NSSize containerSize;
@property (assign, nonatomic) ECellRefer cellRefer;
@property (assign, nonatomic) ESubLayout subLayout;

- (void)updateElementSize:(NSSize)size;
- (NSSize)adaptivedContainerSize;
@end

NS_ASSUME_NONNULL_END
