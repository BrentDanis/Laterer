//
//  JPLazyImageDownloader.h
//  LazyTableImages
//
//  Created by Chirag Leuva on 7/1/13.
//
//

#import <Foundation/Foundation.h>

typedef void(^JPLazyBlock)(UIImage* image,NSIndexPath* path);

@interface JPLazyImageDownloader : NSObject

// set place holder or will load default place holder
- (void)setPlaceHolderImage:(UIImage*)imgPlace;

// Use this method in didEndDisplayCell
- (void)cancelDownlingForIndexPath:(NSIndexPath*)indexPath;

// load cell from indexpath if delay flag is YES
-(void)downloadImageFromUrl:(NSString*)urlString
               forIndexPath:(NSIndexPath*)indexPath
            completionBlock:(JPLazyBlock)block;

// loads thumb first and then main image
-(void)downloadImageFromUrl:(NSString*)urlString
                   thumbUrl:(NSString*)thumbString
               forIndexPath:(NSIndexPath*)indexPath
            completionBlock:(JPLazyBlock)block;


/*
// Use this method in cellForRow
- (void)downloadImageFromUrl:(NSString*)urlString
               forIndexPath:(id)indexPath
           DownloadingBlock:(void(^)(NSIndexPath* indexPath,UIImage* image))loadedBlock
            CompletionBlock:(void(^)(UIImage* image))block;

//[self.imgDownloader downloadImageFromUrl:txtDict[@"attachment"][@"vFile"][@"original"]
//                            forIndexPath:indexPath
//                        DownloadingBlock:^(NSIndexPath *indexPath, UIImage *image)
// {
//     NMChatCell *aCell = (NMChatCell*)[tableView cellForRowAtIndexPath:indexPath];
//     if(aCell)
//         [aCell.imgView setImage:image];
// } CompletionBlock:^(UIImage *image)
// {
//     [cell.imgView setImage:image];
// }];
 */

@end
