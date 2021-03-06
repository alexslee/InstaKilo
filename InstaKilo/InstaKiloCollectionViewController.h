//
//  InstaKiloCollectionViewController.h
//  InstaKilo
//
//  Created by Alex Lee on 2017-06-14.
//  Copyright © 2017 Alex Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Picture.h"
#import "ImageCollectionViewCell.h"
#import "PictureManager.h"
#import "HeaderCollectionReusableView.h"

typedef enum : NSUInteger {
    category,
    location
} groupingBy;

@interface InstaKiloCollectionViewController : UICollectionViewController

@end
