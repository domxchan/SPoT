//
//  TagsOfStanfordFlickrPhotoTVC.m
//  FastSPoT
//
//  Created by Dominic Chan on 8/3/13.
//  Copyright (c) 2013 Dominic Chan. All rights reserved.
//

#import "TagsOfFlickrPhotosTVC.h"
#import "FlickrFetcher.h"

@interface TagsOfFlickrPhotosTVC ()
@property (strong, nonatomic) NSMutableDictionary *tagsDictionary;  // keys=tags; values=arrays of photos
@end

@implementation TagsOfFlickrPhotosTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"SPoT";
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    for (int i=0; i<[self.photos count]; i++) {
        NSArray *tagNames = [self.photos[i][FLICKR_TAGS] componentsSeparatedByString:@" "];
        for (int j=0; j<[tagNames count]; j++) {
            NSString *tagname = tagNames[j];
            if (![tagname isEqualToString:@"cs193pspot"] &&
                ![tagname isEqualToString:@"portrait"] &&
                ![tagname isEqualToString:@"landscape"]) {
                NSMutableArray *arrayForTag = [self.tagsDictionary valueForKey:tagname];
                if (arrayForTag) {
                    [arrayForTag addObject:self.photos[i]];
                } else {
                    arrayForTag = [NSMutableArray arrayWithObject:self.photos[i]];
                }
                self.tagsDictionary[tagname] = arrayForTag;
            }
        }
    }
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]] ) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Show Photos"]) {
                if ([segue.destinationViewController respondsToSelector:@selector(setPhotos:)]) {
                    NSArray *photosForTag = [self.tagsDictionary[[[self.tagsDictionary allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)][indexPath.item]] sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
                        return [[obj1 valueForKey:FLICKR_PHOTO_TITLE] compare:[obj2 valueForKey:FLICKR_PHOTO_TITLE]];
                    }];
                    [segue.destinationViewController performSelector:@selector(setPhotos:) withObject:photosForTag];
                    [segue.destinationViewController setTitle:[self titleForRow:indexPath.row]];
                }
            }
        }
    }
}

- (NSMutableDictionary *)tagsDictionary
{
    if (!_tagsDictionary) _tagsDictionary = [[NSMutableDictionary alloc] init];
    return _tagsDictionary;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.tagsDictionary allKeys] count];
}

- (NSString *)titleForRow: (NSUInteger)row
{
    return [[[self.tagsDictionary allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)][row] capitalizedString];
}

- (NSString *)subtitleForRow: (NSUInteger)row
{
    return [NSString stringWithFormat:@"%d photos", [self.tagsDictionary[[[self.tagsDictionary allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)][row]] count]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Flickr Photo Tag";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self titleForRow:indexPath.row];
    cell.detailTextLabel.text = [self subtitleForRow:indexPath.row];
    return cell;
}

@end
