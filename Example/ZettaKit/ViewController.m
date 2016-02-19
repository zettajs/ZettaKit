//
//  ViewController.m
//  ReactiveLearning
//
//  Created by Matthew Dobson on 4/1/15.
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


#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "DeviceTableViewController.h"
#import "ZIKDevice.h"
#import "ZIKServer.h"
#import "ZIKRoot.h"
#import "ZIKSession.h"
#import "ZIKStreamEntry.h"
#import "ZIKMultiplexStreamEntry.h"

@interface ViewController ()
    @property (nonatomic, retain) NSMutableArray *_servers;
    @property (nonatomic, retain) RACSignal *serverSignal;
@end

@implementation ViewController {
    ZIKStream *_stream;
    ZIKDevice *_device;
    ZIKDevice *_photocell;
    ZIKDevice *_led;
    ZIKStream *_devices;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    self._servers = [[NSMutableArray alloc] init];
    NSURL *url = [NSURL URLWithString:self.apiEndpoint];
    ZIKSession *session = [ZIKSession sharedSession];
    RACSignal *root = [session root:url];
    self.serverSignal = [session servers:root];
    RACSignal *collected = [self.serverSignal collect];
    @weakify(self)
    [collected subscribeNext:^(id x) {
        @strongify(self)
        NSLog(@"%@", x);
        [self._servers addObjectsFromArray:x];
        [self queryForDevices:(ZIKServer *)x[0]];
        //This is used to update UI from main thread.
        dispatch_async(dispatch_get_main_queue(), ^{
          [self.tableView reloadData];
        });
    }];
    

    [root subscribeNext:^(ZIKRoot *x) {
//        _stream = [x multiplexWebsocketStream];
//        [_stream resume];
//        NSLog(@"%@", _stream);
//        [_stream.signal subscribeNext:^(ZIKMultiplexStreamEntry *x) {
//            NSLog(@"%@", x);
//        }];
//        while (1) {
//            if ([_stream isOpen]) {
//                [_stream subscribe:@"*"];
//                break;
//            }
//        }
    }];
    
}

- (void) queryForDevices:(ZIKServer *)server {
    ZIKQuery *q = [ZIKQuery queryFromString:@"where type is not missing" fromServer:server];
    [[ZIKSession sharedSession] queryDevices:q withResponseCompletion:^(NSError *error, ZIKQueryResponse *devices) {
        _devices = [devices resultsStream];
        [_devices.signal subscribeNext:^(id x) {
            NSLog(@"ENTRY:%@", x);
        }];
        [_devices resume];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    ZIKServer *server = self._servers[indexPath.row];
    cell.textLabel.text = server.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"Devices" sender:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self._servers count];
}

- (NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return 1;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"Devices"])
    {
        // Get reference to the destination view controller
        DeviceTableViewController *vc = [segue destinationViewController];
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        ZIKServer *server = self._servers[path.row];
        RACSignal *filteredServerSignal = [self.serverSignal filter:^BOOL(ZIKServer *value) {
            return [server.name isEqualToString:value.name];
        }];
        vc.serverSignal = filteredServerSignal;
        // Pass any objects to the view controller here, like...
    }
}

@end
