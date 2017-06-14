//
//  PictureManager.h
//  InstaKilo
//
//  Created by Alex Lee on 2017-06-14.
//  Copyright © 2017 Alex Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Picture.h"

@interface PictureManager : NSObject

@property (strong, nonatomic) NSMutableArray<Picture *> *allPictures;

@property (strong, nonatomic) NSMutableDictionary *allImagesDict;

@property (strong, nonatomic) NSMutableDictionary *imagesByCategory;

@property (strong, nonatomic) NSMutableDictionary *imagesByLocation;


@end
