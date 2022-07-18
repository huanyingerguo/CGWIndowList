//
//  CNCollectionViewLayout.h
//  CGWindowList
//
//  Created by jinglin sun on 2022/7/14.
//  Copyright © 2022 sunjinglin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSUInteger, ECellRefer) {
    ECellRefer_Unknown = 0,
    ECellRefer_Width,
    ECellRefer_Height,
};

typedef NS_ENUM(NSUInteger, ESubLayout) {
    ESubLayout_1X1 = 0,
    ESubLayout_1X2,
    ESubLayout_2X2, //3 或者 4个元素
    ESubLayout_2X3, //5 或者 6个元素
    ESubLayout_3X3, //7，8,9...
};

NS_ASSUME_NONNULL_BEGIN

@protocol CNCollectionViewLayout
@property (assign, nonatomic) NSUInteger totalCount;
@property (assign, nonatomic) NSSize size;
@property (assign, nonatomic) ESubLayout subLayout;

- (void)updateElementSize:(NSSize)size;
- (NSSize)adaptivedContainerSize;
@end

@interface CNCollectionViewLayout : NSCollectionViewLayout<CNCollectionViewLayout>
@property (assign, nonatomic) NSUInteger totalCount;
@property (assign, nonatomic) NSSize size;
@property (assign, nonatomic) ESubLayout subLayout;

- (void)updateElementSize:(NSSize)size;
- (NSSize)adaptivedContainerSize;
@end


NS_ASSUME_NONNULL_END
