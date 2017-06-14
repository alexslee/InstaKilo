//
//  Picture.m
//  InstaKilo
//
//  Created by Alex Lee on 2017-06-14.
//  Copyright © 2017 Alex Lee. All rights reserved.
//

#import "Picture.h"

@implementation Picture

- (id)initWithPicture:(UIImage *)picture andCategory:(NSString *)category andLocation:(NSString *)location;
{
    self = [super init];
    
    if (self) {
        _pic = picture;
        _category = category;
        _location = location;
    }
    
    return self;
}

@end
