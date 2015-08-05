//
//  ZIKDeviceViewController.m
//  ZettaKit
//
//  Created by Matthew Dobson on 6/19/15.
//  Copyright (c) 2015 Matthew Dobson. All rights reserved.
//

#import "ZIKDeviceViewController.h"
#import "ZIKTransition.h"
#import "ZIKLink.h"
#import "ZIKTransitionViewController.h"
@interface ZIKDeviceViewController ()

@property (nonatomic, retain) NSMutableArray *properties;

@end

@implementation ZIKDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *sectionName;
    switch (section) {
        case 0:
            sectionName = @"properties";
            break;
        case 1:
            sectionName = @"actions";
            break;
        case 2:
            sectionName = @"links";
            break;
        default:
            break;
    }
    return sectionName;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    
    switch (section) {
        case 0:
            rows = [[self.device.properties allKeys] count];
            break;
        case 1:
            rows = self.device.transitions.count;
            break;
        case 2:
            rows = self.device.links.count;
            break;
        default:
            break;
    }
    
    return rows;

}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.textColor = [UIColor colorWithRed:51./255.
                                               green:153./255.
                                                blue:204./255.
                                               alpha:1.0];
    
    NSDictionary *cellDescription = [self cellDescriptionForIndexPath:indexPath];
    NSLog(@"%@", cellDescription);
    cell.textLabel.text = cellDescription[@"description"];
    if (cellDescription[@"subtitle"] != nil) {
        cell.detailTextLabel.text = cellDescription[@"subtitle"];
    } else {
        cell.detailTextLabel.text = @"";
    }
    
    if (indexPath.section == 1) {
        cell.userInteractionEnabled = YES;
    } else {
        cell.userInteractionEnabled = NO;
    }
    
    if (cellDescription[@"isStream"] != nil && ![cellDescription[@"isStream"]  isEqual: @0]) {
        cell.userInteractionEnabled = YES;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return 1;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.    if ([[segue identifier] isEqualToString:@"Devices"])
    if ([[segue identifier] isEqualToString:@"Transition"])
    {
        // Get reference to the destination view controller
        ZIKTransitionViewController *vc = [segue destinationViewController];
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        
        vc.device = self.device;
        if (path.section == 1) {
            vc.transition = self.device.transitions[path.row];
            vc.stream = nil;
        } else if (path.section == 0) {
            vc.transition = nil;
            NSArray *keys = [self.device.properties allKeys];
            vc.stream = [self.device stream:keys[path.row]];
        }
        // Pass any objects to the view controller here, like...
    }
    
}

- (NSDictionary *)cellDescriptionForIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *descriptions;
    switch (indexPath.section) {
        case 0:
            descriptions = [self propertyDescriptionForIndexPath:indexPath];
            break;
        case 1:
            descriptions = [self transitionDescriptionForIndexPath:indexPath];
            break;
        case 2:
            descriptions = [self linkDescriptionForIndexPath:indexPath];
            break;
        default:
            break;
    }
    return descriptions;
}

- (NSDictionary *) propertyDescriptionForIndexPath:(NSIndexPath *)indexPath {
    NSArray *keys = [self.device.properties allKeys];
    NSString *key = keys[indexPath.row];
    id prop = self.device.properties[key];
    NSString *stringProp = [NSString stringWithFormat:@"%@", prop];
    NSNumber *num = @0;
    for (ZIKLink *link in self.device.links) {
        if (link.title != nil && [link.title isEqualToString:key]) {
            num = @1;
        }
    }
    return @{@"description": stringProp, @"subtitle": key, @"isStream": num};
}

- (NSDictionary *) transitionDescriptionForIndexPath:(NSIndexPath *)indexPath {
    ZIKTransition *transitionDesc = self.device.transitions[indexPath.row];
    return @{@"description": transitionDesc.name};
    
}

- (NSDictionary *) linkDescriptionForIndexPath:(NSIndexPath *)indexPath {
    ZIKLink *link = self.device.links[indexPath.row];
    NSString *desc = link.title != nil ? link.title : link.href;
    return @{@"description": desc};
}

- (IBAction)unwindFromAction:(UIStoryboardSegue *)sender {
    ZIKTransitionViewController *t = (ZIKTransitionViewController *)sender.sourceViewController;
    self.device = t.device;
    [self.tableView reloadData];
}


@end
