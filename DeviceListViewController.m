//
//  DeviceListViewController.m
//  bleBasics
//
//  Created by zenko on 10/12/13.
//  Copyright (c) 2013 Zen&Ko, LLC. All rights reserved.
//

#import "DeviceListViewController.h"
#import "RBL_BLE.h"
#import "SensiBot.h"
#import "DetailViewController.h"

@interface DeviceListViewController ()
- (IBAction)scanForFriends:(id)sender;

@end

@implementation DeviceListViewController
{
    RBL_BLE *bluetooth;
    NSMutableArray *deviceIDs;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    deviceIDs = [[NSMutableArray alloc] initWithCapacity:2];
    
    bluetooth = [[RBL_BLE alloc] init];
    bluetooth.list_delegate = self;
    [bluetooth startup];
    
    NSLog(@"View finished loading the Bluetooths");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"Prepare for seque [%@] from sender [%@]", segue, sender);
    if([segue.identifier isEqualToString:@"toBleDetails"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        SensiBot *device = [bluetooth.sensibots objectForKey:[deviceIDs objectAtIndex:indexPath.row]];
        [segue.destinationViewController setBleRadio:bluetooth forDevice:device.peripheral.identifier];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [deviceIDs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cellSummary";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    // Configure the cell...
    // turn this into a SensiBot Object
    SensiBot *temp = [bluetooth.sensibots objectForKey:[deviceIDs objectAtIndex:indexPath.row]];
    NSLog(@"Row #%i %@ : %@ : %@",indexPath.row, temp, bluetooth.sensibots, [deviceIDs objectAtIndex:0]);

    NSString *description = [NSString stringWithFormat:@"%@ - %@", temp.peripheral.name, [temp.peripheral.identifier UUIDString]];
    
    cell.textLabel.text = description;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Row %i selected", indexPath.row);
    
    //ViewController *viewController = [[ViewController alloc] init];
    //[viewController.view setBackgroundColor:[UIColor orangeColor]];
    //[self.navigationController pushViewController:viewController animated:YES];

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (IBAction)scanForFriends:(id)sender {
    
    NSLog(@"Scanning for Friends");
    [scanner setEnabled:NO];
    [bluetooth findBLEPeripherals:2];
    
    //show activity status somewhere on screen
    //[indConnecting startAnimating];
}


/*
 * RBL_BLE_Delegate
 */

-(void) bleFinishedScanning
{
    NSLog(@"Connection timer finished");
    [scanner setEnabled:YES];
    //update button and ui
    /*
     [btnConnect setEnabled:true];
     [btnConnect setTitle:@"Disconnect" forState:UIControlStateNormal];
     
     if (ble.peripherals.count > 0)
     {
     [ble connectPeripheral:[ble.peripherals objectAtIndex:0]];
     }
     else
     {
     [btnConnect setTitle:@"Connect" forState:UIControlStateNormal];
     [indConnecting stopAnimating];
     }*/

}
-(void) bleDidConnect:(NSUUID *) identifier
{
    NSLog(@"Adding peripheral %@ to table", [identifier UUIDString]);
    
    
    //if the device disconnects, then reconnects, and changes its name, this will not pick it up
    if([deviceIDs indexOfObject:identifier] == NSNotFound)
    {
        // Tell the tableView we're going to add (or remove) items.
        [self.tableView beginUpdates];
        // Add an item to the array.
        [deviceIDs addObject:identifier];
        
        // Tell the tableView about the item that was added.
        NSIndexPath *indexPathOfNewItem = [NSIndexPath indexPathForRow:([deviceIDs count] - 1) inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPathOfNewItem] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        // Tell the tableView we have finished adding or removing items.
        [self.tableView endUpdates];
        
        // Scroll the tableView so the new item is visible
        [self.tableView scrollToRowAtIndexPath:indexPathOfNewItem atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
        // Update the buttons if we need to.
        //[self updateButtonsToMatchTableState];
    }

}
-(void) bleDidDisconnect:(NSUUID *) identifier
{
    NSLog(@"Removing peripheral %@ from table", [identifier UUIDString]);
    
    NSUInteger location = [deviceIDs indexOfObject:identifier];
    
    if(location == NSNotFound)
        return;
    
    // Tell the tableView we're going to add (or remove) items.
    [self.tableView beginUpdates];
    
    // Tell the tableView about the item that was added.
    NSIndexPath *indexPathOfNewItem = [NSIndexPath indexPathForRow:location inSection:0];
    [self.tableView deleteRowsAtIndexPaths:@[indexPathOfNewItem] withRowAnimation:UITableViewRowAnimationAutomatic];

    // Remove an item to the array.
    [deviceIDs removeObject:identifier];

    // Tell the tableView we have finished adding or removing items.
    [self.tableView endUpdates];
}
-(void) bleDidUpdateRSSI:(NSNumber *) rssi
{
    // No reason to update
}

@end
