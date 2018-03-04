//
//  DownloadManager.m
//  AppleMapOfflineTest
//
//  Created by Eiichi Hayashi on 2018/03/04.
//  Copyright © 2018年 skyElements. All rights reserved.
//

#import "DownloadManager.h"

@implementation DownloadManager {
    Downloader *downloader;
    NSInteger zoomLevel;
    NSInteger xSequence;
    NSInteger xMax;
    NSInteger ySequence;
    NSInteger yMax;
    
    NSString *dir;
    NSFileManager *fm;
}

- (void)startSequences {
    downloader = [[Downloader alloc] init];
    downloader.delegate = self;
    
    // Zoom Levelの指定
    zoomLevel = 4;
    
    xSequence = 0;
    xMax = pow(2, zoomLevel);
    ySequence = 0;
    yMax = pow(2, zoomLevel);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    dir = [paths objectAtIndex:0];
    fm = [NSFileManager defaultManager];
    
    [self startDownloading];
}

- (void)startDownloading {
    NSLog(@"%ld, %ld, %ld", zoomLevel, xSequence, ySequence);
    [downloader startDownloadingTileWithZ:zoomLevel X:xSequence Y:ySequence];
}

- (void)didFinishDownloadingWithData:(NSData *)data {
    // DataのSave
    NSError *error;
    NSString *fileDir = [dir stringByAppendingPathComponent:[NSString stringWithFormat:@"tiles/%ld/%ld", zoomLevel, xSequence]];
    if (![fm fileExistsAtPath:fileDir]) {
        if (![fm createDirectoryAtPath:fileDir withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"パス作成失敗: %@", error);
        } else {
            //NSLog(@"パス作成成功");
        }
    }

    NSString *path = [fileDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld.png", ySequence]];
    //NSLog(@"%@", path);
    if (![fm createFileAtPath:path contents:data attributes:nil]) {
        NSLog(@"書き込み失敗");
    } else {
        //NSLog(@"書き込み成功");
    }
    
    ySequence++;
    if (ySequence < yMax) {
        [self startDownloading];
    } else {
        ySequence = 0;
        xSequence++;
        if (xSequence < xMax) {
            [self startDownloading];
        } else {
            [self didFinishSequences];
        }
    }
}

- (void)didFailDownloading {
    NSLog(@"didFailDownloading!!!");
}

- (void)didFinishSequences {
    NSLog(@"didFinishSequences!!!");
}

@end
