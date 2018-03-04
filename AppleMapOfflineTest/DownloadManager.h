//
//  DownloadManager.h
//  AppleMapOfflineTest
//
//  Created by Eiichi Hayashi on 2018/03/04.
//  Copyright © 2018年 skyElements. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Downloader.h"

@interface DownloadManager : NSObject <DownloaderDelegate>

- (void)startSequences;

@end
