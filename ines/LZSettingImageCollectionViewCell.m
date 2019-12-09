//
//  LZSettingImageCollectionViewCell.m
//  ines
//
//  Created by ouzhirui on 2019/12/5.
//  Copyright © 2019 ozr. All rights reserved.
//

#import "LZSettingImageCollectionViewCell.h"

@implementation LZSettingImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _phoneImageView = [UIImageView new];
        _phoneImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_phoneImageView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.phoneImageView.frame = self.bounds;
}

@end
