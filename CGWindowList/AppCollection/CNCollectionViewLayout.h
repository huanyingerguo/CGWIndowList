//
//  CNCollectionViewLayout.h
//  CGWindowList
//
//  Created by jinglin sun on 2022/6/24.
//  Copyright © 2022 sunjinglin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSUInteger, ECellRefer) {
    ECellRefer_Unknown = 0,
    ECellRefer_Width,
    ECellRefer_Height,
};

NS_ASSUME_NONNULL_BEGIN

@protocol CNCollectionViewLayout
@property (assign, nonatomic) NSUInteger totalCount;
@property (assign, nonatomic) NSSize size;
@property (assign, nonatomic) ECellRefer cellRefer;

- (void)updateElementSize:(NSSize)size;
@end

@interface CNCollectionViewLayout : NSCollectionViewLayout<CNCollectionViewLayout>
@property (assign, nonatomic) NSUInteger totalCount;
@property (assign, nonatomic) NSSize size;
@property (assign, nonatomic) ECellRefer cellRefer;

- (void)updateElementSize:(NSSize)size;
@end


NS_ASSUME_NONNULL_END
