//
//  ZIKSpdyDelegate.h
//  Pods
//
//  Created by Matthew Dobson on 6/12/15.
//
//

#import <Foundation/Foundation.h>
#import <ISpdy/ispdy.h>

@interface ZIKSpdyDelegate : NSObject<ISpdyRequestDelegate>

typedef void (^SPDYRequestCompletion)(ISpdyError *err, NSDictionary *headers, NSData *data);

+ (instancetype) initWithCompletion:(SPDYRequestCompletion) block;
- (id) initWithCompletion:(SPDYRequestCompletion) block;

@end
