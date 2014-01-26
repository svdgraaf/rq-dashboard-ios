//
//  RQWorker.h
//  rq-dashboard
//
//  Created by Sander van de Graaf on 1/25/14.
//  Copyright (c) 2014 Serinus42. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface RQWorker : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSArray *queues;

+ (void)addMappingTo:(RKObjectManager *)manager;
@end
