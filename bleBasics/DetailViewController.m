//
//  ViewController.m
//  bleBasics
//
//  Created by zenko on 9/28/13.
//  Copyright (c) 2013 Zen&Ko, LLC. All rights reserved.
//

#import "DetailViewController.h"
#import "SensiBot.h"

@interface DetailViewController ()

- (IBAction)toggleBackLight:(id)sender;
- (IBAction)activateBuzzer:(id)sender;
- (IBAction)ledDimmer:(id)sender;
- (IBAction)toggleLED:(id)sender;
- (IBAction)singSong:(id)sender;
- (IBAction)flashLEDs:(id)sender;
- (IBAction)toggleTemp:(id)sender;
- (IBAction)toggleLight:(id)sender;
- (IBAction)toggleSound:(id)sender;
- (IBAction)toggleAccel:(id)sender;

@end

@implementation DetailViewController
{
    RBL_BLE *bluetooth;
    SensiBot *sensibot;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"View did load and starting updates");
    UIScrollView *tempScrollView=(UIScrollView *)self.view.subviews[0];
    
    if([tempScrollView isKindOfClass:[UIScrollView class]])
    {
        [tempScrollView setScrollEnabled:YES];
        tempScrollView.contentSize=CGSizeMake(320,604);
    }

    [sensibot toggleRSSIupdates:YES];
    deviceNameValue.text = [NSString stringWithFormat:@"Device Name: %@", sensibot.peripheral.name];
    deviceUUIDValue.text = [NSString stringWithFormat:@"Device UUID: %@", [sensibot.peripheral.identifier UUIDString]];
    deviceVendorNameValue.text = [NSString stringWithFormat:@"Device Vendor Name: %@", sensibot.vendorName];
    deviceLibVersionValue.text = [NSString stringWithFormat:@"Device Library Version: %@", sensibot.deviceLibVersion];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"View will disappear");
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"View DID disappear");
    [super viewDidDisappear:animated];
    
    // Stopping data activity
    [sensibot toggleRSSIupdates:NO];
    bluetooth.detail_delegate = nil;
    bluetooth = nil;
}


-(void) bleFinishedScanning
{
    
}
-(void) bleDidConnect:(NSUUID *) identifier
{
    NSLog(@"Connected on Details page");
}
-(void) bleDidDisconnect:(NSUUID *) identifier
{
    NSLog(@"Disconnected on Details page");
}
-(void) bleDidUpdateRSSI:(NSNumber *) rssi;
{
    rssiValue.text = [NSString stringWithFormat:@"RSSI: %i", rssi.intValue];
}
-(void) bleDidReceiveData
{
    tempValue.text = [NSString stringWithFormat:@"%f", sensibot.temperature];
    accelValue.text = [NSString stringWithFormat:@"%.2f,%.2f,%.2f", sensibot.accelX, sensibot.accelY, sensibot.accelZ];
    lightValue.text = [NSString stringWithFormat:@"%f", sensibot.lux];
    soundValue.text = [NSString stringWithFormat:@"%f", sensibot.db];
}

-(void) setBleRadio: (RBL_BLE *) value forDevice: (NSUUID *) identifier
{
    bluetooth = value;
    bluetooth.detail_delegate = self;
    sensibot = [bluetooth.sensibots objectForKey:identifier];
    NSLog(@"NSUUID from selected row: [%@]", identifier.UUIDString);
}

- (IBAction)connectPeripheral:(id)sender {
//    tooth = [[BazookaTooth alloc] init];
//    [tooth connectDevice];
}

- (IBAction)scanPeripherals:(id)sender {
//    [tooth scanDevices];
}

- (IBAction)toggleBackLight:(id)sender
{
    NSLog(@"Backlight switch activated!");
    [sensibot toggleBackLight:backlightSwitch.on];
}

- (IBAction)activateBuzzer:(id)sender
{
    NSLog(@"Buzzer buzzing!");
    [sensibot buzzer: buzzSlider.value];
}

- (IBAction)ledDimmer:(id)sender
{
    NSLog(@"Dimming LED!");
    [sensibot toggleLED:ledSlider.value];
}

- (IBAction)toggleLED:(id)sender
{
    NSLog(@"Toggling LED!");
    [sensibot toggleLED:ledSwitch.on];
}

- (IBAction)singSong:(id)sender
{
    NSLog(@"Singing a lovely song");
    [sensibot playSong];
}

- (IBAction)flashLEDs:(id)sender
{
    NSLog(@"Flashing LEDs");
    [sensibot flashLEDs];
}

- (IBAction)toggleTemp:(id)sender {
    
    NSLog(@"Temp Sensor switch activated!");
    [sensibot toggleTemp:tempSwitch.on];    
}

- (IBAction)toggleLight:(id)sender {
    NSLog(@"Light Sensor switch activated!");
    [sensibot toggleLight:lightSwitch.on];
}

- (IBAction)toggleSound:(id)sender {
    NSLog(@"Sound Sensor switch activated!");
    [sensibot toggleSound:soundSwitch.on];
}

- (IBAction)toggleAccel:(id)sender {
    NSLog(@"Accelerometer Sensor switch activated!");
    [sensibot toggleAccelerometer:accelSwitch.on];
}
@end
