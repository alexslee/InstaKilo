//
//  InstaKiloCollectionViewController.m
//  InstaKilo
//
//  Created by Alex Lee on 2017-06-14.
//  Copyright © 2017 Alex Lee. All rights reserved.
//

#import "InstaKiloCollectionViewController.h"

@interface InstaKiloCollectionViewController ()

@property (strong, nonatomic) NSMutableArray *pictures;
@property (strong, nonatomic) NSMutableDictionary *displayThese;

@end

@implementation InstaKiloCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    
    //TEST SETUP FOR FUNCTIONALITY VIEWING, JUST RANDOMLY SETTING IMAGES + METADATA FOR DEFAULT DISPLAY
    self.pictures = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 10; i++) {
        NSString *fileName = [NSString stringWithFormat:@"image%d.jpg",i];
        NSString *testLocation = (i % 2 == 0) ? @"Vancouver" : @"Toronto";
        Picture *picture = [[Picture alloc] initWithPicture:[UIImage imageNamed:fileName] andCategory:@"Phone" andLocation:testLocation];
        
        [self.pictures addObject:picture];
    }
    
    [self.displayThese setObject:self.pictures forKey:@"allImages"];
    
    [self.collectionView setDataSource:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of items
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    //hard-coding for now
    NSArray *images = self.pictures;// = [self.displayThese objectForKey:@"allImages"];
    cell.imageView.image = [UIImage imageNamed:@"image1.jpg"];//[images objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
