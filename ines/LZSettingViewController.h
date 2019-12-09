//
//  LZSettingViewController.h
//  ines
//
//  Created by ouzhirui on 2019/12/5.
//  Copyright © 2019 ozr. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZSettingViewController : UIViewController

@property (nonatomic, copy) void (^completionBlock)(NSArray *imageList);

@end

NS_ASSUME_NONNULL_END
