//
//  ViewController.h
//  AppleMapOfflineTest
//
//  Created by Eiichi Hayashi on 2018/02/27.
//  Copyright © 2018年 skyElements. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "DownloadManager.h"

@interface ViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)downLoad:(id)sender;
- (IBAction)snapShot:(id)sender;

@end

