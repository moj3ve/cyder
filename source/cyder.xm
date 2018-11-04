#import <objc/runtime.h>
#import <cyder.h>

/*
// CYDIA HOOKS
*/

%hook PackageListController

%new -(CGFloat)tableView: (UITableView *)tableView heightForHeaderInSection: (NSInteger)section {
	return ([tableView.dataSource tableView:tableView numberOfRowsInSection:section] == 0) ? 0 : 36.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	static NSString *prefix = nil;
	static dispatch_once_t once;
	dispatch_once(&once, ^{
		prefix = [[[NSBundle mainBundle] localizedStringForKey:@"NEW_AT" value:nil table:nil] ? : @"" stringByReplacingOccurrencesOfString:@"%@" withString:@""];
	});

	return [%orig stringByReplacingOccurrencesOfString: prefix withString:@""];
}

%end

%hook PackageSettingsController

- (NSString *)tableView: (UITableView *)tableView titleForFooterInSection: (NSInteger)section {
	return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return nil;
}

%end

/*
// UIKIT HOOKS
*/

%hook UINavigationController

- (void)viewDidLoad {
    %orig;
    self.navigationBar.prefersLargeTitles = YES;
    self.navigationBar.topItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
}

%end

%hook UINavigationBar

- (BOOL)_wantsLargeTitleDisplayed {
	return YES;
}

%end

%hook UIViewController

- (void)viewWillAppear: (BOOL)animated {
    %orig;
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.navigationController.navigationBar.topItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
}

%end

%hook UITableViewCellSelectedBackground

- (id)initWithFrame: (CGRect)frame {
	frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(2.5, 5, 2.5, 5));
	if ((self = %orig(frame))) {
		self.layer.cornerRadius = 13;
		self.layer.masksToBounds = YES;
	}

	return self;
}

%end

%hook UISwipeActionStandardButton

- (id)initWithFrame: (CGRect)frame {
	if ((self = %orig)) {
		self.layer.cornerRadius = 13;
		self.layer.masksToBounds = YES;
		self.frame = UIEdgeInsetsInsetRect(self.frame, UIEdgeInsetsMake(5, 0, 0, 0));
	}
	return self;
}

%end

%hook UISwipeActionPullView

-(id)initWithCellEdge: (NSUInteger)edge style: (NSUInteger)style {
	if ((self = %orig)) {
		self.layer.cornerRadius = 13;
		self.layer.masksToBounds = YES;
	}
	return self;
}

%end

%hook UITableViewHeaderFooterView

- (void)layoutSubviews {
	%orig;
	self.backgroundView.backgroundColor = [UIColor groupTableViewBackgroundColor];
	self.textLabel.font = [UIFont boldSystemFontOfSize:18];
}

%end
