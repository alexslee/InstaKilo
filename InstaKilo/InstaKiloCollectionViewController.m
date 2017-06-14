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
- (IBAction)doubleTappedShouldDeleteImage:(UITapGestureRecognizer *)sender {
//    NSLog(@"double tapped");
    if (sender.state == UIGestureRecognizerStateRecognized) {
        NSLog(@"double tapped");
        CGPoint deleteHere = [sender locationInView:self.collectionView];
        NSIndexPath *imageToDelete = [self.collectionView indexPathForItemAtPoint:deleteHere];
        NSString *thisSection = [[self.displayThese allKeys] sortedArrayUsingSelector:@selector(compare:)][imageToDelete.section];
        [[self.displayThese objectForKey:thisSection] removeObjectAtIndex:imageToDelete.row];
        [self.collectionView reloadData];
    }
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
    return [self.displayThese.allKeys count];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of items
    return [[self.displayThese objectForKey:( [[self.displayThese allKeys] sortedArrayUsingSelector:@selector(compare:)][section] )] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    NSArray<Picture *> *images = [self.displayThese objectForKey:[[self.displayThese allKeys] sortedArrayUsingSelector:@selector(compare:)][indexPath.section]];
    cell.imageView.image = [images objectAtIndex:indexPath.row].pic;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;
{
    HeaderCollectionReusableView *header = nil;
    if ([kind isEqualToString: UICollectionElementKindSectionHeader]) {
        header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerReusableView" forIndexPath:indexPath];
        header.headerLabel.text = [[self.displayThese allKeys] sortedArrayUsingSelector:@selector(compare:)][indexPath.section];
    }
    return header;
    
}

- (NSIndexPath *)collectionView:(UICollectionView *)collectionView targetIndexPathForMoveFromItemAtIndexPath:(NSIndexPath *)originalIndexPath toProposedIndexPath:(NSIndexPath *)proposedIndexPath;
{
    return ( (originalIndexPath.section == proposedIndexPath.section) ? proposedIndexPath : originalIndexPath );
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;
{
    NSString *sectionKey = [[self.displayThese allKeys] sortedArrayUsingSelector:@selector(compare:)][sourceIndexPath.section];
    NSMutableArray *pictures = [self.displayThese objectForKey:sectionKey];
    Picture *picture = pictures[sourceIndexPath.row];
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
