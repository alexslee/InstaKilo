//
//  InstaKiloCollectionViewController.m
//  InstaKilo
//
//  Created by Alex Lee on 2017-06-14.
//  Copyright © 2017 Alex Lee. All rights reserved.
//

#import "InstaKiloCollectionViewController.h"

@interface InstaKiloCollectionViewController ()

@property (strong, nonatomic) NSMutableArray<Picture *> *pictures;
@property (strong, nonatomic) NSMutableDictionary *displayThese;

@property (weak, nonatomic) IBOutlet UISegmentedControl *groupToggle;

@property (strong,nonatomic) PictureManager *pictureManager;

@property (assign) groupingBy sortType;

@end

@implementation InstaKiloCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.installsStandardGestureForInteractiveMovement = YES;
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    
    /*
     * pictureManager object contains all of the images, see its implementation in PictureManager.m
     * (it works, but was coincidental that the images I picked sorted identically when done by location and by category)
     * (can uncomment the line in PictureManager.m at the end of the init, which duplicates the last image in the category group, to see it)
     * Alternatively, just double tap to delete an image, or long-press + reorder, then toggle between groups.
    */
    self.pictureManager = [[PictureManager alloc] init];
    self.displayThese = self.pictureManager.imagesByCategory;

    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTappedShouldDeleteImage:)];
    doubleTap.numberOfTapsRequired = 2;
    self.collectionView.userInteractionEnabled = YES;
    
    [self.collectionView addGestureRecognizer:doubleTap];
    
    [self.collectionView setDataSource:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)groupWasToggled:(UISegmentedControl *)sender {
    
    self.sortType = sender.selectedSegmentIndex;
    //swap the dictionary of images to display, depending on which group the user selected
    switch (self.sortType) {
        case category:
            self.displayThese = self.pictureManager.imagesByCategory;
            break;
            
        case location:
            self.displayThese = self.pictureManager.imagesByLocation;
            break;
            
        default:
            self.displayThese = self.pictureManager.imagesByCategory;
            break;
    }
    
    [self.collectionView reloadData];
    
}

- (NSArray *)getKeys;
{
    //helper method to obtain a sorted list of keys for further use
    return [[self.displayThese allKeys]sortedArrayUsingSelector:@selector(compare:)];
}

- (IBAction)doubleTappedShouldDeleteImage:(UITapGestureRecognizer *)sender {
//    NSLog(@"double tapped");
    if (sender.state == UIGestureRecognizerStateRecognized) {
        NSLog(@"double tapped");
        CGPoint deleteHere = [sender locationInView:self.collectionView];
        NSIndexPath *imageToDelete = [self.collectionView indexPathForItemAtPoint:deleteHere];
        NSString *thisSection = [self getKeys][imageToDelete.section];
        [[self.displayThese objectForKey:thisSection] removeObjectAtIndex:imageToDelete.row];
        [self.collectionView reloadData];
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.displayThese.allKeys count];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self.displayThese objectForKey:([self getKeys][section])] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    NSArray<Picture *> *images = [self.displayThese objectForKey:[self getKeys][indexPath.section]];
    cell.imageView.image = [images objectAtIndex:indexPath.row].pic;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;
{
    HeaderCollectionReusableView *header = nil;
    if ([kind isEqualToString: UICollectionElementKindSectionHeader]) {
        header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerReusableView" forIndexPath:indexPath];
        //set the header text to match the corresponding key in the current image dictionary
        header.headerLabel.text = [self getKeys][indexPath.section];
    }
    return header;
    
}

- (NSIndexPath *)collectionView:(UICollectionView *)collectionView targetIndexPathForMoveFromItemAtIndexPath:(NSIndexPath *)originalIndexPath toProposedIndexPath:(NSIndexPath *)proposedIndexPath;
{
    //only allow the user to move photos within the same section
    return ( (originalIndexPath.section == proposedIndexPath.section) ? proposedIndexPath : originalIndexPath );
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;
{
    NSString *sectionKey = [self getKeys][sourceIndexPath.section];
    NSMutableArray *pictures = [self.displayThese objectForKey:sectionKey];
    Picture *picture = pictures[sourceIndexPath.row];
    
    //re-order the data structure to account for the change that will occur
    [pictures removeObjectAtIndex:sourceIndexPath.row];
    [pictures insertObject:picture atIndex:destinationIndexPath.row];
    
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
