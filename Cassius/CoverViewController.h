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


#import <UIKit/UIKit.h>
#import "FirstPageViewController.h"
#import "InstagramDataController.h"
#import "PageLayoutManager.h"
#import "TwitterFeedsDataController.h"
#import "StoriesFeed.h"


@interface CoverViewController : UIViewController {
    UIButton *_flipPageButton;
    NSMutableArray *_backgroundImagesArray;
    UIImageView *_bookCoverImageView;
    UILabel *_captionView;
    UILabel *_sharedByUserLabel;
    UIImageView *_sharedByUserImage;
    NSMutableArray *_pageViewsArray;
}

@property(nonatomic, retain) UIButton* flipPageButton;
@property(nonatomic, retain) UIImageView* bookCoverImageView;
@property(nonatomic, assign) NSMutableArray* backgroundImagesArray;
@property(nonatomic, retain) UILabel* captionView;
@property(nonatomic, retain) UILabel* sharedByUserLabel;
@property(nonatomic, retain) UIImageView* sharedByUserImage;
@property(nonatomic, retain) NSMutableArray* pageViewsArray;


@end
