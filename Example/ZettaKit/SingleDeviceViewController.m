//
//  SingleDeviceViewController.m
//  ReactiveLearning
//
//  Created by Matthew Dobson on 4/10/15.
//  Copyright (c) 2015 Apigee and Contributors <matt@apigee.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


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

- (IBAction)unwindFromAction:(UIStoryboardSegue *)sender {
    
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
