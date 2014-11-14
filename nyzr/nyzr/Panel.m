#import "Panel.h"
#import <TMCache.h>

@interface Panel () {
    NSInteger selectedInd;
}

@end
@implementation Panel

- (void)awakeFromNib {
    [self.rulesTableView setDelegate:self];
    [self.rulesTableView setDataSource:self];
    selectedInd = -1;
    [self.monitoredTextField setStringValue:[NRConstants monitoredDirectory]];
}

- (BOOL)canBecomeKeyWindow;
{
    return YES; // Allow Search field to become the first responder
}

- (NSDictionary *)rulesDictionary {
    NSDictionary *retval = [[TMCache sharedCache] objectForKey:kNRRules];
    if (!retval) {
        retval = [NSDictionary new];
        [[TMCache sharedCache] setObject:retval forKey:kNRRules];
    }
    return retval;
}

- (void)addRule:(NSString *)extension toFolder:(NSString *)dir {
    NSMutableDictionary *dict = [[self rulesDictionary] mutableCopy];
    [dict setObject:dir forKey:extension];
    [[TMCache sharedCache] setObject:[dict copy] forKey:kNRRules];
}

- (void)removeRule:(NSString *)extension {
    NSMutableDictionary *dict = [[self rulesDictionary] mutableCopy];
    [dict removeObjectForKey:extension];
    [[TMCache sharedCache] setObject:[dict copy] forKey:kNRRules];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [self rulesDictionary].count;
}

- (NSArray *)rules {
    return [self rulesDictionary].allKeys;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    // Retrieve to get the @"MyView" from the pool or,
    // if no version is available in the pool, load the Interface Builder version
    NSTableCellView *result = [tableView makeViewWithIdentifier:@"RuleCell" owner:self];
    
    // Set the stringValue of the cell's text field to the nameArray value at row
    NSString *name = [[self rules] objectAtIndex:row];
    if (tableColumn == self.columnOne) {
        result.textField.stringValue =  name;
    }
    else if (tableColumn == self.columnTwo) {
        result.textField.stringValue =  [[self rulesDictionary] objectForKey:name];
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
    if (selectedInd > -1 && [[self rules] count] > selectedInd) {
        NSString *extension = [[self rules] objectAtIndex:selectedInd];
        [self removeRule:extension];
        [self.rulesTableView reloadData];
    }
}

- (IBAction)addButtonPressed:(NSButton *)sender {
    if (self.extensionTextField.stringValue.length > 0 && self.folderTextField.stringValue.length > 0) {
        NSURL *homeURL = [NSURL URLWithString:[NRConstants monitoredDirectory]];
        [homeURL URLByAppendingPathComponent:self.folderTextField.stringValue];
        BOOL isDir = NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:[homeURL path] isDirectory:&isDir]) {
            if (!isDir) {
                return;
            }
            NSLog(@"%@ already exists", homeURL);
        }
        else {
            NSError *error;
            [[NSFileManager defaultManager] createDirectoryAtURL:homeURL withIntermediateDirectories:YES attributes:nil error:&error];
            NSLog(@"Creating directory %@", homeURL);
        }
    }
    [self addRule:self.extensionTextField.stringValue toFolder:self.folderTextField.stringValue];
    [self.rulesTableView reloadData];
}

- (IBAction)changeDirectoryButtonPressed:(NSButton *)sender {
    NSOpenPanel *openDlg = [NSOpenPanel openPanel];
    //    [openDlg setLevel:CGShieldingWindowLevel()];
    //        [self addChildWindow:openDlg ordered:NSWindowAbove];
    [openDlg makeKeyAndOrderFront:sender];
    //    NSLog(@"%lu %lu", [self orderedIndex], [openDlg orderedIndex]);
    [openDlg setCanChooseFiles:NO];
    [openDlg setCanChooseDirectories:YES];
    [openDlg setCanCreateDirectories:YES];
    [openDlg setAllowsMultipleSelection:NO];
    
    // Display the dialog box.  If the OK pressed,
    // process the files.
    if ([openDlg runModal] == NSOKButton) {
        // Gets list of all files selected
        NSArray *files = [openDlg URLs];
        [NRConstants setMonitoredDirectory:files[0]];
        [self.monitoredTextField setStringValue:[NRConstants monitoredDirectory]];
    }
}

@end
