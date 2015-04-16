# ZettaKit

[![CI Status](http://img.shields.io/travis/Matthew Dobson/ZettaKit.svg?style=flat)](https://travis-ci.org/zettajs/ZettaKit)
[![Version](https://img.shields.io/cocoapods/v/ZettaKit.svg?style=flat)](http://cocoapods.org/pods/ZettaKit)
[![License](https://img.shields.io/cocoapods/l/ZettaKit.svg?style=flat)](http://cocoapods.org/pods/ZettaKit)
[![Platform](https://img.shields.io/cocoapods/p/ZettaKit.svg?style=flat)](http://cocoapods.org/pods/ZettaKit)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

```objective-c

//How to fully crawl your Zetta API
ZIKSession *session = [ZIKSession sharedSession];

RACSignal *root = [session root:[NSURL URLWithString:@"http://zetta-cloud-2.herokuapp.com/"]];
RACSignal *servers = [session servers:root];
RACSignal *devices = [session devices:servers];

[root subscribeNext:^(ZIKRoot *root) {
  NSLog(@"%@", root);  
}];

[servers subscribeNext:^(ZIKServer *server) {
  NSLog(@"%@", server);  
}];

[devices subscribeNext:^(ZIKDevice *device) {
  NSLog(@"%@", device);  
}];

```

## Requirements

This library requires the following components

* `'ReactiveCocoa'@'2.4.7'`
* `'SocketRocket'@'0.3.1-beta2'`
 

## Installation

ZettaKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ZettaKit"
```

## Author

Matthew Dobson, matt@apigee.com

## License

ZettaKit is available under the MIT license. See the LICENSE file for more info.
