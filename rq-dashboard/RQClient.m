//
//  RQClient.m
//  rq-dashboard
//
//  Created by Sander van de Graaf on 1/26/14.
//  Copyright (c) 2014 Serinus42. All rights reserved.
//

#import "RQClient.h"
#import "RQJob.h"
#import "RQWorker.h"
#import "rqQueue.h"
#import <RestKit/RestKit.h>
#import <RestKit/Network/RKObjectManager.h>


@implementation RQClient

+ (void)initialize {
    //let AFNetworking manage the activity indicator
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    // Initialize HTTPClient
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *server_url = [defaults objectForKey:@"server_url"];
    NSString *server_username = [defaults objectForKey:@"server_username"];
    NSString *server_password = [defaults objectForKey:@"server_password"];
    
    NSURL *baseURL = [NSURL URLWithString:server_url];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // we want to work with JSON-Data
    [client setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
    
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    if([server_username length] != 0) {
        [objectManager.HTTPClient setAuthorizationHeaderWithUsername:server_username password:server_password];
    }

    [RQJob addMappingTo:objectManager];
    [RQWorker addMappingTo:objectManager];
    [rqQueue addMappingTo:objectManager];
}

+ (void)reset {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *server_url = [defaults objectForKey:@"server_url"];

    RKObjectManager *newManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:server_url]];
    [newManager setRequestSerializationMIMEType:RKMIMETypeJSON];
    [newManager setAcceptHeaderWithMIMEType:RKMIMETypeJSON];
    [newManager addResponseDescriptorsFromArray:[RKObjectManager sharedManager].responseDescriptors];
    [newManager addRequestDescriptorsFromArray:[RKObjectManager sharedManager].requestDescriptors];
    [RKObjectManager setSharedManager:newManager];
}

- (void)setAuthentication {
    
}

- (void)setBaseurl {
    
}

- (void)setMappings {
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [RQJob addMappingTo:manager];
    [RQWorker addMappingTo:manager];
    [rqQueue addMappingTo:manager];
}



@end
