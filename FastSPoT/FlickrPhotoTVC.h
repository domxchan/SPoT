//
//  FlickrPhotoTVC.h
//  FastSPoT
//
//  Created by Dominic Chan on 7/3/13.
//  Copyright (c) 2013 Dominic Chan. All rights reserved.
//
//  will call setImageURL: as part of any "Show Image" segue.

#import <UIKit/UIKit.h>

@interface FlickrPhotoTVC : UITableViewController

@property (strong, nonatomic) NSArray *photos; //of NSDictionary

@end
