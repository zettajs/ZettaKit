//
//  SingleDeviceViewController.h
//  ReactiveLearning
//
//  Created by Matthew Dobson on 4/10/15.
//  Copyright (c) 2015 Matthew Dobson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZIKDevice.h"

@interface SingleDeviceViewController : UIViewController

@property (nonatomic, retain) ZIKDevice *device;

@property (nonatomic, retain) IBOutlet UILabel *type;
@property (nonatomic, retain) IBOutlet UILabel *uuid;
@property (nonatomic, retain) IBOutlet UILabel *name;
@property (nonatomic, retain) IBOutlet UILabel *stream;
@property (nonatomic, retain) IBOutlet UIButton *action;
@property (nonatomic, retain) IBOutlet UITextView *stateScroller;


@end
