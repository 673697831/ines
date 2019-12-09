//
//  ViewController.m
//  ines
//
//  Created by ouzhirui on 2019/11/17.
//  Copyright © 2019 ozr. All rights reserved.
//

#import "ViewController.h"
#import "LZHeartView.h"
#import "LZSettingViewController.h"
#import <Photos/Photos.h>

@interface ViewController ()


@property (nonatomic, strong) NSArray *imagelist;
@property (nonatomic, assign) NSUInteger curIndex;

@end

@implementation ViewController

#pragma mark - aciton

- (void)openSetting
{
//    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    [self presentViewController:self.picker animated:YES completion:nil];
    LZSettingViewController *vc = [LZSettingViewController new];
    __weak typeof(self) wself = self;
    vc.completionBlock = ^(NSArray * _Nonnull imageList) {
        wself.imagelist = imageList;
    };
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
}

#pragma mark

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    LZHeartView *view = [[LZHeartView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    view.backgroundColor = UIColor.redColor;
//    [self.view addSubview:view];
//    view.center = self.view.center;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
//    [button setTitle:@"设置" forState:UIControlStateNormal];
//    [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(openSetting) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
//    [button sizeToFit];
//
//
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//    self.navigationItem.rightBarButtonItems = @[rightItem];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        if (self.imagelist.count == 0) {
            return;
        }
        
        if (self.curIndex >= self.imagelist.count) {
            self.curIndex = 0;
        }
        
        UIImage *heartImage = self.imagelist[self.curIndex];;
        
        LZHeartView *heartView = [[LZHeartView alloc] initWithFrame:CGRectMake(0, 0, 144, 144)];
        [self.view addSubview:heartView];
        heartView.center = CGPointMake(self.view.bounds.size.width - 140, self.view.bounds.size.height - 24);
        [heartView animationInView:self.view image:heartImage];
        
        self.curIndex ++;
    }];
    
    [self loadPhotos];
}

#pragma mark -

- (void)loadPhotos
{
    // 拥有自定义相册（与 APP 同名，如果没有则创建）--调用刚才的方法
    PHAssetCollection *assetCollection = [self getAssetCollectionWithAppNameAndCreateCollection];
    if (assetCollection == nil) {
        return;
    }
    
    [self enumerateAssetsInAssetCollection:assetCollection original:YES];
}

- (PHAssetCollection *)getAssetCollectionWithAppNameAndCreateCollection {
    NSString *titlePhotos = @"ines的相册";
    // 获得所有的自定义相册
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in collections) {
        if ([collection.localizedTitle isEqualToString:titlePhotos]) {
            return collection;
        }
    }
    
    NSError *error = nil;
    // 代码执行到这里，说明还没有自定义相册
    __block NSString *createdCollectionId = nil;
    
    // 创建一个新的相册
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        createdCollectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:titlePhotos].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    
    if (error) {
        return nil;
    } else {
        // 创建完毕后再取出相册
        return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createdCollectionId] options:nil].firstObject;
    }
}

- (void)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original
{
    NSLog(@"相簿名:%@", assetCollection.localizedTitle);
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    
    NSMutableArray *assetsList = @[].mutableCopy;
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    for (PHAsset *asset in assets) {
        // 是否要原图
        CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeZero;
        
        // 从asset中获得图片
        __weak typeof(self) weakSelf = self;
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            NSLog(@"%@", result);
            original ? [assetsList addObject:result] : [assetsList addObject:result];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.imagelist = assetsList;
        });
    }
}


@end
