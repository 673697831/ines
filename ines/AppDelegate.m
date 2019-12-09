//
//  AppDelegate.m
//  ines
//
//  Created by ouzhirui on 2019/11/17.
//  Copyright © 2019 ozr. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@interface AppDelegate ()

@property (nonatomic, strong) UIWindow *myWindow;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self requestAccessCamera];
    [self requestAccessPhotos];
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied) {

    } else {

    }
    
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    if (author == PHAuthorizationStatusRestricted || author == PHAuthorizationStatusDenied) {

    }else{

    }
    
    self.myWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.myWindow makeKeyAndVisible];
    self.myWindow.rootViewController = [ViewController new];
    
    return YES;
}

- (void)requestAccessPhotos
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
            if (PHAuthorizationStatusAuthorized != status) {
                dispatch_async(dispatch_get_main_queue(), ^{
   
                });
            }else
            {

            }
        }];
    }else
    {

    }
}

- (void)requestAccessCamera
{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (!granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        }else
        {

        }
        
    }];
}


@end
