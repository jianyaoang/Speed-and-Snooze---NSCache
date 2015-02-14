//
//  ViewController.m
//  NSCache
//
//  Created by VLT Labs on 2/14/15.
//  Copyright (c) 2015 jayang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) NSCache *cacheJSONResponse;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self connectToWeatherForecast];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.cacheJSONResponse == nil)
    {
        [self connectToWeatherForecast];
    }
    else
    {
        NSDictionary *currently = [self.cacheJSONResponse valueForKeyPath:@"currently"];
        NSLog(@"self.cacheJSONResponse viewWillAppear %@", self.cacheJSONResponse);
        NSLog(@"currently viewWillAppear %@", currently);
        
        //call this to get updated / latest data once the info is shown from self.cacheJSONResponse
        [self connectToWeatherForecast];
    }

}

-(void)connectToWeatherForecast
{
    NSURL *url = [NSURL URLWithString:@"https://api.forecast.io/forecast/c028fb9d205a3f05aae9fe575dd1d856/37.8267,-122.423"];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
       
        if (connectionError)
        {
            if (self.cacheJSONResponse != nil)
            {
                NSDictionary *currently = [self.cacheJSONResponse valueForKeyPath:@"currently"];
                NSLog(@"self.cacheJSONResponse %@", self.cacheJSONResponse);
                NSLog(@"currently %@", currently);
            }
            else
            {
                NSLog(@"connection error with weather forecast");
            }
        }
        else
        {
            NSError *error;
            self.cacheJSONResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            NSLog(@"cacheJSONData %@", self.cacheJSONResponse);
            
        }
    }];
}

@end
