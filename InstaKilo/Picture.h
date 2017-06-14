//
//  Picture.h
//  InstaKilo
//
//  Created by Alex Lee on 2017-06-14.
//  Copyright © 2017 Alex Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Picture : NSObject

@property (strong, nonatomic) NSString *category;

@property (strong, nonatomic) NSString *location;

@property (strong, nonatomic) UIImage *pic;


- (id)initWithPicture:(UIImage *)picture andCategory:(NSString *)category andLocation:(NSString *)location;

@end
