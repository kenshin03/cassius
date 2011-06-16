/*
 Copyright (C) 2011 Red Soldier Limited. All rights reserved.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "FirstPageViewController.h"


@implementation FirstPageViewController

@synthesize pageHeaderView = _pageHeaderView;
@synthesize pageContentView = _pageContentView;
@synthesize pageViews = _pageViews;

@synthesize nextPageButton = _nextPageButton;
@synthesize nextPageButtonImageView = _nextPageButtonImageView;
@synthesize nextPageLabel = _nextPageLabel;

@synthesize prevPageButton = _prevPageButton;
@synthesize prevPageButtonImageView = _prevPageButtonImageView;
@synthesize prevPageLabel = _prevPageLabel;


@synthesize  currentPage= _currentPage;


- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


- (id)initWithViews:(NSMutableArray*)contentsViews
{
    self = [super init];
    self.currentPage = 1;
    if (self) {
        self.pageViews = contentsViews;
        // Initialization code
        if ([self.pageViews count] > 0){
            self.pageContentView = [self.pageViews objectAtIndex:self.currentPage-1];
        }
    }
    return self;
}

- (UIView*)initPageHeader{
    
    CGRect pageFrame = self.view.frame;
    
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
    
    
    UIImage *prevPageButtonImage =  [UIImage imageNamed:@"cassius_header_button.png"];
    UIImageView *prevPageButtonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 25.0f, 200.0f, 50.0f)];
    [prevPageButtonImageView setBackgroundColor:[UIColor clearColor]];
    [prevPageButtonImageView setImage:prevPageButtonImage];     
    self.prevPageButtonImageView = prevPageButtonImageView;
    [prevPageButtonImageView release];
    
    UILabel* prevPageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 25.0f, 200.0f, 50.0f)];
    prevPageLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:24.0];
    [prevPageLabel setBackgroundColor:[UIColor clearColor]];    
    [prevPageLabel setTextColor:[UIColor grayColor]];
    [prevPageLabel setTextAlignment:UITextAlignmentCenter];
    prevPageLabel.text = [NSString stringWithFormat:@"Next"];
    self.prevPageLabel = prevPageLabel;
    [prevPageLabel release];
    
    
    UIButton *prevPageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [prevPageButton setFrame: CGRectMake(0.0f, 25.0f, 200.0f, 50.0f)];
    [prevPageButton setBackgroundColor:[UIColor clearColor]];
    self.prevPageButton = prevPageButton;
    [self.prevPageButton addTarget:self action:@selector(prevPageButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImage *nextPageButtonImage =  [UIImage imageNamed:@"cassius_header_right_button.png"];
    UIImageView *nextPageButtonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(pageFrame.size.width-200.0f, 25.0f, 200.0f, 50.0f)];
    [nextPageButtonImageView setBackgroundColor:[UIColor clearColor]];
    [nextPageButtonImageView setImage:nextPageButtonImage];     
    self.nextPageButtonImageView = nextPageButtonImageView;
    [pageHeaderView addSubview:nextPageButtonImageView];
    [nextPageButtonImageView release];
    
    UILabel* nextPageLabel = [[UILabel alloc]initWithFrame:CGRectMake(pageFrame.size.width-200.0f, 25.0f, 200.0f, 50.0f)];
    nextPageLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:24.0];
    [nextPageLabel setBackgroundColor:[UIColor clearColor]];    
    [nextPageLabel setTextColor:[UIColor grayColor]];
    [nextPageLabel setTextAlignment:UITextAlignmentCenter];
    nextPageLabel.text = [NSString stringWithFormat:@"Next"];
    self.nextPageLabel = nextPageLabel;
    [pageHeaderView addSubview:self.nextPageLabel];
    [nextPageLabel release];
    
    
    UIButton *nextPageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextPageButton setFrame: CGRectMake(pageFrame.size.width-200.0f-CONTENT_AREA_MARGIN_SIDE, 25.0f, 200.0f, 50.0f)];
    [nextPageButton setBackgroundColor:[UIColor clearColor]];
    self.nextPageButton = nextPageButton;
    [self.nextPageButton addTarget:self action:@selector(nextPageButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [pageHeaderView addSubview:self.nextPageButton];
    [pageHeaderView bringSubviewToFront:self.nextPageButton];
    
    
    
    return pageHeaderView;
}

-(void)prevPageButtonClicked
{
    NSLog(@"prevPageButtonClicked");
    [UIView beginAnimations:@"fade out page" context:nil];
    [UIView setAnimationDuration:0.5];
    self.view.alpha = 0;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(showPrevPage:finished:context:)];
    [UIView commitAnimations];

}

- (void)nextPageButtonClicked
{
    
    NSLog(@"nextPageButtonClicked");
    [UIView beginAnimations:@"fade out page" context:nil];
    [UIView setAnimationDuration:0.5];
//    self.view.alpha = 0;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(showNextPage:finished:context:)];
    [UIView commitAnimations];
}

- (void) showNextPage:(NSString *)animationID finished:(NSNumber *) finished context:(void *) context{
    
    
        
    self.pageContentView = [self.pageViews objectAtIndex:self.currentPage-1];    
    [self.view addSubview:self.pageContentView];
    
    /*
    
    [UIView beginAnimations:@"fade in page" context:nil];
    [UIView setAnimationDuration:0.5];
    self.view.alpha = 1;
    [UIView commitAnimations];    
     */
    
    NSLog(@"self.currentPage: %i ", self.currentPage);
    NSLog(@"self.pageViews count: %i ", [self.pageViews count]);
    
    if (self.currentPage > 1){
        
        if (![self.pageHeaderView.subviews containsObject:self.prevPageButtonImageView]){        
            [self.pageHeaderView addSubview:self.prevPageButtonImageView];
            [self.pageHeaderView addSubview:self.prevPageLabel];
            [self.pageHeaderView addSubview:self.prevPageButton];
        }
    }
    if (self.currentPage == [self.pageViews count]){
        [self.nextPageLabel removeFromSuperview];
        [self.nextPageButtonImageView removeFromSuperview];
        [self.nextPageButton removeFromSuperview];
        NSLog(@"removing next page button");
    }
    
}



- (void) showPrevPage:(NSString *)animationID finished:(NSNumber *) finished context:(void *) context{
    [self.pageContentView removeFromSuperview];
    self.currentPage--;
    self.pageContentView = [self.pageViews objectAtIndex:self.currentPage-1];    
    [self.view addSubview:self.pageContentView];
    
    [UIView beginAnimations:@"fade in page" context:nil];
    [UIView setAnimationDuration:0.5];
    self.view.alpha = 1;
    [UIView commitAnimations];    
    
    NSLog(@"self.currentPage: %i ", self.currentPage);
    NSLog(@"self.pageViews count: %i ", [self.pageViews count]);
    
    if (self.currentPage == 1){
        [self.prevPageLabel removeFromSuperview];
        [self.prevPageButtonImageView removeFromSuperview];
        [self.prevPageButton removeFromSuperview];
    }
    if (self.currentPage < [self.pageViews count]){
        if (![self.pageHeaderView.subviews containsObject:self.nextPageButtonImageView]){        
            [self.pageHeaderView addSubview:self.nextPageButtonImageView];
            [self.pageHeaderView addSubview:self.nextPageLabel];
            [self.pageHeaderView addSubview:self.nextPageButton];
        }
    }
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad");
	CGRect windowBounds = [[UIScreen mainScreen] applicationFrame];
	UIView* view = [[UIView alloc] initWithFrame: windowBounds];
    [view setBackgroundColor:[UIColor whiteColor]];
    view.userInteractionEnabled = YES;
    
    UIView* headerView = [self initPageHeader];
    self.pageHeaderView = headerView;
    [view addSubview:self.pageHeaderView];
    [view addSubview:self.pageContentView];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];    
    self.view = view;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
