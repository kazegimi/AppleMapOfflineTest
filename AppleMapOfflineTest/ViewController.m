//
//  ViewController.m
//  AppleMapOfflineTest
//
//  Created by Eiichi Hayashi on 2018/02/27.
//  Copyright © 2018年 skyElements. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    DownloadManager *downloadManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir = [paths objectAtIndex:0];
    
    // 読み込み
    //NSString *template = @"https://cyberjapandata.gsi.go.jp/xyz/std/{z}/{x}/{y}.png";
    //NSString *template = @"file:///var/mobile/Containers/Data/Application/DA8BF853-A316-4345-AB99-148C49FBCEC2/Documents/tiles/{z}/{x}/{y}.png";
    NSString *prefix = @"file://";
    NSString *template = [dir stringByAppendingPathComponent:@"tiles/{z}/{x}/{y}.png"];
    template = [prefix stringByAppendingString:template];
    MKTileOverlay *tile_overlay = [[MKTileOverlay alloc] initWithURLTemplate:template];
    tile_overlay.canReplaceMapContent = YES;
    [_mapView addOverlay:tile_overlay level:MKOverlayLevelAboveRoads];
    
    downloadManager = [[DownloadManager alloc] init];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    if ([overlay isMemberOfClass:[MKTileOverlay class]]) {
        return [[MKTileOverlayRenderer alloc] initWithOverlay:overlay];
    } else {
        return nil;
    }
    return nil;
}

- (IBAction)downLoad:(id)sender {
    [downloadManager startSequences];
}

- (IBAction)snapShot:(id)sender {
    MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
    options.region = self.mapView.region;
    options.scale = [UIScreen mainScreen].scale;
    options.size = self.mapView.frame.size;
    
    MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
    [snapshotter startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
        UIImage *image = snapshot.image;
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(savingImageIsFinished:didFinishSavingWithError:contextInfo:), nil);
    }];
}

- (void)savingImageIsFinished:(UIImage *)_image didFinishSavingWithError:(NSError *)_error contextInfo:(void *)_contextInfo {
    if(_error){//エラーのとき
        // コントローラを生成
        UIAlertController * ac =
        [UIAlertController alertControllerWithTitle:@"Error"
                                            message:@"Save failed ."
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        
        // OK用のアクションを生成
        UIAlertAction * okAction =
        [UIAlertAction actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   // ボタンタップ時の処理
                                   NSLog(@"OK button tapped.");
                               }];
        
        // コントローラにアクションを追加
        [ac addAction:okAction];
        
        // アラート表示処理
        [self presentViewController:ac animated:YES completion:nil];
    }else{//保存できたとき
        return;
    }
}

@end
