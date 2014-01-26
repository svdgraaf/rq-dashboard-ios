//
//  rqQueue.m
//  rq-dashboard
//
//  Created by Sander van de Graaf on 1/15/14.
//  Copyright (c) 2014 Serinus42. All rights reserved.
//

#import "rqQueue.h"
#import <RestKit/RestKit.h>

@implementation rqQueue

@synthesize name;
@synthesize url;
@synthesize count;

- (void)empty {
    AFHTTPClient *httpClient = [RKObjectManager sharedManager].HTTPClient;
    [httpClient postPath:[NSString stringWithFormat:@"/queue/%@/empty", self.name] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // all ok
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // TODO: should we show an error?
    }];
}

+ (void)addMappingTo:(RKObjectManager *)manager {
    RKObjectMapping *queueMapping = [RKObjectMapping mappingForClass:[self class]];
    [queueMapping addAttributeMappingsFromDictionary:@{
                                                       @"url": @"url",
                                                       @"count": @"count",
                                                       @"name": @"name",
                                                       }];
    
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:queueMapping
                                                                                            method:RKRequestMethodGET
                                                                                       pathPattern:@"queues\\.json"
                                                                                           keyPath:@"queues"
                                                                                       statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [manager addResponseDescriptor:responseDescriptor];
}

@end
