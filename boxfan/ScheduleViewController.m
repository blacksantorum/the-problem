//
//  ScheduleViewController.m
//  boxfan
//
//  Created by Chris Tibbs on 12/15/13.
//  Copyright (c) 2013 Chris Tibbs. All rights reserved.
//

#import "ScheduleViewController.h"
#import "Fight.h"
#import "Boxer.h"
#import "FightDetailViewController.h"

@interface ScheduleViewController ()

@property (nonatomic, strong) NSMutableArray *fights; //of Fights

-(void)setFightArray;

@end

@implementation ScheduleViewController

-(void)setFightArray
{
    Boxer *jPascal = [[Boxer alloc] initWithFirst:@"Jean" Last:@"Pascal" Country:@"Canada"];
    Boxer *lBute = [[Boxer alloc] initWithFirst:@"Lucian" Last:@"Bute" Country:@"Canada"];
    Fight *a = [[Fight alloc] initWithDictionary:@{@"date" : @"1/18", @"weight": @"175", @"location" : @"Montreal",
                                                   @"boxers" : @[jPascal,lBute], @"rounds" :@12}];
    [self.fights addObject:a];
    
    Boxer *mGarcia = [[Boxer alloc] initWithFirst:@"Mike" Last:@"Garcia" Country:@"USA"];
    Boxer *jBurgos = [[Boxer alloc] initWithFirst:@"Juan Carlos" Last:@"Burgos" Country:@"Mexico"];
    Fight *b = [[Fight alloc] initWithDictionary:@{@"date" : @"1/25", @"weight": @"130", @"location" : @"New York City",
                                                   @"boxers" : @[mGarcia,jBurgos], @"rounds" :@12}];
    [self.fights addObject:b];
    
    Boxer *gGolovkin = [[Boxer alloc] initWithFirst:@"Gennady" Last:@"Golovkin" Country:@"Kazahkstan"];
    Boxer *oAdama = [[Boxer alloc] initWithFirst:@"Osumanu" Last:@"Adama" Country:@"Ghana"];
    Fight *c = [[Fight alloc] initWithDictionary:@{@"date" : @"2/1", @"weight": @"160", @"location" : @"Monte Carlo",
                                                   @"boxers" : @[gGolovkin,oAdama], @"rounds" :@12}];
    [self.fights addObject:c];
}

-(NSArray *)fights
{
    if(!_fights) {
        _fights = [[NSMutableArray alloc] init];
    }
    return _fights;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"fightDetail"]) {
        FightDetailViewController *controller = (FightDetailViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        controller.fight = self.fights[indexPath.row];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setFightArray];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.fights count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Fight Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // set text to Aside-BSide
    Fight *fight = self.fights[indexPath.row];
    cell.textLabel.text = fight.titleForScheduleView;
    
    return cell;
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

@end
