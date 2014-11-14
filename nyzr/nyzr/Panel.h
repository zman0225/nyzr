@interface Panel : NSPanel <NSTableViewDelegate, NSTableViewDataSource, NSTextFieldDelegate>
@property (strong) IBOutlet NSTextField *monitoredTextLabel;
@property (strong) IBOutlet NSTextField *rootTextLabel;
@property (strong) IBOutlet NSTableColumn *columnTwo;
@property (strong) IBOutlet NSTableColumn *columnOne;
@property (strong) IBOutlet NSButton *deleteButton;
@property (strong) IBOutlet NSTextField *folderTextField;
@property (strong) IBOutlet NSTextField *extensionTextField;
@property (strong) IBOutlet NSTableView *rulesTableView;
@property (strong) IBOutlet NSTabView *tabView;
@property (strong) IBOutlet NSScrollView *scrollView;

+ (NSArray *)directoryPicker;
@end
