//
//  TagsOfStanfordFlickrPhotosTVC.m
//  FastSPoT
//
//  Created by Dominic Chan on 8/3/13.
//  Copyright (c) 2013 Dominic Chan. All rights reserved.
//

#import "TagsOfStanfordFlickrPhotosTVC.h"
#import "FlickrFetcher.h"

@interface TagsOfStanfordFlickrPhotosTVC ()

@end

@implementation TagsOfStanfordFlickrPhotosTVC

- (void)loadLatestPhotosFromFlickr {
    [self.refreshControl beginRefreshing];
    dispatch_queue_t loaderQ = dispatch_queue_create("Flickr Latest Loader", NULL);
    dispatch_async(loaderQ, ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES; //bad
        NSArray *latestPhotos = [FlickrFetcher stanfordPhotos];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO; //bad
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photos = latestPhotos;
            [self.refreshControl endRefreshing];
        });
    });
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadLatestPhotosFromFlickr];
    [self.refreshControl addTarget:self action:@selector(loadLatestPhotosFromFlickr) forControlEvents:UIControlEventValueChanged];
}

@end
