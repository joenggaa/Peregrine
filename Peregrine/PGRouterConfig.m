//
//  PGRouterConfig.m
//  Peregrine
//
//  Created by Rake Yang on 2019/5/13.
//  Copyright © 2019 BinaryParadise. All rights reserved.
//

#import "PGRouterConfig.h"

@implementation PGRouterConfig

- (instancetype)initWithDictionary:(NSDictionary<NSString *, NSString *> *)keyValues {
    if (self = [super init]) {
        NSString *URLString = keyValues[PGRouterKeyURL];
        _URL = [NSURL URLWithString:URLString];
        if (!_URL) {
            NSString *encodeURLString = [URLString  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            _URL = [NSURL URLWithString:encodeURLString];
        }
        _targetClass = NSClassFromString(keyValues[PGRouterKeyClass]);
        _selector = NSSelectorFromString(keyValues[PGRouterKeySelector]);
    }
    return self;
}

- (NSString *)actionName {
    if (self.URL.pathComponents.count > 1) {
        return self.URL.pathComponents[1];
    }
    return nil;
}

@end
