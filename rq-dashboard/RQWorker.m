//
//  RQWorker.m
//  rq-dashboard
//
//  Created by Sander van de Graaf on 1/25/14.
//  Copyright (c) 2014 Serinus42. All rights reserved.
//

#import "RQWorker.h"
#import <RestKit/RestKit.h>

@implementation RQWorker

+ (void)addMappingTo:(RKObjectManager *)manager {
    RKObjectMapping *workerMapping = [RKObjectMapping mappingForClass:[RQWorker class]];
    [workerMapping addAttributeMappingsFromDictionary:@{
                                                        @"queues": @"queues",
                                                        @"name": @"name",
                                                        @"state": @"state",
                                                        }];
    RKResponseDescriptor *workerResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:workerMapping
                                                                                                  method:RKRequestMethodGET
                                                                                             pathPattern:@"workers\\.json"
                                                                                                 keyPath:@"workers"
                                                                                             statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [manager addResponseDescriptor:workerResponseDescriptor];
    
}
@end
