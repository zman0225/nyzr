@interface Panel : NSPanel <NSTableViewDelegate, NSTableViewDataSource, NSTextFieldDelegate>
@property (strong) IBOutlet NSTextField *monitoredTextField;
@property (strong) IBOutlet NSTableColumn *columnTwo;
@property (strong) IBOutlet NSTableColumn *columnOne;
@property (strong) IBOutlet NSButton *deleteButton;
@property (strong) IBOutlet NSTextField *folderTextField;
@property (strong) IBOutlet NSTextField *extensionTextField;
@property (strong) IBOutlet NSTableView *rulesTableView;
@property (strong) IBOutlet NSTabView *tabView;
@end
