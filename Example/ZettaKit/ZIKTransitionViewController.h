//
//  ZIKTransitionViewController.h
//  ZettaKit
//
//  Created by Matthew Dobson on 6/19/15.
//  Copyright (c) 2015 Matthew Dobson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZIKDevice.h"
#import "ZIKTransition.h"
#import "ZIKStream.h"

@interface ZIKTransitionViewController : UIViewController

@property (nonatomic, retain) ZIKDevice *device;
@property (nonatomic, retain) ZIKTransition *transition;
@property (nonatomic, retain) ZIKStream *stream;
@property (nonatomic, retain) IBOutlet UILabel *value;
@property (nonatomic, retain) IBOutlet UILabel *timestamp;
@property (nonatomic, retain) IBOutlet UILabel *timestampLabel;
@property (nonatomic, retain) IBOutlet UILabel *valueLabel;

@end
