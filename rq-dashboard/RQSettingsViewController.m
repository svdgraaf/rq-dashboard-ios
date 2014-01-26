//
//  RQSettingsViewController.m
//  rq-dashboard
//
//  Created by Sander van de Graaf on 1/26/14.
//  Copyright (c) 2014 Serinus42. All rights reserved.
//

#import "RQSettingsViewController.h"

@interface RQSettingsViewController ()

@end

@implementation RQSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIEdgeInsets inset = UIEdgeInsetsMake(65, 0, 50, 0);
    self.settingsTableView.contentInset = inset;
    self.settingsTableView.scrollIndicatorInsets = inset;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
