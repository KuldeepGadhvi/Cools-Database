//
//  ViewController.m
//  CoreData
//
//  Created by Kuldeep Gadhvi on 24/11/16.
//  Copyright © 2016 cools. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Database.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    IBOutlet UITextField *txtfname;
    IBOutlet UITextField *txtlname;
    IBOutlet UITableView *tblView;

}

@end

@implementation ViewController
NSMutableArray *Arr;

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}
-(void)getData{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
    Arr = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    [tblView reloadData];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    Arr = [[NSMutableArray alloc] init];
    [self getData];
    
//    NSMutableDictionary *Dict = [[NSMutableDictionary alloc] init];
//    NSLog(@"Dict >> %@",[Dict allKeys]);
//    [Dict setValue:@"cools" forKey:@"name"];
//    NSLog(@"Dict >> %@",[Dict allKeys]);
//    [Dict setValue:@"" forKey:@"name"];
//    NSLog(@"Dict >> %@",[Dict allKeys]);
    
    NSArray *Arrs = [Database fetchResults:@"SELECT * FROM suppliers"];
    NSLog(@"Arrs >> %@",Arrs);

}


-(IBAction)btnSave:(id)sender{
    
    NSManagedObjectContext *context = [self managedObjectContext];

    NSEntityDescription *entity =[NSEntityDescription entityForName:@"Person" inManagedObjectContext:context];
    NSManagedObject *obj = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
        
    [obj setValue:txtfname.text forKey:@"firstname"];
    [obj setValue:txtlname.text forKey:@"lastname"];
    
    NSError *error = nil;

    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }else{
        [self getData];
    }


}
-(IBAction)btnSearch:(id)sender{
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"firstname contains %@",txtfname.text];
    Arr = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    [tblView reloadData];

    
}
-(IBAction)btnDelete:(id)sender{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
    Arr = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    for (NSManagedObject *obj in Arr) {
        [managedObjectContext deleteObject:obj];
        break;
    }
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
        return;
    }

    [self getData];

}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return Arr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [(NSManagedObject *)Arr[indexPath.row] valueForKey:@"firstname"];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
