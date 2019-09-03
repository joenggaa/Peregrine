//
//  PGRouterManager.h
//  Peregrine
//
//  Created by Rake Yang on 2019/5/6.
//  Copyright © 2019 BinaryParadise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGRouterGroup.h"

#define PGTarget(_router) __attribute__((pe_routed(_router, 10.0)))

@class PGRouterConfig;

@interface PGRouterManager<__covariant ObjectType> : NSObject

+ (NSDictionary<NSString *, PGRouterGroup *> *)routerMap;

/**
 Open a URLString that you have registered in this manager.

 @param URLString The URL string with which to initialize the NSURL object. Must be a URL that conforms to RFC 2396. This method parses URLString according to RFCs 1738 and 1808.
 @param completion callback
 */
+ (void)openURL:(NSString *)URLString completion:(void (^)(BOOL ret, ObjectType object))completion;

@end
