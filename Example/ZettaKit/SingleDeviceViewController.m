//
//  SingleDeviceViewController.m
//  ReactiveLearning
//
//  Created by Matthew Dobson on 4/10/15.
//  Copyright (c) 2015 Matthew Dobson. All rights reserved.
//

#import "SingleDeviceViewController.h"
#import "ZIKStreamEntry.h"
#import "ZIKLogStreamEntry.h"
#import "ZIKTransition.h"

@interface SingleDeviceViewController ()

@property (nonatomic, retain) ZIKTransition *transition;
@property (nonatomic, retain) ZIKStream *streamSignal;
@property (nonatomic, retain) ZIKStream *logStream;

@end

@implementation SingleDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.type.text = self.device.type;
    self.uuid.text = self.device.uuid;
    self.name.text = self.device.name;
    
    
    if ([self.device.type isEqualToString:@"led"]) {
        self.action.hidden = NO;
        self.transition = (ZIKTransition *)self.device.transitions[0];
        [self.action setTitle:self.transition.name forState:UIControlStateNormal];
        self.stream.hidden = YES;
        
    } else if ([self.device.type isEqualToString:@"photocell"]) {
        self.streamSignal = [self.device stream:@"intensity"];
        __block SingleDeviceViewController *vc = self;
        [self.streamSignal.signal subscribeNext:^(ZIKStreamEntry *x) {
            dispatch_async(dispatch_get_main_queue(), ^{
                vc.stream.text = [NSString stringWithFormat:@"%@", x.data];
            });
        }];
        [self.streamSignal resume];
        self.action.hidden = YES;
    } else {
        self.action.hidden = YES;
    }
    
    
    self.logStream = [self.device stream:@"logs"];
    [self.logStream.signal subscribeNext:^(ZIKLogStreamEntry *x) {
        NSString *entry = [NSString stringWithFormat:@"Transition to %@ with %@\n", x.deviceState, x.transition];
        self.stateScroller.text = [NSString stringWithFormat:@"%@%@", self.stateScroller.text, entry];
        NSRange range = NSMakeRange(self.stateScroller.text.length - 1, 1);
        [self.stateScroller scrollRangeToVisible:range];
    }];
    [self.logStream resume];
    
    [self.action addTarget:self action:@selector(turnOn) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}

-(void) turnOn {
    [self.device transition:self.transition.name andCompletion:^(NSError *err, ZIKDevice *device) {
        if(err == nil) {
            NSLog(@"%@", device);
            self.device = device;
            self.transition = self.device.transitions[0];
            [self.action setTitle:self.transition.name forState:UIControlStateNormal];
        } else {
            NSLog(@"Error:%@", err);
        }
    }];
    
}
     
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
