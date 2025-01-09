//
#import "SystemInfoFetcher.h"
#import <Foundation/Foundation.h>

@implementation SystemInfoFetcher

// 动态抓取应用的内存和 CPU 信息
- (void)startFetchingAppInfoForAppName:(NSString *)appName {
    // 定时器，每隔 5 秒抓取一次
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     repeats:YES
                                       block:^(NSTimer * _Nonnull timer) {
        [self fetchAppInfoForAppName:@"infoflow"];
    }];
}

// 使用 top 命令获取应用的 CPU 和内存信息
- (void)fetchAppInfoForAppName:(NSString *)appName {
    // 创建 NSTask 来执行 top 命令
    // `-l 1` 表示仅列出一次结果，`-stats pid,command,cpu,mem` 用于指定需要的列
    NSArray *pidArray = @[@(17331)];
    NSString *script = [NSString stringWithFormat:@"ps -eo pid,pcpu,pmem,rss,etime,time|egrep '%@'", [pidArray componentsJoinedByString:@"|"]];
    NSString *result = [self runShellScript:script];

    NSString *result2 = [self runShellScript:@"top -l 1 -stats pid,command,cpu,mem"];
    // 解析 top 命令输出，查找指定应用的信息
    
    NSLog(@"top output: %@", result2);
    [self parseTopOutput:result forAppName:appName];
}

/**
 *运行shell脚本
 */
-(NSString *)runShellScript:(NSString *)cmd
{
    NSTask *task;
    task = [[NSTask alloc] init];
    task.launchPath = @"/bin/sh";
    
    NSArray *arguments = @[@"-c",
                          [NSString stringWithFormat:@"%@", cmd]];

    task.arguments = arguments;
    
    NSPipe *pipe = [NSPipe pipe];
    task.standardOutput = pipe;
    task.standardError = pipe;
    
    NSFileHandle *file = pipe.fileHandleForReading;
    
    [task launch];
    
    NSData *data = [file readDataToEndOfFile];
    
    NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return output;
}

// 解析 top 命令的输出并提取指定应用的 CPU 和内存信息
- (void)parseTopOutput:(NSString *)output forAppName:(NSString *)appName {
    // 按行分割输出
    NSArray<NSString *> *lines = [output componentsSeparatedByString:@"\n"];
    
    for (NSString *line in lines) {
        // 检查行是否包含应用名称
        if ([line containsString:appName]) {
            NSLog(@"Found app info: %@", line);
            
            // 使用正则表达式或字符串处理来提取 CPU 和内存信息
            // 这里简单地输出整个行
            // 可以进一步处理获取具体的数值
            NSArray<NSString *> *components = [line componentsSeparatedByString:@" "];
            NSMutableArray<NSString *> *filteredComponents = [[NSMutableArray alloc] init];
            
            // 去掉多余的空白字符串
            for (NSString *component in components) {
                if (component.length > 0) {
                    [filteredComponents addObject:component];
                }
            }
            
            if (filteredComponents.count >= 4) {
                NSString *pid = filteredComponents[0];
                NSString *command = filteredComponents[1];
                NSString *cpuUsage = filteredComponents[2];
                NSString *memUsage = filteredComponents[3];
                
                NSLog(@"App: %@, PID: %@, CPU: %@, MEM: %@", command, pid, cpuUsage, memUsage);
            }
        }
    }
}

@end
