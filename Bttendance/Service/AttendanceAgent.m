//
//  BTAgent.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 5. 4..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "AttendanceAgent.h"
#import "BTAPIs.h"
#import "BTUUID.h"
#import "BTUserDefault.h"

@implementation AttendanceAgent

+ (AttendanceAgent *)sharedInstance {
    static AttendanceAgent *agent;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        agent = [[AttendanceAgent alloc]init];
    });
    
    return agent;
}

- (id)init {
    self = [super init];
    myservice = [BTUUID getUserService];
    myCmanager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    [myPmanager addService:myservice];
    
    NSString *myUUID = [BTUserDefault getUUID];
    MCPeerID *mMCPeerID = [[MCPeerID alloc] initWithDisplayName:myUUID];
    mMCBrowser = [[MCNearbyServiceBrowser alloc] initWithPeer:mMCPeerID serviceType:@"Bttendance"];
    mMCAdvertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:mMCPeerID
                                                      discoveryInfo:@{@"peerid": [mMCPeerID displayName]}
                                                        serviceType:@"Bttendance"];
    mMCBrowser.delegate = self;
    mMCAdvertiser.delegate = self;
    
    attdStartingCourseID = @"";
    attdScanningAttendanceIDs = [[NSMutableArray alloc] init];
    return self;
}

- (void)restartMC {
    NSString *myUUID = [BTUserDefault getUUID];
    MCPeerID *mMCPeerID = [[MCPeerID alloc] initWithDisplayName:myUUID];
    mMCBrowser = [[MCNearbyServiceBrowser alloc] initWithPeer:mMCPeerID serviceType:@"Bttendance"];
    mMCAdvertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:mMCPeerID
                                                      discoveryInfo:@{@"peerid": [mMCPeerID displayName]}
                                                        serviceType:@"Bttendance"];
    
    mMCBrowser.delegate = self;
    mMCAdvertiser.delegate = self;
    [mMCAdvertiser startAdvertisingPeer];
    [mMCBrowser startBrowsingForPeers];
}

#pragma Attendance Start Actions
- (void)startAttendanceWithCourse:(NSString *)courseID
                    andCourseName:(NSString *)courseName
                          andType:(NSString *)type
                          success:(void (^)(Post *post))success
                          failure:(void (^)(NSError *error))failure {
    
    attdStartingCourseID = [NSString stringWithFormat:@"%@", courseID];
    UIAlertView *alert;
    switch ([myCmanager state]) {
        case CBCentralManagerStatePoweredOn: //powered on
        case CBCentralManagerStateUnsupported: //Bluetooth Low Energy not supported
        case CBCentralManagerStateUnauthorized: //Bluetooth Low Energy not authorized
        {
            
            [BTAPIs startAttendanceWithCourse:attdStartingCourseID
                                      andType:type
                                      success:^(Post *post) {
                                          success(post);
                                      } failure:^(NSError *error) {
                                          failure(nil);
                                      }];
            break;
        }
        case CBCentralManagerStatePoweredOff: //powered off
            failure(nil);
            alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Turn On Bluetooth", nil)
                                               message:NSLocalizedString(@"Your bluetooth is powered off. Before start Attedance check turn your bluetooth on.", nil)
                                              delegate:self
                                     cancelButtonTitle:nil
                                     otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
            alert.tag = 400;
            break;
        case CBCentralManagerStateUnknown: //Unknown state
        default: //default
            failure(nil);
            alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Device Unsupported", nil)
                                               message:NSLocalizedString(@"Your device doesn't support proper bluetooth version.", nil)
                                              delegate:self
                                     cancelButtonTitle:nil
                                     otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
            break;
    }
    [alert show];
}

#pragma Attendance Scan Courses Actions
- (void)startAttdScanWithCourseIDs:(NSArray *)courseIDs {
    UIAlertView *alert;
    switch ([myCmanager state]) {
        case CBCentralManagerStatePoweredOn: //power-on
            myPmanager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
            [self checkAttdWithCourseIDs:courseIDs];
            break;
        case CBCentralManagerStatePoweredOff: //powered off
            alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Turn On Bluetooth", nil)
                                               message:NSLocalizedString(@"Your bluetooth is powered off. Currently, attedance check is in progress. Please turn your bluetooth on.", nil)
                                              delegate:self
                                     cancelButtonTitle:nil
                                     otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
            alert.tag = 400;
            [alert show];
            break;
        case CBCentralManagerStateUnknown: //Unknown state
        case CBCentralManagerStateUnsupported: //Bluetooth Low Energy not supported
        case CBCentralManagerStateUnauthorized: //Bluetooth Low Energy not authorized
        default: //default
            break;
    }
}

- (void)checkAttdWithCourseIDs:(NSArray *)courseIDs {
    [BTAPIs fromCoursesWithCourses:courseIDs
                           success:^(NSArray *attendanceIDs) {
                               NSMutableArray *array = [[NSMutableArray alloc] init];
                               for (int i = 0; i < attendanceIDs.count; i++)
                                   [array addObject:[NSString stringWithFormat:@"%@", attendanceIDs[i]]];
                               [self checkAttdWithAttendanceIDs:array];
                           } failure:^(NSError *error) {
                           }];
}

#pragma Attendance Scan Feed Actions
- (void)startAttdScanWithAttendanceIDs:(NSArray *)attendanceIDs {
    UIAlertView *alert;
    switch ([myCmanager state]) {
        case CBCentralManagerStatePoweredOn: //power-on
            myPmanager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
            [self checkAttdWithAttendanceIDs:attendanceIDs];
            break;
        case CBCentralManagerStatePoweredOff: //powered off
            alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Turn On Bluetooth", nil)
                                               message:NSLocalizedString(@"Your bluetooth is powered off. Currently, attedance check is in progress. Please turn your bluetooth on.", nil)
                                              delegate:self
                                     cancelButtonTitle:nil
                                     otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
            alert.tag = 400;
            [alert show];
            break;
        case CBCentralManagerStateUnknown: //Unknown state
        case CBCentralManagerStateUnsupported: //Bluetooth Low Energy not supported
        case CBCentralManagerStateUnauthorized: //Bluetooth Low Energy not authorized
        default: //default
            break;
    }
}

- (void)alertForClassicBT {
    switch ([myCmanager state]) {
        case CBCentralManagerStatePoweredOn: //power-on
        case CBCentralManagerStatePoweredOff: //powered off
        case CBCentralManagerStateUnknown: //Unknown state
            break;
        case CBCentralManagerStateUnsupported: //Bluetooth Low Energy not supported
        case CBCentralManagerStateUnauthorized: //Bluetooth Low Energy not authorized
        {
            UIAlertView *alert;
            alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Check Bluetooth Status", nil)
                                               message:NSLocalizedString(@"Go to Setting -> Bluetooth and turn on bluetooth.", nil)
                                              delegate:self
                                     cancelButtonTitle:nil
                                     otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
            alert.tag = 500;
            [alert show];
            break;
        }
        default: //default
            break;
    }
}

- (void)checkAttdWithAttendanceIDs:(NSArray *)attendanceIDs {
    BOOL refresh = NO;
    for (int i = 0; i < attendanceIDs.count; i++) {
        BOOL contain = NO;
        for (int j = 0; j < attdScanningAttendanceIDs.count; j++)
            if ([attdScanningAttendanceIDs[j] isEqualToString:attendanceIDs[i]])
                contain = YES;
        if (!contain)
            refresh = YES;
    }
    
    if (refresh) {
        [attdScanningAttendanceIDs removeAllObjects];
        for (id ID in attendanceIDs)
            [attdScanningAttendanceIDs addObject:ID];
        [myCmanager scanForPeripheralsWithServices:nil options:nil];
        [self restartMC];
    }
}


#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 400)
        myPmanager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    
    if (alertView.tag == 500) {
        [self restartMC];
    }
}

#pragma mark - CBCentralManagerDelegate
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    NSString *uuid = [BTUUID representativeString:[[advertisementData objectForKey:CBAdvertisementDataServiceUUIDsKey] objectAtIndex:0]];
    NSLog(@"Found %@", uuid);
    
    for (int i = 0; i < attdScanningAttendanceIDs.count; i++) {
        [BTAPIs foundDeviceWithAttendance:[NSString stringWithFormat:@"%@", attdScanningAttendanceIDs[i]]
                                     uuid:uuid
                                  success:^(Attendance *attendance) {
                                  } failure:^(NSError *error) {
                                  }];
    }
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    NSString *state = nil;
    switch ([central state]) {
        case CBCentralManagerStateUnsupported:
            state = @"The platform hardware doesn't support Bluetooth Low Energy.";
            break;
        case CBCentralManagerStateUnauthorized:
            state = @"The app is not authorized to use Bluetooth Low Energy.";
            break;
        case CBCentralManagerStatePoweredOff:
            state = @"Bluetooth is currently powered off.";
            break;
        case CBCentralManagerStatePoweredOn:
            [myCmanager scanForPeripheralsWithServices:nil options:nil];
            [self restartMC];
            state = @"power-on";
            break;
        case CBCentralManagerStateUnknown:
            state = @"Unknown state";
            break;
        default:
            state = @"default";
            break;
    }
    NSLog(@"Central STATE : %@", state);
}

#pragma mark - CBPeripheralDelegate
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    NSString *state = nil;
    switch ([peripheral state]) {
        case CBPeripheralManagerStateUnsupported:
            state = @"The platform hardware doesn't support Bluetooth Low Energy.";
            break;
        case CBPeripheralManagerStateUnauthorized:
            state = @"The app is not authorized to use Bluetooth Low Energy.";
            break;
        case CBPeripheralManagerStatePoweredOff:
            state = @"Bluetooth is currently powered off.";
            break;
        case CBPeripheralManagerStatePoweredOn:
            [myPmanager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey : @[myservice.UUID]}];
            [self restartMC];
            state = @"power-on";
            break;
        case CBPeripheralManagerStateUnknown:
            state = @"Unknown state";
            break;
        default:
            state = @"default";
            break;
    }
    NSLog(@"Peripheral STATE : %@", state);
}


#pragma MCNearbyServiceBrowserDelegate
- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info{
    NSString *uuid = [peerID displayName];
    NSLog(@"Found %@", uuid);
    
    for (int i = 0; i < attdScanningAttendanceIDs.count; i++) {
        [BTAPIs foundDeviceWithAttendance:[NSString stringWithFormat:@"%@", attdScanningAttendanceIDs[i]]
                                     uuid:uuid
                                  success:^(Attendance *attendance) {
                                  } failure:^(NSError *error) {
                                  }];
    }
}

- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID{
}

#pragma MCNearbyServiceAdvertiserDelegate
-(void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL, MCSession *))invitationHandler{
}

@end
