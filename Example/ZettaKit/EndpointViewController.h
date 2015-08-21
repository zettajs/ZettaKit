//
//  EndpointViewController.h
//  ZettaKit
//
//  Created by Matthew Dobson on 8/21/15.
//  Copyright (c) 2015 Matthew Dobson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EndpointViewController : UIViewController

@property (nonatomic, retain) IBOutlet UITextField *endpoint;

- (IBAction)navigateEndpoint:(id)sender;

@end
