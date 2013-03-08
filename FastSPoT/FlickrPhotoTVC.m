//
//  FlickrPhotoTVC.m
//  Shutterbug
//
//  Created by Dominic Chan on 7/3/13.
//  Copyright (c) 2013 Dominic Chan. All rights reserved.
//

#import "FlickrPhotoTVC.h"
#import "FlickrFetcher.h"
#define ALL_RECENTS @"SPoT_All_Recents"

@interface FlickrPhotoTVC ()
@property (nonatomic) NSUInteger maxRecents;
@end

@implementation FlickrPhotoTVC

- (NSUInteger)maxRecents
{
    return 5;
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    [self.tableView reloadData];
}

- (void)saveToRecents: (NSDictionary *) photo viewedAt: (NSDate *)viewedAt
{
    NSMutableDictionary *mutableRecentPhotosFromUserDefaults = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RECENTS] mutableCopy];
    if (!mutableRecentPhotosFromUserDefaults) mutableRecentPhotosFromUserDefaults = [[NSMutableDictionary alloc] init];

    NSArray *recentPhotoIDs = [[mutableRecentPhotosFromUserDefaults allValues] valueForKey:FLICKR_PHOTO_ID];
    NSUInteger indexOfDuplicate = [recentPhotoIDs indexOfObject:photo[FLICKR_PHOTO_ID]];

    // delete old records
    if (indexOfDuplicate != NSNotFound) {
        [mutableRecentPhotosFromUserDefaults removeObjectForKey:[mutableRecentPhotosFromUserDefaults allKeys][indexOfDuplicate]];
    }
    
    // add new record
    mutableRecentPhotosFromUserDefaults[[viewedAt description]] = photo;

    // delete excessive records w.r.t self.maxRecents
    if ([[mutableRecentPhotosFromUserDefaults allKeys] count] > self.maxRecents) {
        NSArray *keysForRecents = [[mutableRecentPhotosFromUserDefaults allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        for (int i= [keysForRecents count]-self.maxRecents-1; i>=0; i--) {
            [mutableRecentPhotosFromUserDefaults removeObjectForKey:keysForRecents[i]];
        }
    }

    [[NSUserDefaults standardUserDefaults] setObject:mutableRecentPhotosFromUserDefaults forKey:ALL_RECENTS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]] ) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Show Image"]) {
                if ([segue.destinationViewController respondsToSelector:@selector(setImageURL:)]) {
                    
                    [self saveToRecents:self.photos[indexPath.row] viewedAt:[NSDate date]];
                    
                    NSURL *url = [FlickrFetcher urlForPhoto:self.photos[indexPath.row] format:FlickrPhotoFormatLarge];
                    [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:url];
                    [segue.destinationViewController setTitle:[self titleForRow:indexPath.row]];
                }
            }
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (NSString *) titleForRow: (NSUInteger) row
{
    return [self.photos[row][FLICKR_PHOTO_TITLE] description];
}

- (NSString *) subtitleForRow: (NSUInteger) row
{
    return [self.photos[row] valueForKeyPath: FLICKR_PHOTO_DESCRIPTION];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Flickr Photo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self titleForRow:indexPath.row];
    cell.detailTextLabel.text = [self subtitleForRow:indexPath.row];
    return cell;
}

@end
