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
#import "PageLayoutManager.h"


@interface FirstPageViewController : UIViewController {
    UIView *_pageHeaderView;
    
    UIView *_pageContentView;
    NSMutableArray *_pageViews;
    UIButton *_nextPageButton;
    UIImageView *_nextPageButtonImageView;
    UILabel *_nextPageLabel;
    
    UIButton *_prevPageButton;
    UIImageView *_prevPageButtonImageView;
    UILabel *_prevPageLabel;
    
    
    int currentPage;
}

@property(nonatomic, retain) UIView* pageHeaderView;
@property(nonatomic, retain) UIView* pageContentView;

@property(nonatomic, assign) NSMutableArray* pageViews;
@property(nonatomic, retain) UIButton* nextPageButton;
@property(nonatomic, retain) UIImageView* nextPageButtonImageView;
@property(nonatomic, retain) UILabel* nextPageLabel;

@property(nonatomic, retain) UIButton* prevPageButton;
@property(nonatomic, retain) UIImageView* prevPageButtonImageView;
@property(nonatomic, retain) UILabel* prevPageLabel;



@property(nonatomic) int currentPage;


@end
