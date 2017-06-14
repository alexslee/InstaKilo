//
//  PictureManager.m
//  InstaKilo
//
//  Created by Alex Lee on 2017-06-14.
//  Copyright © 2017 Alex Lee. All rights reserved.
//

#import "PictureManager.h"

@implementation PictureManager

-(instancetype)init {
    
    if (self == [super init]) {
        self.allPictures = [[NSMutableArray alloc] init];
        self.allImagesDict = [[NSMutableDictionary alloc]init];
        //store all images first
        for (int i = 1; i <= 5; i++) {
            NSString *fileName = [NSString stringWithFormat:@"image%d.jpg",i];
            NSString *location = @"Toronto";
            Picture *picture = [[Picture alloc] initWithPicture:[UIImage imageNamed:fileName] andCategory:@"Semesters" andLocation:location];
            [self.allPictures addObject:picture];
        }
        
        for (int i = 6; i <= 10; i++) {
            NSString *fileName = [NSString stringWithFormat:@"image%d.jpg",i];
            NSString *location = @"Vancouver";
            Picture *picture = [[Picture alloc] initWithPicture:[UIImage imageNamed:fileName] andCategory:@"Summertime" andLocation:location];
            [self.allPictures addObject:picture];
        }
        
        [self.allImagesDict setObject:_allPictures forKey:@"all"];
        
        
        //next, sort by location
        NSArray *locales = [_allPictures valueForKeyPath:@"@distinctUnionOfObjects.location"];
        
        //go through all location tags
        for (int i = 0; i < locales.count; i++) {
            
            NSMutableArray *thisLocale = [[NSMutableArray alloc] init];
            
            //go through each picture, and if a matching location tag is found, add it to the array for that location
            for (int j = 0; j < _allPictures.count; j++) {
                Picture *picture = [_allPictures objectAtIndex:j];
                if ([picture.location isEqualToString:[locales objectAtIndex:i]]) {
                    [thisLocale addObject:picture];
                }
            }
            //add all images for that location to the sorted dictionary
            [_imagesByLocation setObject:thisLocale forKey:[locales objectAtIndex:i]];
            
        }
        
        //lastly, sort by category
        NSArray *categoryList = [_allPictures valueForKeyPath:@"@distinctUnionOfObjects.category"];
        
        for (int i = 0; i < categoryList.count; i++) {
            
            NSMutableArray *thisCategory = [[NSMutableArray alloc] init];
            
            for (int j = 0; j < _allPictures.count; j++) {
                Picture *picture = [_allPictures objectAtIndex:j];
                if ([picture.category isEqualToString:[categoryList objectAtIndex:i]]) {
                    [thisCategory addObject:picture];
                }
            }
            
            [_imagesByCategory setObject:thisCategory forKey:[categoryList objectAtIndex:i]];
            
        }
        
    }
    
    return self;
}

@end
