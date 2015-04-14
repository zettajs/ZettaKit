//
//  ViewController.m
//  ReactiveLearning
//
//  Created by Matthew Dobson on 4/1/15.
//  Copyright (c) 2015 Matthew Dobson. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "DeviceTableViewController.h"
#import "ZIKDevice.h"
#import "ZIKServer.h"
#import "ZIKRoot.h"
#import "ZIKSession.h"
#import "ZIKStreamEntry.h"

@interface ViewController ()
    @property (nonatomic, retain) NSMutableArray *_servers;
    @property (nonatomic, retain) RACSignal *serverSignal;
@end

@implementation ViewController {
    ZIKStream *_stream;
    ZIKDevice *_device;
    ZIKDevice *_photocell;
    ZIKDevice *_led;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    self._servers = [[NSMutableArray alloc] init];
    NSURL *url = [NSURL URLWithString:@"http://zt-1-mdobs.herokuapp.com/"];
    ZIKSession *session = [ZIKSession sharedSession];
    RACSignal *root = [session root:url];
    self.serverSignal = [session servers:root];
    RACSignal *collected = [self.serverSignal collect];
    @weakify(self)
    [collected subscribeNext:^(id x) {
        @strongify(self)
        [self._servers addObjectsFromArray:x];
        
        //This is used to update UI from main thread.
        dispatch_async(dispatch_get_main_queue(), ^{
          [self.tableView reloadData];
        });
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
