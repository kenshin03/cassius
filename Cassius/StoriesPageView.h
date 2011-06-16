//
//  StoriesPageView.h
//  Cassius
//
//  Created by ktang on 6/16/11.
//  Copyright 2011 Red Soldier Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageLayoutManager.h"


@interface StoriesPageView : UIView {
    UIView *_pageHeaderView;
    UIView *_pageContentView;

    
}

@property(nonatomic, retain) UIView* pageHeaderView;
@property(nonatomic, retain) UIView* pageContentView;


@end
