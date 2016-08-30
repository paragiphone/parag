//
//  SearchViewController.m
//  YQLPracticeApp
//
//  Created by Parag Baral on 8/24/16.
//  Copyright © 2016 Parag Baral. All rights reserved.
//

#import "SearchViewController.h"
#import "ResultsViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface SearchViewController () <CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *searchKey;
@property (strong, nonatomic) IBOutlet UITextField *zipCode;
//CLLocation Manager will determine whether the user has location services enabled.
@property (strong, nonatomic) CLLocationManager *locationManager;
// This converts the latitude and longitude into an address or zip code.
@property (strong, nonatomic) CLGeocoder *geoCoder;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   

    
  
}
- (IBAction)currentButton:(id)sender {
    
    //allocating and initializing the location manager and geocoder under current button  so it will there every time we use the current location button.
    self.locationManager = [[CLLocationManager alloc]init];

    
    // This sets the location manager delegate to this view controller. We might not end up using any of the delegate meathods, but if there are any required we will do them using the SearchViewController.
    _locationManager.delegate = self;
 
    // THis is asking for authority to trace location, if above iOS 6 then this request will pop up, else BAAL HO NI.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    else{
        [self.locationManager startUpdatingLocation];
    }
}
// This is the delegate method that checks your response to the allow tracking pop up.
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
    }else{
        NSLog(@"YOU BETTER FUCKING ALLOW ME");
    }
}

// This delegate method gives you an array of locations, and you want the most recent location. So once you get the most recent location, stop updating location.
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    [self.locationManager stopUpdatingLocation];
    CLLocation *myLocation = locations.lastObject;
   
    self.geoCoder = [[CLGeocoder alloc]init];
    [self.geoCoder reverseGeocodeLocation:myLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *myPlacemark = placemarks.lastObject;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.zipCode.text = myPlacemark.postalCode;
        });
        //The code below needs to be called in a block, so it is done above. 
       // self.zipCode.text = myPlacemark.postalCode;
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

 //In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    ResultsViewController *resVC = segue.destinationViewController;
    //     Get the new view controller using [segue destinationViewController].
    //     Pass the selected object to the new view controller.
    
    //Return the two search items
    resVC.searchItem = self.searchKey.text;
    // You need the bracket and to turn it into an int value. Or you could use the preiod for shorthand notation. The bottom comment is generic obj c code. 
    resVC.zipCode = self.zipCode.text.intValue;
    // resVC.zipCode = [[[self zipCode]text]intValue];

}


@end
