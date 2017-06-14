//
//  ImageCollectionViewCell.m
//  InstaKilo
//
//  Created by Alex Lee on 2017-06-14.
//  Copyright © 2017 Alex Lee. All rights reserved.
//

#import "ImageCollectionViewCell.h"

@implementation ImageCollectionViewCell

//- (id)init {
//    if (self == [super init]) {
//        _imageView = [[UIImageView alloc] init];
//        [self.contentView addSubview:_imageView];
//    }
//    return self;
//}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(5, 5, CGRectGetWidth(self.contentView.frame) - 10, CGRectGetHeight(self.contentView.frame) - 10);
}

@end
