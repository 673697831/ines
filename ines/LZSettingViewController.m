//
//  LZSettingViewController.m
//  ines
//
//  Created by ouzhirui on 2019/12/5.
//  Copyright © 2019 ozr. All rights reserved.
//

#import "LZSettingViewController.h"
#import "LZSettingAddCollectionViewCell.h"
#import "LZSettingImageCollectionViewCell.h"
#import <Photos/Photos.h>

@interface LZSettingViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) NSArray *imagelist;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) UIImagePickerController *picker;
@property (assign, nonatomic) NSUInteger replaceRow;

@end

@implementation LZSettingViewController

- (void)back
{
//    NSMutableArray *assetsList = @[].mutableCopy;
//    for (UIImage *image in self.imagelist) {
//        // 将图片保存到系统的【相机胶卷】中---调用刚才的方法
//      PHFetchResult<PHAsset *> *assets = [self synchronousSaveImageWithPhotosWithImage:image];
//      if (assets == nil) {
//          continue;
//      }
//      [assetsList addObject:assets];
//
//    }
//
//    // 拥有自定义相册（与 APP 同名，如果没有则创建）--调用刚才的方法
//    PHAssetCollection *assetCollection = [self getAssetCollectionWithAppNameAndCreateCollection];
//    if (assetCollection == nil) {
//        return;
//    }
//
//    NSError *error = nil;
//    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
//        //--告诉系统，要操作哪个相册
//        PHAssetCollectionChangeRequest *collectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
//        //--添加图片到自定义相册--追加--就不能成为封面了
//        //--[collectionChangeRequest addAssets:assets];
//        //--插入图片到自定义相册--插入--可以成为封面
//        for (PHFetchResult<PHAsset *> *assets in assetsList) {
//            [collectionChangeRequest addAssets:assets];
//        }
//        for (int i = 0; i <assetsList.count ; i ++) {
//            [collectionChangeRequest replaceAssetsAtIndexes:[NSIndexSet indexSetWithIndex:i] withAssets:assetsList[i]];
//        }
//    } error:&error];
//
//    if (error) {
//        return;
//    }
    
//    NSMutableArray *imageIds = [NSMutableArray array];
//    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//          //写入图片到相册
//        for (UIImage *image in self.imagelist) {
//            PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
//            //记录本地标识，等待完成后取到相册中的图片对象
//            [imageIds addObject:req.placeholderForCreatedAsset.localIdentifier];
//        }
//      } completionHandler:^(BOOL success, NSError * _Nullable error) {
//          NSLog(@"success = %d, error = %@", success, error);
//          if (success)
//          {
//              //成功后取相册中的图片对象
//              __block PHAsset *imageAsset = nil;
//              PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:imageIds options:nil];
//              [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                  imageAsset = obj;
//                  *stop = YES;
//              }];
//              if (imageAsset)
//              {
//                  //加载图片数据
//                  [[PHImageManager defaultManager] requestImageDataForAsset:imageAsset
//                        options:nil
//                        resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
//                             NSLog(@"imageData = %@", imageData);
//                        }];
//              }
//          }
//      }];
    
    __weak typeof(self) wself = self;
    [self dismissViewControllerAnimated:YES completion:^{
        if (wself.completionBlock) {
            wself.completionBlock(wself.imagelist);
        }
    }];
}

- (void)loadPhotos
{
    // 拥有自定义相册（与 APP 同名，如果没有则创建）--调用刚才的方法
    PHAssetCollection *assetCollection = [self getAssetCollectionWithAppNameAndCreateCollection];
    if (assetCollection == nil) {
        return;
    }
    
    [self enumerateAssetsInAssetCollection:assetCollection original:YES];
}

- (void)addPhone:(UIImage *)image
{
    PHAssetCollection *assetCollection = [self getAssetCollectionWithAppNameAndCreateCollection];
    if (assetCollection == nil) {
        return;
    }
    
    PHFetchResult<PHAsset *> *assets = [self synchronousSaveImageWithPhotosWithImage:image];
    if (assets == nil) {
        return;
    }
    NSMutableArray *list = [[NSMutableArray alloc] initWithArray:self.imagelist];
    NSError *error = nil;
    if (self.replaceRow <self.imagelist.count) {
        [list replaceObjectAtIndex:self.replaceRow withObject:image];
    }else
    {
        [list addObject:image];
    }

    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        //--告诉系统，要操作哪个相册
        PHAssetCollectionChangeRequest *collectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
        //--添加图片到自定义相册--追加--就不能成为封面了
        //--[collectionChangeRequest addAssets:assets];
        //--插入图片到自定义相册--插入--可以成为封面
        if (self.replaceRow <self.imagelist.count) {
            [collectionChangeRequest replaceAssetsAtIndexes:[NSIndexSet indexSetWithIndex:index] withAssets:assets];
        }else {
            [collectionChangeRequest addAssets:assets];
        }
    } error:&error];
    
    self.imagelist = list;
    
    [self.collectionView reloadData];
}

- (void)removePhoto
{
    PHAssetCollection *assetCollection = [self getAssetCollectionWithAppNameAndCreateCollection];
    if (assetCollection == nil) {
        return;
    }
    
    if (self.replaceRow>= self.imagelist.count) {
        return;
    }

    NSMutableArray *list = [[NSMutableArray alloc] initWithArray:self.imagelist];
    [list removeObjectAtIndex:self.replaceRow];
    
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        //--告诉系统，要操作哪个相册
        PHAssetCollectionChangeRequest *collectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
        //--添加图片到自定义相册--追加--就不能成为封面了
        //--[collectionChangeRequest addAssets:assets];
        //--插入图片到自定义相册--插入--可以成为封面
        [collectionChangeRequest removeAssetsAtIndexes:[NSIndexSet indexSetWithIndex:self.replaceRow]];
    } error:&error];
    
    self.imagelist = list;
    [self.collectionView reloadData];
}

- (PHFetchResult<PHAsset *> *)synchronousSaveImageWithPhotosWithImage:(UIImage *)image
{
    __block NSString *createdAssetId = nil;
    
    // 添加图片到【相机胶卷】
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        createdAssetId = [PHAssetChangeRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
    } error:nil];
    
    if (createdAssetId == nil) return nil;
    // 在保存完毕后取出图片
    return [PHAsset fetchAssetsWithLocalIdentifiers:@[createdAssetId] options:nil];
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
            [weakSelf.collectionView reloadData];
        });
    }
}

- (void)showAlertSheet
{
    
    //初始化一个UIAlertController的警告框
    UIAlertController *alertController = [[UIAlertController alloc] init];
    //初始化一个UIAlertController的警告框将要用到的UIAlertAction style cancle
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"t提示框上的按钮 cancle 被点击了");
    }];
    //初始化一个UIAlertController的警告框将要用到的UIAlertAction style Default
    UIAlertAction *wx = [UIAlertAction actionWithTitle:@"删除图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self removePhoto];
    }];
    //初始化一个UIAlertController的警告框将要用到的UIAlertAction style Default
    UIAlertAction *wb = [UIAlertAction actionWithTitle:@"选择图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.picker animated:YES completion:nil];
    }];
    //将初始化好的UIAlertAction添加到UIAlertController中
    [alertController addAction:cancle];
    [alertController addAction:wx];
    [alertController addAction:wb];
    //将初始化好的j提示框显示出来
    [self presentViewController:alertController animated:true completion:nil];
}

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadPhotos];
    UIButton *leftButton = [UIButton new];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [leftButton sizeToFit];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItems = @[leftItem];
    
    self.picker = [[UIImagePickerController alloc] init];
    self.picker.delegate = self;
    self.picker.allowsEditing = YES;
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
   [collectionView registerClass:[LZSettingAddCollectionViewCell class]
      forCellWithReuseIdentifier:NSStringFromClass([LZSettingAddCollectionViewCell class])];
   [collectionView registerClass:[LZSettingImageCollectionViewCell class]
      forCellWithReuseIdentifier:NSStringFromClass([LZSettingImageCollectionViewCell class])];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imagelist.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.imagelist.count) {
        LZSettingImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LZSettingImageCollectionViewCell class]) forIndexPath:indexPath];
        cell.phoneImageView.image = self.imagelist[indexPath.row];
        return cell;
    }
    return [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LZSettingAddCollectionViewCell class]) forIndexPath:indexPath];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    self.replaceRow = indexPath.row;
    if (indexPath.row < self.imagelist.count) {
        [self showAlertSheet];
    }else
    {
        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.picker animated:YES completion:nil];
    }

}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CGFloat width = (self.view.bounds.size.width - 30)/4;
        //return CGSizeMake(self.view.bounds.size.width, 153);
        //return CGSizeMake(self.view.bounds.size.width, 120);
        return CGSizeMake(width, width);
    }
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
//    if (section == 0) {
//        return UIEdgeInsetsMake(16, 16, 0, 16);
//    }
//
//    if (section == 1) {
//        return UIEdgeInsetsZero;
//    }
//
//    if (section == 2) {
//        CGFloat w = [UIScreen mainScreen].bounds.size.width - 4 * 56 - 3 * 18;
//        return UIEdgeInsetsMake(0, w/2, 34, w/2);
//    }
//
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }

    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    
    if (section == 1) {
        return 0;
    }
    
    if (section == 2) {
        return 18;
    }
    
    return 0;
}

#pragma mark - UINavigationControllerDelegate & UINavigationControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
//    获取图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self addPhone:image];
    
//    NSMutableArray *imagelist = @[].mutableCopy;
//    [imagelist addObjectsFromArray:self.imagelist];
//    [imagelist addObject:image];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.imagelist = imagelist;
//        [self.collectionView reloadData];
//    });
    //self.image.image = image;
//    获取图片后返回
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//按取消按钮时候的功能
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
//    返回
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
