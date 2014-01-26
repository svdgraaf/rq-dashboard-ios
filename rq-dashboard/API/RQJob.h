//
//  RQJob.h
//  rq-dashboard
//
//  Created by Sander van de Graaf on 1/15/14.
//  Copyright (c) 2014 Serinus42. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface RQJob : NSObject
@property (strong, nonatomic) NSString *origin;
@property (strong, nonatomic) NSString *ended_at;
@property (strong, nonatomic) NSString *created_at;
@property (strong, nonatomic) NSString *enqueued_at;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *result;
@property (strong, nonatomic) NSString *exc_info;
@property (strong, nonatomic) NSString *identifier;

- (void)cancel;
- (void)requeue;
+ (void)addMappingTo:(RKObjectManager *)manager;
@end
