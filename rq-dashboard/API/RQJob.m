//
//  RQJob.m
//  rq-dashboard
//
//  Created by Sander van de Graaf on 1/15/14.
//  Copyright (c) 2014 Serinus42. All rights reserved.
//

#import "RQJob.h"
#import <RestKit/RestKit.h>

@implementation RQJob

@synthesize origin;
@synthesize ended_at;
@synthesize created_at;
@synthesize enqueued_at;
@synthesize description;
@synthesize result;
@synthesize exc_info;
@synthesize identifier;


- (void)cancel {
    AFHTTPClient *httpClient = [RKObjectManager sharedManager].HTTPClient;
    [httpClient postPath:[NSString stringWithFormat:@"/job/%@/cancel", self.identifier] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response: %@", responseObject);
        // all ok
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // TODO: should we show an error?
    }];
}

- (void)requeue {
    AFHTTPClient *httpClient = [RKObjectManager sharedManager].HTTPClient;
    [httpClient postPath:[NSString stringWithFormat:@"/job/%@/requeue", self.identifier] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // all ok
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // TODO: should we show an error?
    }];
}

+ (void)addMappingTo:(RKObjectManager *)manager {
    RKObjectMapping *jobMapping = [RKObjectMapping mappingForClass:[self class]];
    [jobMapping addAttributeMappingsFromDictionary:@{
                                                     @"origin": @"origin",
                                                     @"ended_at": @"ended_at",
                                                     @"created_at": @"created_at",
                                                     @"enqueued_at": @"enqueued_at",
                                                     @"description": @"description",
                                                     @"result": @"result",
                                                     @"exc_info": @"exc_info",
                                                     @"id": @"identifier",
                                                     }];
    
    
    RKResponseDescriptor *jobResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:jobMapping
                                                                                               method:RKRequestMethodGET
                                                                                          pathPattern:@"jobs/:name\\.json"
                                                                                              keyPath:@"jobs"
                                                                                          statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [manager addResponseDescriptor:jobResponseDescriptor];
}

@end
