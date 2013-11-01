//
//  FontListViewController.m
//  FontList
//
//  Created by Kevin Nattinger on 11/1/13.
//  Copyright (c) 2013 Nattinger. All rights reserved.
//

#import "FontListViewController.h"

@interface FontListViewController ()

@property (nonatomic, strong) NSArray *families;
@property (nonatomic, strong) NSDictionary *names;
@property (nonatomic) int fontsz;

@end

@implementation FontListViewController

-(id) init
{
    return [self initWithStyle:UITableViewStylePlain];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.families = [[UIFont familyNames] sortedArrayUsingSelector:@selector(compare:)];
        NSMutableDictionary *fonts = [NSMutableDictionary dictionary];
        for(NSString *family in self.families) {
            fonts[family] = [UIFont fontNamesForFamilyName:family];
        }
        self.fontsz = 18;
        self.names = fonts;
    }
    return self;
}

-(void) setFontsz:(int)fontsz
{
    _fontsz = fontsz;
    self.title = [NSString stringWithFormat:@"Size %d", fontsz];
    if(self.isViewLoaded) {
        [self.tableView reloadData];
    }
}

-(void) viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *up = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                        target:self
                                                                        action:@selector(bigger)];
    UIBarButtonItem *dn = [[UIBarButtonItem alloc] initWithTitle:@"—"
                                                           style:UIBarButtonItemStylePlain
                                                          target:self
                                                          action:@selector(smaller)];

    self.navigationItem.leftBarButtonItem  = dn;
    self.navigationItem.rightBarButtonItem = up;

}

-(void) bigger { self.fontsz++; }
-(void) smaller{ self.fontsz--; }

-(int) numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.families.count;
}
-(int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.names[self.families[section]] count];
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *rid = @"FontCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:rid];
    }
    NSString *font = self.names[self.families[indexPath.section]][indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:font size:self.fontsz];
    cell.textLabel.text = font;
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.families[section];
}

@end
