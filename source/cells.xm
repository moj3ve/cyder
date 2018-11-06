#import <cyder.h>
#import <UIViews/PackageCellContentView.h>

@interface PackageCell (Cyder)
@property (nonatomic, retain) PackageCellContentView *content_view;
@end

%hook PackageCell
%property (nonatomic, retain) PackageCellContentView *content_view;

- (void)layoutSubviews {
	%orig;
	self.backgroundColor = nil;
	self.contentView.layer.cornerRadius = 13;
	self.contentView.layer.masksToBounds = YES;
	self.contentView.frame = UIEdgeInsetsInsetRect(self.contentView.frame, UIEdgeInsetsMake(2.5, 5, 2.5, 5));
	
	if (self.content_view) {
		self.content_view.frame = self.contentView.bounds;
		[self.content_view layoutSubviews];
	}
}

- (void) setPackage:(Package *)package asSummary:(bool)summary {
	UIView *content = (UIView *)object_getIvar(self, class_getInstanceVariable([self class], "content_"));
	content.backgroundColor = [prefs colorForKey:@"cellColor"];//[UIColor whiteColor];
	
	if (!self.content_view) {
		self.content_view = [[PackageCellContentView alloc] initWithPackage:package];
		[self.contentView addSubview:self.content_view];
	} else {
		[self.content_view refreshWithPackage:package];
	}
}

- (void) drawSummaryContentRect:(CGRect)rect {}
- (void) drawNormalContentRect:(CGRect)rect {}
- (void) drawContentRect:(CGRect)rect {}

%end

%hook SourceCell

- (void)layoutSubviews {
	%orig;
	self.backgroundColor = nil;
	self.contentView.layer.cornerRadius = 13;
	self.contentView.layer.masksToBounds = YES;
	self.contentView.frame = UIEdgeInsetsInsetRect(self.editing ? self.contentView.frame : self.bounds, UIEdgeInsetsMake(2.5, 5, 2.5, 5));
}

%end

%hook SectionCell

- (void)layoutSubviews {
	%orig;
	self.backgroundColor = nil;
	self.contentView.layer.cornerRadius = 13;
	self.contentView.layer.masksToBounds = YES;
	self.contentView.frame = UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(2.5, 5, 2.5, 5));
}

%end

%hook UITableView

- (void)layoutSubviews {
	%orig;
	self.sectionIndexBackgroundColor = [UIColor clearColor];
	self.separatorColor = [UIColor clearColor];
	//self.backgroundColor = [prefs colorForKey:@"tableColor"];//[UIColor groupTableViewBackgroundColor];
}
-(void)didMoveToWindow {
        %orig;
        //No Separators in the Tables
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        //Set the background Color to a Color or to an Image
        //self.backgroundColor = [UIColor blackColor];
        //Set the Background to an Image, Importing UIImage+ScaledImage.h for this
        if([prefs boolForKey:@"enableImage"]) {    
                UIImage *bgImage = [[UIImage imageWithContentsOfFile: @"/var/mobile/Library/Preferences/Cyder/background.jpg"] imageScaledToSize:[[UIApplication sharedApplication] keyWindow].bounds.size];
                self.backgroundView = [[UIImageView alloc] initWithImage: bgImage];
        }else{
                self.backgroundColor = [prefs colorForKey:@"tableColor"];
        }

}


%end
