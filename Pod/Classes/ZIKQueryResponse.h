//
//  ZIKQueryResponse.h
//  Pods
//
//  Created by Matthew Dobson on 2/17/16.
//
//

#import "ZIKStream.h"

#import <Foundation/Foundation.h>

@interface ZIKQueryResponse : NSObject

@property (nonatomic, retain, readonly) NSArray *links;
@property (nonatomic, retain) NSArray *devices;
@property (nonatomic, retain, readonly) NSString *server;
@property (nonatomic, retain,readonly) NSString *ql;

-(instancetype) initWithDictionary:(NSDictionary *) data;
+(instancetype) initWithDictionary:(NSDictionary *) data;

-(ZIKStream *) resultsStream;

@end