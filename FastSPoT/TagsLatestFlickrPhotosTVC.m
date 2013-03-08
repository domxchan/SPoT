//
//  TagsLatestFlickrPhotosTVC.m
//  FastSPoT
//
//  Created by Dominic Chan on 8/3/13.
//  Copyright (c) 2013 Dominic Chan. All rights reserved.
//

#import "TagsLatestFlickrPhotosTVC.h"
#import "FlickrFetcher.h"

@interface TagsLatestFlickrPhotosTVC ()

@end

@implementation TagsLatestFlickrPhotosTVC

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
    self.photos = [FlickrFetcher latestGeoreferencedPhotos];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
