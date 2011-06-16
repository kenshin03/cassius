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

#import "MainController.h"


@implementation MainController

@synthesize pageViewsArray = _pageViewsArray;
@synthesize coverViewController = _coverViewController;


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



#pragma mark -
#pragma mark Data source implementation


- (NSInteger) numberOfPagesForPageFlipper:(AFKPageFlipper *)pageFlipper {
    
    // need+1 or wont flip to last page
    int numberOfPages = [self.pageViewsArray count]; 
	return numberOfPages;
}


- (UIView *) viewForPage:(NSInteger) page inFlipper:(AFKPageFlipper *) pageFlipper 
{
    page = page - 1;
    UIView* resultView = [self.pageViewsArray objectAtIndex:(page)];
    [resultView setBounds:pageFlipper.bounds];
	return resultView;
}


#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
	[super loadView];
	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
    CGRect screenBounds = [[UIScreen mainScreen] bounds];

	flipper = [[[AFKPageFlipper alloc] initWithFrame:screenBounds] autorelease];
	flipper.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	flipper.dataSource = self;
	
	[self.view addSubview:flipper];
    
}

- (id) init {
    self = [super init];
    if (self) {
        CoverViewController* coverViewController = [[CoverViewController alloc]init];
       
         NSString *pagesTemplateString = @"{\"pages\":[{\"rows\":[{\"type\":\"TIA\"},{\"columns\":[{\"type\":\"TIA\"},{\"type\":\"TIA\"}, {\"type\":\"TIA\"}]}]}, {\"columns\":[{\"type\":\"TIA\"},{\"rows\":[{\"type\":\"TIA\"},{\"type\":\"TIA\"}]}]}, {\"columns\":[{\"type\":\"TIA\"}]}, {\"rows\":[{\"type\":\"TIA\"}, {\"type\":\"TIA\"}]}  ]}";
        
        PageLayoutManager* layoutManager = [[PageLayoutManager alloc] init];
        NSMutableArray* pageTemplatesArray = [layoutManager parsePageTemplateConfig:pagesTemplateString];
        
        TwitterFeedsDataController *twitterFeedsController = [[TwitterFeedsDataController alloc] init];
        StoriesFeed* twitterStoriesFeed = [twitterFeedsController retrieveTwitterFeeds];
        
        NSMutableArray *pageViewsArray = [layoutManager constructPagesWithTemplate:pageTemplatesArray storiesFeed:twitterStoriesFeed];
        
        [pageViewsArray insertObject:coverViewController.view atIndex:0];
        self.pageViewsArray = pageViewsArray;
        [layoutManager release];  
        [twitterFeedsController release];
        [coverViewController release];
	}
	
	return self;
}

- (void)viewWillAppear:(BOOL)animated {
	[self.navigationController setNavigationBarHidden:YES animated:YES];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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
