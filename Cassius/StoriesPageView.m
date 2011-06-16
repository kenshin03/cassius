//
//  StoriesPageView.m
//  Cassius
//
//  Created by ktang on 6/16/11.
//  Copyright 2011 Red Soldier Limited. All rights reserved.
//

#import "StoriesPageView.h"


@implementation StoriesPageView

@synthesize pageHeaderView = _pageHeaderView;
@synthesize pageContentView = _pageContentView;



- (UIView*)initPageHeader{
    
    CGRect pageFrame = self.frame;
    
    UIView *pageHeaderView = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0f, pageFrame.size.width, CONTENT_AREA_HEADER)];
    [pageHeaderView setBackgroundColor:[UIColor clearColor]];
    pageHeaderView.userInteractionEnabled = YES;
    
    UILabel* headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(pageFrame.size.width/2-200.0f/2, 25.0f, 200.0f, 50.0f)];
    headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:40.0];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    [headerLabel setTextColor:[UIColor blackColor]];
    headerLabel.text = [NSString stringWithFormat:@"Twitter"];
    headerLabel.textAlignment = UITextAlignmentCenter;
    [pageHeaderView addSubview:headerLabel];
    [headerLabel release];
    
    
    
    return pageHeaderView;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad");
    
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect windowBounds = [[UIScreen mainScreen] applicationFrame];
        UIView* view = [[UIView alloc] initWithFrame: windowBounds];
        [view setBackgroundColor:[UIColor whiteColor]];
        view.userInteractionEnabled = YES;
        
        UIView* headerView = [self initPageHeader];
        self.pageHeaderView = headerView;
        [self addSubview:self.pageHeaderView];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [super dealloc];
}

@end
