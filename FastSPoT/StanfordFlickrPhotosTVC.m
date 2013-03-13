//
//  StanfordFlickrPhotosTVC.m
//  FastSPoT
//
//  Created by Dominic Chan on 7/3/13.
//  Copyright (c) 2013 Dominic Chan. All rights reserved.
//

#import "StanfordFlickrPhotosTVC.h"
#import "FlickrFetcher.h"

@interface StanfordFlickrPhotosTVC ()

@end

@implementation StanfordFlickrPhotosTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photos = [FlickrFetcher stanfordPhotos];
}

@end
