//
//  rqAppDelegate.m
//  rq-dashboard
//
//  Created by Sander van de Graaf on 1/15/14.
//  Copyright (c) 2014 Serinus42. All rights reserved.
//

#import "rqAppDelegate.h"
#import <RestKit/RestKit.h>
#import <RestKit/Network/RKObjectManager.h>
#import "rqQueue.h"

@implementation rqAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //let AFNetworking manage the activity indicator
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;

    // Initialize HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"http://brunhilda.allestoringen.nl:9181/"];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];

    //we want to work with JSON-Data
    [client setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
    
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
//    [objectManager.HTTPClient setAuthorizationHeaderWithUsername:@"username" password:@"password"];
    
    RKObjectMapping *queueMapping = [RKObjectMapping mappingForClass:[rqQueue class]];
    [queueMapping addAttributeMappingsFromDictionary:@{
                                                         @"url": @"url",
                                                         @"count": @"count",
                                                         @"name": @"name",
                                                         }];
    
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:queueMapping
                                                                                            method:RKRequestMethodGET
                                                                                       pathPattern:@"queues.json"
                                                                                           keyPath:@"queues"
                                                                                       statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor:responseDescriptor];

    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
