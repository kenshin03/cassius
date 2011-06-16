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


#import "CoverViewController.h"


@implementation CoverViewController

@synthesize flipPageButton = _flipPageButton;
@synthesize backgroundImagesArray = _backgroundImagesArray;
@synthesize bookCoverImageView = _bookCoverImageView;
@synthesize sharedByUserLabel = _sharedByUserLabel;
@synthesize sharedByUserImage = _sharedByUserImage;
@synthesize pageViewsArray = _pageViewsArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
	CGRect screenBounds = [[UIScreen mainScreen] bounds];
	UIView* view = [[UIView alloc] initWithFrame: screenBounds];
    [view setBackgroundColor:[UIColor blackColor]];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.view = view;
    [self.navigationController setNavigationBarHidden:YES animated:NO];    
	[self initCover];
    
    
	[self initInterface];
}


- (void) initCover{
    
    InstagramDataController* instagramData = [[InstagramDataController alloc] init];
    NSMutableArray* instagramArray = [instagramData retrieveTrendingImages];
    self.backgroundImagesArray = instagramArray;
    int minIndex = 0;
    int arrayCount = [self.backgroundImagesArray count];
    
    if (arrayCount > 0){
    
        int randomImageIndex = ((arc4random()%(arrayCount-minIndex+1))+minIndex)-1;
        InstagramImage *instaImage = [self.backgroundImagesArray objectAtIndex:randomImageIndex];
        
        NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[instaImage imageURL]]];
        UIImage *backgroundImage = [UIImage imageWithData:imageData];
        [imageData release];
        
        UIImageView *localBookCoverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768.0f, 1024.0f)];
        [localBookCoverImageView setBackgroundColor:[UIColor clearColor]];
        [localBookCoverImageView setImage:backgroundImage];     
        self.bookCoverImageView = localBookCoverImageView;
        [self.view insertSubview:self.bookCoverImageView atIndex:0];
        [localBookCoverImageView release];
        
        UILabel *localCaptionView = [[UILabel alloc]initWithFrame:CGRectMake(300.0f, 680.0f, 400.0f, 50.0f)];
        localCaptionView.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:32.0];
        [localCaptionView setBackgroundColor:[UIColor clearColor]];    
        [localCaptionView setTextColor:[UIColor whiteColor]];
        [localCaptionView setTextAlignment:UITextAlignmentRight];
        localCaptionView.text = [instaImage caption];
        localCaptionView.lineBreakMode = UILineBreakModeCharacterWrap;
        localCaptionView.alpha = 1.0;
        localCaptionView.shadowColor = [UIColor blackColor];
        localCaptionView.shadowOffset = CGSizeMake(0.2,0.3);
        [self.view addSubview:localCaptionView];
        [localCaptionView release];
        
        UILabel *localSharedByUserNameView = [[UILabel alloc]initWithFrame:CGRectMake(440.0f, 750.0f, 250.0f, 40.0f)];
        localSharedByUserNameView.font = [UIFont fontWithName:@"HelveticaNeue" size:26.0];
        [localSharedByUserNameView setBackgroundColor:[UIColor clearColor]];    
        [localSharedByUserNameView setTextColor:[UIColor whiteColor]];
        [localSharedByUserNameView setTextAlignment:UITextAlignmentLeft];    
        NSString* sharedByString = @"Shared by ";
        localSharedByUserNameView.text = [sharedByString stringByAppendingString:[instaImage fromUserName]];
        localSharedByUserNameView.lineBreakMode = UILineBreakModeCharacterWrap;
        localSharedByUserNameView.alpha = 1.0;
        localSharedByUserNameView.shadowColor = [UIColor blackColor];
        localSharedByUserNameView.shadowOffset = CGSizeMake(0.2,0.3);
        self.sharedByUserLabel = localSharedByUserNameView;
        [self.view addSubview:self.sharedByUserLabel];
        [localSharedByUserNameView release];
        
        
        NSData* userImageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[instaImage fromUserProfileImage]]];
        UIImage *userImage = [UIImage imageWithData:userImageData];
        [userImageData release];
        
        UIImageView *localUserImageView = [[UIImageView alloc] initWithFrame:CGRectMake(710.0f, 740.0f, 50.0f, 50.0f)];
        [localUserImageView setBackgroundColor:[UIColor clearColor]];
        [localUserImageView setImage:userImage];     
        localUserImageView.alpha = 1.0;
        self.sharedByUserImage = localUserImageView;
        [self.view addSubview:self.sharedByUserImage];
        [localUserImageView release];
        
        /*
        [UIView beginAnimations:@"nice ken burns fade" context:NULL];
        [UIView setAnimationDuration:30];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationRepeatAutoreverses:YES];
        [UIView setAnimationRepeatCount:10];
        CGAffineTransform rotate = CGAffineTransformMakeRotation(0.95);
        CGAffineTransform moveRight = CGAffineTransformMakeTranslation(100, 200);
        CGAffineTransform combo1 = CGAffineTransformConcat(rotate, moveRight);
        CGAffineTransform zoomIn = CGAffineTransformMakeScale(1.5, 1.5);
        CGAffineTransform transform = CGAffineTransformConcat(zoomIn, combo1);
        self.bookCoverImageView.transform = transform;
        [UIView commitAnimations];	
         */
    }
    
    
    [instagramData release];
    
}


- (void) initInterface{
    
    UILabel* headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(25.0f, 150.0f, 250.0f, 50.0f)];
    headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:28.0];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    [headerLabel setTextColor:[UIColor whiteColor]];
    headerLabel.text = [NSString stringWithFormat:@"Cassius"];
    [self.view addSubview:headerLabel];
    [headerLabel release];
    
    UIImage *logoImage =  [UIImage imageNamed:@"cover-flipboard-logo-square-white.png"];
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25.0f, 17.0f, 130.0f, 130.0f)];
    [logoImageView setBackgroundColor:[UIColor clearColor]];
    [logoImageView setImage:logoImage];     
    [self.view addSubview:logoImageView];
    [logoImageView release];
    /*
    
    UILabel* flipPageLabel = [[UILabel alloc]initWithFrame:CGRectMake(618.0f, 600.0f, 150.0f, 50.0f)];
    flipPageLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0];
    [flipPageLabel setBackgroundColor:[UIColor blackColor]];    
    [flipPageLabel setTextColor:[UIColor whiteColor]];
    [flipPageLabel setTextAlignment:UITextAlignmentCenter];
    flipPageLabel.text = [NSString stringWithFormat:@"<  F L I P"];
    flipPageLabel.alpha = 0.7;
    [self.view addSubview:flipPageLabel];
    [flipPageLabel release];
    
    UIButton *localFlipPageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [localFlipPageButton setFrame: CGRectMake(618.0f, 600.0f, 150.0f, 50.0f)];
    [localFlipPageButton addTarget:self action:@selector(flipPageButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.flipPageButton = localFlipPageButton;
    [self.view addSubview:self.flipPageButton];
    [localFlipPageButton release];
    
*/
}

- (void)flipPageButtonClicked
{
    NSLog(@"flipPageButtonClicked");
    
    // try laying out page
//    NSString *pagesTemplateString = @"{\"pages\":[{\"rows\":[{\"type\":\"TIA\"},{\"columns\":[{\"type\":\"TIA\"},{\"type\":\"TIA\"}, {\"type\":\"TIA\"}]}]}, {\"columns\":[{\"type\":\"TIA\"},{\"rows\":[{\"TIA\"},{\"TIA\"}]}]} ]}";
    
    
    FirstPageViewController* firstPageViewController = [[FirstPageViewController alloc] initWithViews:self.pageViewsArray];    

    
//    self.view = firstPageViewController.view;
    
	[self.navigationController pushViewController:firstPageViewController animated:NO]; 
	[firstPageViewController release];    
    
}



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

- (void)flipsideViewControllerDidFinish:(FirstPageViewController *)controller {
    
    [self dismissModalViewControllerAnimated:YES];
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

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
