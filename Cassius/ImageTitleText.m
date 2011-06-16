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

#import "ImageTitleText.h"


@implementation ImageTitleText

@synthesize imageURL = _imageURL;
@synthesize title = _title;
@synthesize storyAbstract = _storyAbstract;
@synthesize userName = _userName;
@synthesize userImageURL = _userImageURL;

@synthesize titleView = _titleView;
@synthesize imageView = _imageView;
@synthesize storyAbstractView = _storyAbstractView;


- (void)renderContent{
/* 
    
    UIImageView *localBookCoverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768.0f, 1024.0f)];
    [localBookCoverImageView setBackgroundColor:[UIColor clearColor]];
    [localBookCoverImageView setImage:backgroundImage];     
    self.bookCoverImageView = localBookCoverImageView;
    [self.view insertSubview:self.bookCoverImageView atIndex:0];
    [localBookCoverImageView release];
*/    

    
    UILabel *localTitleView = [[UILabel alloc]initWithFrame:CGRectMake(CONTENT_AREA_MARGIN_SIDE, CONTENT_AREA_MARGIN_SIDE, self.frame.size.width-CONTENT_AREA_MARGIN_SIDE, 30.0f)];
    localTitleView.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:28.0];
    [localTitleView setBackgroundColor:[UIColor clearColor]];
    [localTitleView setTextColor:[UIColor blackColor]];
    [localTitleView setTextAlignment:UITextAlignmentLeft];
    localTitleView.text = self.title;
    localTitleView.lineBreakMode = UILineBreakModeTailTruncation;
    localTitleView.numberOfLines = 0;
    localTitleView.alpha = 1.0;
    [self addSubview:localTitleView];
    [localTitleView release];
    
    
    NSData* userImageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[self userImageURL]]];
    UIImage *userImage = [UIImage imageWithData:userImageData];
    [userImageData release];
    
    UIImageView *localFromUserImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CONTENT_AREA_MARGIN_SIDE, CONTENT_AREA_MARGIN_SIDE+40.0f, 40.0f, 40.0f)];
    [localFromUserImageView setBackgroundColor:[UIColor clearColor]];
    [localFromUserImageView setImage:userImage];     
    [self addSubview:localFromUserImageView];
    [localFromUserImageView release];
    
    UILabel *userNameView = [[UILabel alloc]initWithFrame:CGRectMake(CONTENT_AREA_MARGIN_SIDE+50.0f, CONTENT_AREA_MARGIN_SIDE+40.0f, self.frame.size.width-CONTENT_AREA_MARGIN_SIDE-CONTENT_AREA_MARGIN_SIDE-40.0f, 40.0f)];
    userNameView.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
    [userNameView setBackgroundColor:[UIColor clearColor]];
    [userNameView setTextColor:[UIColor grayColor]];
    [userNameView setTextAlignment:UITextAlignmentLeft];
    
    NSString *userNameString = @"Shared by ";
    userNameString = [userNameString stringByAppendingFormat:@"%@", self.userName];    
    userNameView.text = userNameString;
    userNameView.lineBreakMode = UILineBreakModeTailTruncation;
    [self addSubview:userNameView];
    [userNameView release];
    
    
    
    UILabel *localAbstractView = [[UILabel alloc]initWithFrame:CGRectMake(CONTENT_AREA_MARGIN_SIDE, 100.0f+CONTENT_AREA_MARGIN_SIDE, self.frame.size.width-CONTENT_AREA_MARGIN_SIDE-CONTENT_AREA_MARGIN_SIDE, self.frame.size.height-120.0f-CONTENT_AREA_MARGIN_SIDE)];
    localAbstractView.font = [UIFont fontWithName:@"HelveticaNeue" size:22.0];
    [localAbstractView setBackgroundColor:[UIColor clearColor]];
    [localAbstractView setTextColor:[UIColor blackColor]];
    [localAbstractView setTextAlignment:UITextAlignmentLeft];
    localAbstractView.text = self.storyAbstract;
    localAbstractView.lineBreakMode = UILineBreakModeTailTruncation;
    localAbstractView.numberOfLines = 0;
    localAbstractView.alpha = 1.0;
    [self addSubview:localAbstractView];
    [localAbstractView release];
    
/*    
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
*/    
    
    CALayer *viewBackgroundLayer = [CALayer layer];
    viewBackgroundLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    viewBackgroundLayer.borderWidth = 0.5;
    viewBackgroundLayer.masksToBounds = YES;
    viewBackgroundLayer.borderColor = [UIColor grayColor].CGColor;
    viewBackgroundLayer.backgroundColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:viewBackgroundLayer];
    
    
}

@end
