//
//  LZSettingAddCollectionViewCell.m
//  ines
//
//  Created by ouzhirui on 2019/12/5.
//  Copyright © 2019 ozr. All rights reserved.
//

#import "LZSettingAddCollectionViewCell.h"

@interface LZSettingAddCollectionViewCell ()

@property (nonatomic, strong) UILabel *tipsLabel;

@end

@implementation LZSettingAddCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:32];
        label.textColor = UIColor.blackColor;
        label.text = @"添加";
        [label sizeToFit];
        [self.contentView addSubview:label];
        _tipsLabel = label;
        self.backgroundColor = UIColor.blueColor;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _tipsLabel.center = self.center;
}

@end
