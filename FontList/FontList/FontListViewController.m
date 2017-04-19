//
//  FontListViewController.m
//  FontList
//
//  Created by Kevin Nattinger on 11/1/13.
//  Copyright (c) 2013 Nattinger. All rights reserved.
//

#import "FontListViewController.h"

@interface FontListViewController ()

@property (nonatomic, strong) NSArray<NSString *> *families;
@property (nonatomic, strong) NSDictionary<NSString *, NSArray<NSString *> *> *names;
@property (nonatomic) CGFloat fontSize;

@end

static NSString *reuseIdentifier = @"FontCell";

@implementation FontListViewController

- (instancetype)init
{
    return [self initWithStyle:UITableViewStylePlain];
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.families = [[UIFont familyNames] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        NSMutableDictionary<NSString *, NSArray<NSString *> *> *fonts = [NSMutableDictionary dictionary];
        for (NSString *family in self.families) {
            fonts[family] = [UIFont fontNamesForFamilyName:family];
        }
        self.fontSize = 18;
        self.names = fonts;
    }
    return self;
}

- (void)setFontSize:(CGFloat)fontSize
{
    _fontSize = fontSize;
    self.title = [NSString stringWithFormat:@"Size %d", (int)fontSize];
    if (self.isViewLoaded) {
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad
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

    self.tableView.estimatedRowHeight = 44;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
}

- (void)bigger { self.fontSize++; }
- (void)smaller { self.fontSize--; }

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.families.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.names[self.families[section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSString *font = self.names[self.families[indexPath.section]][indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:font size:self.fontSize];
    cell.textLabel.text = font;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.families[section];
}

@end
