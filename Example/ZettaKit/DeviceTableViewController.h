//
//  DeviceTableViewController.h
//  ReactiveLearning
//
//  Created by Matthew Dobson on 4/10/15.
//  Copyright (c) 2015 Matthew Dobson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface DeviceTableViewController : UITableViewController

@property (nonatomic, retain) RACSignal *serverSignal;

@end
