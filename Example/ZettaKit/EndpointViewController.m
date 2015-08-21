//
//  EndpointViewController.m
//  ZettaKit
//
//  Created by Matthew Dobson on 8/21/15.
//  Copyright (c) 2015 Matthew Dobson. All rights reserved.
//

#import "EndpointViewController.h"
#import "ViewController.h"

@implementation EndpointViewController

- (IBAction)navigateEndpoint:(id)sender {
    [self performSegueWithIdentifier:@"servers" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *endpoint = self.endpoint.text;
    ViewController *vc = (ViewController *)[segue destinationViewController];
    vc.apiEndpoint = endpoint;
}

@end
