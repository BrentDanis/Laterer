//
//  TutorialViewController.m
//  laterer
//
//  Created by Nimble Chapps on 10/04/15.
//  Copyright (c) 2015 NimbleChapps. All rights reserved.
//

#import "TutorialViewController.h"
#import "TutorialCVCell.h"

@interface TutorialViewController (){
    
    IBOutlet UIPageControl *pageNumber;
}

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation TutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = @[@"Tutorial1.jpg",@"Tutorial2.jpg",@"Tutorial3.jpg",@"Tutorial4.jpg",@"Tutorial5.jpg",@"Tutorial6.jpg",@"Tutorial7.jpg"];
    [self.collectionView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataArray count];
}

-(TutorialCVCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TutorialCVCell *cell = (TutorialCVCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    NSString *imgStr = [self.dataArray objectAtIndex:indexPath.row];
    [cell.imgView setImage:[UIImage imageNamed:imgStr]];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.collectionView.frame.size;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    for (UICollectionViewCell *cell in [self.collectionView visibleCells]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        pageNumber.currentPage = indexPath.row;
    }
}

- (IBAction)backToSettingVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
