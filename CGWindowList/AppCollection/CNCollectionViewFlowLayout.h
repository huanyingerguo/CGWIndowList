//
//  CNCollectionViewFlowLayout.h
//  CGWindowList
//
//  Created by jinglin sun on 2022/6/26.
//  Copyright © 2022 sunjinglin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CNCollectionViewLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNCollectionViewFlowLayout : NSCollectionViewFlowLayout<CNCollectionViewLayout>
@property (assign, nonatomic) NSUInteger totalCount;
@property (assign, nonatomic) NSSize size;

- (void)updateElementSize:(NSSize)size;
@end

NS_ASSUME_NONNULL_END
