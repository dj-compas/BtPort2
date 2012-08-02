//
//  ResultsViewController.h
//  BtPort2
//
//  Created by Michael Compas on 8/2/12.
//  Copyright (c) 2012 Concentric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultsViewController : UITableViewController <UINavigationControllerDelegate>

@property (nonatomic, strong) NSString *query;
@property (nonatomic, strong) id delegate;
@property (nonatomic, assign) int scope;

@end
