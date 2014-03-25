//
//  DeviceListViewController.h
//  bleBasics
//
//  Created by zenko on 10/12/13.
//  Copyright (c) 2013 Zen&Ko, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBL_BLE_Delegate.h"

@interface DeviceListViewController : UITableViewController <RBL_BLE_Delegate>
{
    IBOutlet UIButton *scanner;
    
}

@end
