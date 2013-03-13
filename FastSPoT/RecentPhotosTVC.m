//
//  RecentPhotosTVC.m
//  FastSPoT
//
//  Created by Dominic Chan on 8/3/13.
//  Copyright (c) 2013 Dominic Chan. All rights reserved.
//

#import "RecentPhotosTVC.h"
#define ALL_RECENTS @"SPoT_All_Recents"

@interface RecentPhotosTVC ()

@end

@implementation RecentPhotosTVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Recents";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    [self refreshOrderAndSetPhotos];
}

- (void)refreshOrderAndSetPhotos
{
    NSDictionary *recentPhotosDictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RECENTS];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO selector:@selector(compare:)];
    NSArray *photosKeysSortedByDate = [[recentPhotosDictionary allKeys] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    NSMutableArray *arrayOfPhotosSortedByDate = [[NSMutableArray alloc] init];
    for (NSString *key in photosKeysSortedByDate) {
        [arrayOfPhotosSortedByDate addObject:recentPhotosDictionary[key]];
    }
    //    NSLog(@"self.photos: %@", arrayOfPhotosSortedByDate);
    self.photos = arrayOfPhotosSortedByDate;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self refreshOrderAndSetPhotos];
}

@end
