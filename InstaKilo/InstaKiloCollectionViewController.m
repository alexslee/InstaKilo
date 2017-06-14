//
//  InstaKiloCollectionViewController.m
//  InstaKilo
//
//  Created by Alex Lee on 2017-06-14.
//  Copyright © 2017 Alex Lee. All rights reserved.
//

#import "InstaKiloCollectionViewController.h"

const CGFloat kScaleBoundLower = 1.0;
const CGFloat kScaleBoundUpper = 2.0;

@interface InstaKiloCollectionViewController ()

@property (strong, nonatomic) NSMutableArray<Picture *> *pictures;
@property (strong, nonatomic) NSMutableDictionary *displayThese;

@property (weak, nonatomic) IBOutlet UISegmentedControl *groupToggle;

@property (strong,nonatomic) PictureManager *pictureManager;

@property (assign) groupingBy sortType;

//variables used for pinch-to-zoom code (bottom of the file)
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic,assign) CGFloat scale;
@property (nonatomic,assign) BOOL fitCells;
@property (nonatomic,assign) BOOL animatedZooming;

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
    
    // Add the pinch to zoom gesture
    self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(didReceivePinchGesture:)];
    [self.collectionView addGestureRecognizer:self.pinchGesture];
    
    self.fitCells = NO;
    self.animatedZooming = NO;
    
    // Default scale is the average between the lower and upper bound
    self.scale = (kScaleBoundUpper + kScaleBoundLower)/2.0;
    
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

//PINCH TO ZOOM ON COLLECTION VIEW, SOURCED FROM https://github.com/CanTheAlmighty/SamplePinchGesture

#pragma mark - custom size on pinch
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Main use of the scale property
    CGFloat scaledWidth = 50 * self.scale;
    if (self.fitCells) {
        NSInteger cols = floor(320 / scaledWidth);
        CGFloat totalSpacingSize = 10 * (cols - 1); // 10 is defined in the xib
        CGFloat fittedWidth = (320 - totalSpacingSize) / cols;
        return CGSizeMake(fittedWidth, fittedWidth);
    } else {
        return CGSizeMake(scaledWidth, scaledWidth);
    }
}


#pragma mark - Gesture Recognizers for zoom-on-pinch
- (void)didReceivePinchGesture:(UIPinchGestureRecognizer*)gesture
{
    static CGFloat scaleStart;
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        // Take an snapshot of the initial scale
        scaleStart = self.scale;
        return;
    }
    if (gesture.state == UIGestureRecognizerStateChanged)
    {
        // Apply the scale of the gesture to get the new scale
        self.scale = scaleStart * gesture.scale;
        
        if (self.animatedZooming)
        {
            // Animated zooming (remove and re-add the gesture recognizer to prevent updates during the animation)
            [self.collectionView removeGestureRecognizer:self.pinchGesture];
            UICollectionViewFlowLayout *newLayout = [[UICollectionViewFlowLayout alloc] init];
            [self.collectionView setCollectionViewLayout:newLayout animated:YES completion:^(BOOL finished) {
                [self.collectionView addGestureRecognizer:self.pinchGesture];
            }];
        }
        else
        {
            // Invalidate layout
            [self.collectionView.collectionViewLayout invalidateLayout];
        }
        
    }
    
}

@end
