//
//  Downloader.h
//  AppleMapOfflineTest
//
//  Created by Eiichi Hayashi on 2018/03/04.
//  Copyright © 2018年 skyElements. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DownloaderDelegate

@optional

- (void)didFinishDownloadingWithData:(NSData *)data;
- (void)didFailDownloading;

@end

@interface Downloader : NSObject <NSURLSessionDelegate>

@property (strong, nonatomic) id<DownloaderDelegate> delegate;

- (void)startDownloadingTileWithZ:(NSInteger)z X:(NSInteger)x Y:(NSInteger)y;

@end
