//
//  LocationManager.m
//  ADreamClusiveModel
//
//  Created by 西禾口语 2018 on 2018/11/28.
//  Copyright © 2018 Jiaozl. All rights reserved.
//

#import "LocationManager.h"

static NSString *const LATEST_POSITION_KEY = @"latestpositionkey";

@interface LocationManager()<CLLocationManagerDelegate>
{
    CLLocationManager *locationmanager;//定位服务
    NSString *currentCity;//当前城市
    NSString *strlatitude;//经度
    NSString *strlongitude;//纬度
}

@property (nonatomic, strong) NSDictionary *addressDic;

@end

@implementation LocationManager

+(id)sharedInstance
{
    static id obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[[self class] alloc] init];
    });
    return obj;
}
- (id)init{
    if (self = [super init]) {
        [self getLocation];
    }
    return self;
}

- (void)setLatestLocation:(CLLocation *)location {
    // 将位置存入本地
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:location];
    [kUSERDEFAULTS setObject:data forKey:LATEST_POSITION_KEY];
}
- (CLLocation *)getLatestLocation {
    id positionData = [kUSERDEFAULTS objectForKey:LATEST_POSITION_KEY];
    if (positionData) {
        CLLocation *location;
        @try {
            location = [NSKeyedUnarchiver unarchiveObjectWithData:positionData];
        } @catch (NSException *exception) {
            location = [[CLLocation alloc] initWithLatitude:39.960102999999997 longitude:116.460385];
        }
        return location;
    }
    return [[CLLocation alloc] initWithLatitude:39.960102999999997 longitude:116.460385];
}

- (NSDictionary *)addressDic {
    if(_addressDic==nil) {
        _addressDic = [NSDictionary new];
    }
    return _addressDic;
}

- (CLLocationCoordinate2D)geocodeOf:(NSString *)address {
    __block CLLocationCoordinate2D coordinate;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error){
        NSLog(@"查询记录数:%ld",[placemarks count]);
        if ([placemarks count] > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            coordinate = placemark.location.coordinate;
            
            NSString *strCoordinate = [NSString stringWithFormat:@"经度:%3.5f 纬度:%3.5f:",coordinate.latitude,coordinate.longitude ];
            NSLog(@"%@",strCoordinate);
            
        }
    }];
    return coordinate;
}

- (void)getLocation
{
    //判断定位功能是否打开
    if ([CLLocationManager locationServicesEnabled]) {
        locationmanager = [[CLLocationManager alloc]init];
        locationmanager.delegate = self;
        currentCity = [NSString new];
        [locationmanager requestAlwaysAuthorization];
//        [locationmanager requestWhenInUseAuthorization];
        
        //设置寻址精度
        locationmanager.desiredAccuracy = kCLLocationAccuracyBest;
        locationmanager.distanceFilter = kCLDistanceFilterNone;
        [locationmanager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
            [manager requestAlwaysAuthorization];
//            [manager requestWhenInUseAuthorization];
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
            manager.allowsBackgroundLocationUpdates = YES;
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [manager requestAlwaysAuthorization];
            manager.allowsBackgroundLocationUpdates = YES;
            break;
        default:
            break;
    }
}

#pragma mark CoreLocation delegate (定位失败)
//定位失败后调用此代理方法
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //设置提示提醒用户打开定位服务
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"允许定位提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];

//    [self  presentViewController:alert animated:YES completion:nil];
}

#pragma mark 定位成功后则执行此代理方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [locationmanager stopUpdatingHeading];
    //旧址
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    //打印当前的经度与纬度
    NSLog(@"%f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    
    [self setLatestLocation:currentLocation];
    
    //反地理编码
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            self->currentCity = placeMark.locality;
            if (!self->currentCity) {
                self->currentCity = @"无法定位当前城市";
            }
            
            /*看需求定义一个全局变量来接收赋值*/
            NSLog(@"----%@",placeMark.country);//当前国家
            NSLog(@"%@",self->currentCity);//当前的城市
            //            NSLog(@"%@",placeMark.subLocality);//当前的位置
            //            NSLog(@"%@",placeMark.thoroughfare);//当前街道
            //            NSLog(@"%@",placeMark.name);//具体地址
            self->_addressDic = placeMark.addressDictionary;
            
        }
    }];
}


@end
