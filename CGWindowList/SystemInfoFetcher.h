//
//  SystemInfoFetcher.h
//  Test_SyncQueue
//
//  Created by sunjinglin on 2024/10/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SystemInfoFetcher : NSObject

- (void)startFetchingAppInfoForAppName:(NSString *)appName;

@end


NS_ASSUME_NONNULL_END
