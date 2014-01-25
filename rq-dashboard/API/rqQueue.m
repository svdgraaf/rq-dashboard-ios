//
//  rqQueue.m
//  rq-dashboard
//
//  Created by Sander van de Graaf on 1/15/14.
//  Copyright (c) 2014 Serinus42. All rights reserved.
//

#import "rqQueue.h"
#import <RestKit/Network/RKObjectManager.h>


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

@end
