#import "Panel.h"
#import <TMCache.h>
#import "NRRule.h"

@interface Panel () {
    NSInteger selectedInd;
}

@end
@implementation Panel

- (void)awakeFromNib {
    [self.rulesTableView setDelegate:self];
    [self.rulesTableView setDataSource:self];
    selectedInd = -1;
    [self.monitoredTextLabel setStringValue:[NRConstants monitoredDirectory]];
    [self.rootTextLabel setStringValue:[NRConstants rootDirectory]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"rulesEdited" object:nil];
}

- (void)refresh {
    NSLog(@"rules edited");
    [self.rulesTableView reloadData];
}

- (BOOL)canBecomeKeyWindow;
{
    return YES; // Allow Search field to become the first responder
}

- (void)addRule:(NSString *)extension toFolder:(NSString *)dir {
    NSMutableArray *dict = [[NRConstants allRules] mutableCopy];
    NRRule *rule = [[NRRule alloc] initWithFilter:extension folderName:dir];
    [dict addObject:rule];
    
    [[TMCache sharedCache] setObject:[[NSSet setWithArray:dict] allObjects] forKey:kNRRules];
    
    [self.folderTextField setStringValue:@""];
    [self.extensionTextField setStringValue:@""];
}

- (void)removeRule:(NRRule *)rule {
    NSMutableArray *dict = [[NRConstants allRules] mutableCopy];
    [dict removeObject:rule];
    [[TMCache sharedCache] setObject:[dict copy] forKey:kNRRules];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [NRConstants allRules].count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    // Retrieve to get the @"MyView" from the pool or,
    // if no version is available in the pool, load the Interface Builder version
    NSTableCellView *result = [tableView makeViewWithIdentifier:@"RuleCell" owner:self];
    
    // Set the stringValue of the cell's text field to the nameArray value at row
    NRRule *rule = [[NRConstants allRules] objectAtIndex:row];
    if (tableColumn == self.columnOne) {
        result.textField.stringValue =  [rule.folderURL path];
    }
    else if (tableColumn == self.columnTwo) {
        result.textField.stringValue =  rule.filter;
    }
    
    
    // Return the result
    return result;
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
    if (row == selectedInd) {
        selectedInd = -1;
        return NO;
    }
    selectedInd = row;
    return YES;
}

- (IBAction)deleteButtonPressed:(NSButton *)sender {
    if (selectedInd > -1 && [[NRConstants allRules] count] > selectedInd) {
        NRRule *extension = [[NRConstants allRules] objectAtIndex:selectedInd];
        [self removeRule:extension];
        [self.rulesTableView reloadData];
    }
}

- (IBAction)addButtonPressed:(NSButton *)sender {
    NSLog(@"adding %@, %@", self.extensionTextField.stringValue, self.folderTextField.stringValue);
    [self addRule:self.extensionTextField.stringValue toFolder:self.folderTextField.stringValue];
    [self.rulesTableView reloadData];
}

+ (NSArray *)directoryPicker {
    NSOpenPanel *openDlg = [NSOpenPanel openPanel];
    //    [openDlg setLevel:CGShieldingWindowLevel()];
    //        [self addChildWindow:openDlg ordered:NSWindowAbove];
    [openDlg makeKeyAndOrderFront:nil];
    //    NSLog(@"%lu %lu", [self orderedIndex], [openDlg orderedIndex]);
    [openDlg setCanChooseFiles:NO];
    [openDlg setCanChooseDirectories:YES];
    [openDlg setCanCreateDirectories:YES];
    [openDlg setAllowsMultipleSelection:NO];
    
    // Display the dialog box.  If the OK pressed,
    // process the files.
    if ([openDlg runModal] == NSOKButton) {
        // Gets list of all files selected
        return [openDlg URLs];
    }
    return nil;
}

- (IBAction)changeDirectoryButtonPressed:(NSButton *)sender {
    NSArray *files = [Panel directoryPicker];
    if (files) {
        [NRConstants setMonitoredDirectory:files[0]];
        [self.monitoredTextLabel setStringValue:[NRConstants monitoredDirectory]];
    }
}

- (IBAction)changeRootDirectoryButtonPressed:(id)sender {
    NSArray *files = [Panel directoryPicker];
    if (files) {
        [NRConstants setRootDirectory:files[0]];
        [self.rootTextLabel setStringValue:[NRConstants rootDirectory]];
    }
}

@end
