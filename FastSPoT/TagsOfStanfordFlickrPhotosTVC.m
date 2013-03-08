//
//  TagsOfStanfordFlickrPhotosTVC.m
//  SPoT
//
//  Created by Dominic Chan on 8/3/13.
//  Copyright (c) 2013 Dominic Chan. All rights reserved.
//

#import "TagsOfStanfordFlickrPhotosTVC.h"
#import "FlickrFetcher.h"

@interface TagsOfStanfordFlickrPhotosTVC ()

@end

@implementation TagsOfStanfordFlickrPhotosTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photos = [FlickrFetcher stanfordPhotos];
}

@end
