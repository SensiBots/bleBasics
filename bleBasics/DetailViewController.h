//
//  ViewController.h
//  bleBasics
//
//  Created by zenko on 9/28/13.
//  Copyright (c) 2013 Zen&Ko, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBL_BLE.h"
#import "RBL_BLE_Delegate.h"

@interface DetailViewController : UIViewController <RBL_BLE_Delegate>
{
    IBOutlet UILabel *rssiValue;
    
    IBOutlet UILabel *deviceNameValue;
    IBOutlet UILabel *deviceUUIDValue;
    IBOutlet UILabel *deviceVendorNameValue;
    IBOutlet UILabel *deviceLibVersionValue;
    
    IBOutlet UISwitch *backlightSwitch;
    IBOutlet UISlider *buzzSlider;
    IBOutlet UISwitch *ledSwitch;
    IBOutlet UISlider *ledSlider;
    IBOutlet UISwitch *tempSwitch;
    IBOutlet UITextField *tempValue;
    IBOutlet UISegmentedControl *tempSegment;
    IBOutlet UISwitch *lightSwitch;
    IBOutlet UITextField *lightValue;
    IBOutlet UISwitch *soundSwitch;
    IBOutlet UITextField *soundValue;
}

-(void) setBleRadio: (RBL_BLE *) value forDevice: (NSUUID *) identifier;
@end
