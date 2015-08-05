//
//  ZIKTransitionViewController.m
//  ZettaKit
//
//  Created by Matthew Dobson on 6/19/15.
//  Copyright (c) 2015 Matthew Dobson. All rights reserved.
//

#import "ZIKTransitionViewController.h"

@interface ZIKTransitionViewController ()

@property (nonatomic) BOOL hasDataFields;
@property (nonatomic) NSMutableArray *fields;

@end

@implementation ZIKTransitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.transition.name;
    if (self.transition.fields.count > 1) {
        self.hasDataFields = YES;
        self.fields = [[NSMutableArray alloc] init];
    } else {
        self.hasDataFields = NO;
    }
    [self generateUI];
}

//Generate the UI for the particular action.
- (void) generateUI {
    int iteration = 1;
    for (NSDictionary *field in self.transition.fields) {
        float height = 30.0;
        float width = 100.0;
        float mid = CGRectGetMidX(self.view.frame);
        float x = mid - (mid / 4);
        float y = 150 + ((iteration - 1) * height);
        CGRect rect = CGRectMake(x, y, width, height);
        if ([field[@"type"] isEqualToString:@"hidden"]) {
            UIButton *button = [[UIButton alloc] initWithFrame:rect];
            [button setTitle:field[@"value"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(performAction) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button];
        } else if ([self isTextBoxType:field[@"type"]]) {
            UITextField *text = [[UITextField alloc] initWithFrame:rect];
            text.tag = iteration;
            text.layer.borderWidth = 1.0f;
            text.layer.borderColor = [[UIColor grayColor] CGColor];
            [self.fields addObject:@{@"name": field[@"name"], @"tag":[NSNumber numberWithInt:iteration], @"type": field[@"type"]}];
            [self.view addSubview:text];
        } else if ([field[@"type"] isEqualToString:@"checkbox"]) {
            UISwitch *switchInput = [[UISwitch alloc] initWithFrame:rect];
            switchInput.tag = iteration;
            [self.fields addObject:@{@"name": field[@"name"], @"tag":[NSNumber numberWithInt:iteration], @"type": field[@"type"]}];
            [self.view addSubview:switchInput];
        } else if ([field[@"type"] isEqualToString:@"radio"]) {
            UISegmentedControl *segment = [[UISegmentedControl alloc] initWithFrame:rect];
            int i = 0;
            for (NSDictionary *value in field[@"value"]) {
                [segment insertSegmentWithTitle:value[@"value"] atIndex:i animated:NO];
                i++;
            }
            [self.fields addObject:@{@"name": field[@"name"], @"tag":[NSNumber numberWithInt:iteration], @"type": field[@"type"], @"value": field[@"value"]}];
            [self.view addSubview:segment];
        }
        iteration++;
    }
}

- (BOOL) isTextBoxType:(NSString *)type {
    return [type isEqualToString:@"text"] || [type isEqualToString:@"search"] || [type isEqualToString:@"number"];
}

//Perform the action of the device
- (void) performAction {
    if (self.hasDataFields) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        for (NSDictionary *field in self.fields) {
            NSString *type = (NSString *)field[@"type"];
            NSString *name = (NSString *)field[@"name"];
            NSNumber *tag = (NSNumber *)field[@"tag"];

            if ([self isTextBoxType:type]) {
                UITextField *textField = (UITextField *)[self.view viewWithTag:[tag integerValue]];
                NSString *text = textField.text;
                [dict setObject:text forKey:name];
            } else if([type isEqualToString:@"checkbox"]) {
                UISwitch *switchInput = (UISwitch *)[self.view viewWithTag:[tag integerValue]];
                BOOL switchState = switchInput.selected;
                [dict setObject:[NSNumber numberWithBool:switchState] forKey:name];
            } else if([type isEqualToString:@"radio"]) {
                UISegmentedControl *segment = (UISegmentedControl *)[self.view viewWithTag:[tag integerValue]];
                NSArray *value = (NSArray *)field[@"value"];
                NSDictionary *selected = value[segment.selectedSegmentIndex];
                [dict setObject:selected[@"value"] forKey:name];
            }
        }
        
        [self.device transition:self.transition.name withArguments:dict andCompletion:^(NSError *err, ZIKDevice *device) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.device = device;
                [self transitionBack];
                
            });
        }];
    } else {
        [self.device transition:self.transition.name andCompletion:^(NSError *err, ZIKDevice *device) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.device = device;
                [self transitionBack];
            });
        }];
    }

}

//Transition back to the previous view controller
- (void) transitionBack {
    [self performSegueWithIdentifier:@"unwindFromTransition" sender:self];
}
@end
