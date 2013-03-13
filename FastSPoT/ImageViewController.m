//
//  ImageViewController.m
//  FastSPoT
//
//  Created by Dominic Chan on 7/3/13.
//  Copyright (c) 2013 Dominic Chan. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>
@property (strong, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end

@implementation ImageViewController

- (void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    [self resetImage];
}

- (NSURL *)cache_file
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSURL *base_url = [fileManager URLsForDirectory:(NSCachesDirectory) inDomains:NSUserDomainMask][0];
    NSString *path = [[@"FlickrImages" stringByAppendingString:[self.imageURL relativePath]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [base_url URLByAppendingPathComponent: path isDirectory:NO];
}

- (NSString *)cache_path
{
    return [[[self cache_file] URLByDeletingLastPathComponent] path];
}

- (BOOL)cache_path_exists
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    return [fileManager createDirectoryAtPath:[self cache_path]
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:nil];
}

- (NSData *)loadImageData
{
    // implementing cache
    // 1. lookup cachesDirectory to see if image has been cached -- identifier is the URL
    // 2. if not cached, fetch from flickr
    // 2.1 cache image
    // 3. set self.imageURL to cache

    NSData *imageData;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if (![fileManager fileExistsAtPath:[[self cache_file] path]]) {
        NSLog(@"Not cached");
        if ([self cache_path_exists]) {
            imageData = [[NSData alloc] initWithContentsOfURL: self.imageURL];
            [imageData writeToFile:[[self cache_file] path] atomically:YES];
            NSLog(@"Written to file");
        }
    } else {
        NSLog(@"Cached");
        imageData = [[NSData alloc] initWithContentsOfURL:[self cache_file]];
    }
    return imageData;
}

- (void)resetImage
{
    if (self.imageView) {
        self.scrollView.contentSize = CGSizeZero;
        self.imageView.image = nil;
        [self.spinner startAnimating];

        __block NSURL *imageURL = self.imageURL;
        dispatch_queue_t imageFetchQ = dispatch_queue_create("image fetcher", NULL);
        dispatch_async(imageFetchQ, ^{
            [NSThread sleepForTimeInterval:2.0];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES; //bad
            NSData *imageData = [self loadImageData];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO; //bad
            
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            
            if (self.imageURL == imageURL) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (image) {
                        self.scrollView.zoomScale = 1.0;
                        self.scrollView.contentSize = image.size;
                        self.imageView.image = image;
                        self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
                    }
                    [self.spinner stopAnimating];
                    [self autozoom];
                });
            }
        });
    }
}

- (UIImageView *)imageView
{
    if (!_imageView) _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    return _imageView;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
    self.scrollView.minimumZoomScale = 0.2;
    self.scrollView.maximumZoomScale = 5.0;
    self.scrollView.delegate = self;
//    [self resetImage];
}

- (void)autozoom
{
    self.scrollView.zoomScale = MAX(self.scrollView.bounds.size.width/self.imageView.image.size.width,
                                    self.scrollView.bounds.size.height/self.imageView.image.size.height);
//    [self.scrollView zoomToRect:self.imageView.frame animated:YES];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self autozoom];
}

- (void)viewDidLayoutSubviews
{
    NSLog(@"imageView: %@", self.imageView.image);
    [self autozoom];
}

@end
