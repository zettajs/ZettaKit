//
//  ZIKMultiplexStreamEntry.h
//  Pods
//
//  Created by Matthew Dobson on 1/27/16.
//
//

#import "ZIKStreamEntry.h"

@interface ZIKMultiplexStreamEntry : ZIKStreamEntry

@property (nonatomic, retain, readonly) NSString *subscriptionId;
@property (nonatomic, retain, readonly) NSString *type;
@property (nonatomic, retain, readonly) NSNumber *code;
@property (nonatomic, retain, readonly) NSString *message;

+ (instancetype) initWithDictionary:(NSDictionary *)data;

- (instancetype) initWithDictionary:(NSDictionary *)data;

@end
