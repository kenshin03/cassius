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

#import "PageLayoutManager.h"


@implementation PageLayoutManager


- (PageTemplateType*) parseRowBasedTemplate:(NSDictionary*) rowDict{
    NSDictionary* rowContentDict = nil;
    int i = 0;
    
    RowBasedPageTemplate *rowBasedPageTemplate = [[RowBasedPageTemplate alloc] init];
    NSMutableArray *rowsArray = [[NSMutableArray alloc]initWithCapacity:[rowDict count]];
    NSEnumerator* layoutEnumerator = [rowDict objectEnumerator]; 
    while ((rowContentDict = [layoutEnumerator nextObject])){
        i++;
        if ([rowContentDict objectForKey:@"type"] != nil){
            NSString* rowStringContent = [rowContentDict objectForKey:@"type"];
            [rowsArray addObject:rowStringContent];
            
        }else if ([rowContentDict objectForKey:@"columns"] != nil){
            
            NSDictionary* columnsInRowDict = [rowContentDict objectForKey:@"columns"];
            NSEnumerator* columnsInRowEnumerator = [columnsInRowDict objectEnumerator];
            NSDictionary* columnInRowDict = nil;
            
            int x = 0;
            
            NSMutableArray *columnsInRowArray = [[NSMutableArray alloc ] initWithCapacity:[columnsInRowDict count]]; 
            
            while ((columnInRowDict = [columnsInRowEnumerator nextObject])){
                x++;
                NSString* columnInRowString = [columnInRowDict objectForKey:@"type"];
                [columnsInRowArray addObject:columnInRowString];
            }
            [rowsArray addObject:columnsInRowArray];
        }
    }
    [rowBasedPageTemplate setRowsArray:rowsArray];
    return rowBasedPageTemplate;    
}


- (PageTemplateType*) parseColumnBasedTemplate:(NSDictionary*) columDict{
    NSEnumerator* layoutEnumerator = [columDict objectEnumerator]; 
    NSMutableArray *columnsArray = [[NSMutableArray alloc]initWithCapacity:[columDict count]];
    NSDictionary* columnContentDict = nil;
    int i = 0;
    
    ColumnBasedPageTemplate *columnsBasedPageTemplate = [[ColumnBasedPageTemplate alloc] init];
    
    while ((columnContentDict = [layoutEnumerator nextObject])){
        i++;
        if ([columnContentDict objectForKey:@"type"] != nil){
            NSString* columnStringContent = [columnContentDict objectForKey:@"type"];
            [columnsArray addObject:columnStringContent];
            
        }else if ([columnContentDict objectForKey:@"rows"] != nil){
            NSDictionary* rowsInColumnDict = [columnContentDict objectForKey:@"rows"];
            NSEnumerator* rowsInColumnsEnumerator = [rowsInColumnDict objectEnumerator];
            NSDictionary* rowInColumnDict = nil;
            int x =0;
            NSMutableArray *rowsInColumnArray = [[NSMutableArray alloc ] initWithCapacity:[rowsInColumnDict count]]; 
            while ((rowInColumnDict = [rowsInColumnsEnumerator nextObject])){
                x++;
                NSString* rowInColumnString = [rowInColumnDict objectForKey:@"type"];
                [rowsInColumnArray addObject:rowInColumnString];
            }
            [columnsArray addObject:rowsInColumnArray];
        }
    }
    [columnsBasedPageTemplate setColumnsArray:columnsArray];
    return columnsBasedPageTemplate;    
}



- (NSMutableArray*) parsePageTemplateConfig:(NSString*)pagesTemplateString{
    
    NSDictionary *pagesLayoutDict = [[pagesTemplateString JSONValue] objectForKey:@"pages"];
    NSMutableArray *pageTemplatesArray = [[NSMutableArray alloc]initWithCapacity:[pagesLayoutDict count]];
    
    NSEnumerator* pagesEnumerator = [pagesLayoutDict objectEnumerator]; 
    NSDictionary* pageDict = nil;
    PageTemplateType* pageTemplate = nil;
    while ((pageDict = [pagesEnumerator nextObject])){
        // see if page is row based or column based
        if ([pageDict objectForKey:@"rows"] != nil){
            pageTemplate = [self parseRowBasedTemplate:[pageDict objectForKey:@"rows"]];
            [pageTemplatesArray addObject:pageTemplate];
        }else if ([pageDict objectForKey:@"columns"] != nil){
            pageTemplate = [self parseColumnBasedTemplate:[pageDict objectForKey:@"columns"]];
            [pageTemplatesArray addObject:pageTemplate];
        }
    }
    return pageTemplatesArray;
}

- (NSMutableArray*) constructPagesWithTemplate:(NSMutableArray*)pageTemplatesArray storiesFeed:(StoriesFeed*)storiesFeed{
    
    NSMutableArray *pageViewsArray = [[NSMutableArray alloc]initWithCapacity:[pageTemplatesArray count]];
    NSEnumerator *pageTemplatesEnumerator = [pageTemplatesArray objectEnumerator];
    PageTemplateType* pageTemplate = nil;
    
    // whole page
	CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    
    while ((pageTemplate = [pageTemplatesEnumerator nextObject])){
        StoriesPageView* pageView = [[StoriesPageView alloc] initWithFrame: screenBounds];
        [pageView setBackgroundColor:[UIColor whiteColor]];
        pageView.userInteractionEnabled = YES;
        UIView *pageContentView = nil;
        if ([pageTemplate isKindOfClass:[RowBasedPageTemplate class]]){
            pageContentView = [self constructPageWithRowBasedTemplate:pageTemplate storiesFeed:storiesFeed];
        }else if ([pageTemplate isKindOfClass:[ColumnBasedPageTemplate class]]){
            pageContentView = [self constructPageWithColumnBasedTemplate:pageTemplate storiesFeed:storiesFeed];
        }
        pageView.pageContentView = pageContentView;
        [pageContentView release];
        [pageView addSubview:pageView.pageContentView];
        [pageViewsArray addObject:pageView];
    }
    return pageViewsArray;
}


- (UIView*) constructPageWithRowBasedTemplate:(PageTemplateType*)pageTemplate storiesFeed:(StoriesFeed*)storiesFeed{
    
    NSArray* fillerStoriesArray = [storiesFeed fillerStoriesArray];
    NSArray* featuredStoriesArray = [storiesFeed featuredStoriesArray];
    NSArray* shortMessagesArray = [storiesFeed shortMessagesArray];
    
    NSArray *rowsArray = [pageTemplate rowsArray];
    int rowsCount = [rowsArray count];
    
    // the more rows, the shorter each row is
	CGRect windowBounds = [[UIScreen mainScreen] bounds];
    float totalHeight = windowBounds.size.height;
    float totalWidth = windowBounds.size.width- CONTENT_AREA_MARGIN_SIDE - CONTENT_AREA_MARGIN_SIDE;
    totalHeight = totalHeight - CONTENT_AREA_HEADER - CONTENT_AREA_MARGIN_TOP - CONTENT_AREA_MARGIN_BOTTOM;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(CONTENT_AREA_MARGIN_SIDE, CONTENT_AREA_HEADER, totalWidth, totalHeight)];
    contentView.alpha = 1;
    [contentView setBackgroundColor:[UIColor whiteColor]];
    float rowHeight = totalHeight/rowsCount;
    float rowPosY = 0.0f;
    for (int i=0; i<rowsCount; i++){
        UIView *rowView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, rowPosY, totalWidth, rowHeight)];
        
        id rowContent = [rowsArray objectAtIndex:i];
        if ([rowContent isKindOfClass:[NSString class]]){
            
            // temporary
            Story* someStory = [featuredStoriesArray objectAtIndex:i];
            
            NSString *rowType = (NSString*)rowContent;
            if ([rowType isEqualToString:SECTION_TITLE_IMAGE_ABSTRACT]){
                ImageTitleText *imageTitleText = [[ImageTitleText alloc] initWithFrame:CGRectMake(0, 0, totalWidth, rowHeight)];
                
                if ([someStory imageURL] != nil){
                    [imageTitleText setImageURL:[someStory imageURL]];
                }
                if ([someStory title] != nil){
                    [imageTitleText setTitle:[someStory title]];
                }
                [imageTitleText setUserName:[someStory userName]];
                [imageTitleText setUserImageURL:[someStory userImageURL]];
                [imageTitleText setStoryAbstract:[someStory story]];
                [imageTitleText renderContent];
                [rowView addSubview:imageTitleText];
                
            }else if ([rowType isEqualToString:SECTION_IMAGE_TITLE_ABSTRACT]){
                ImageTitleText *imageTitleText = [[ImageTitleText alloc] initWithFrame:CGRectMake(0, 0, totalWidth, rowHeight)];
                
                if ([someStory imageURL] != nil){
                    [imageTitleText setImageURL:[someStory imageURL]];
                }
                [imageTitleText setTitle:[someStory title]];
                [imageTitleText setUserName:[someStory userName]];
                [imageTitleText setUserImageURL:[someStory userImageURL]];
                [imageTitleText setStoryAbstract:[someStory story]];
                [imageTitleText renderContent];
                [rowView addSubview:imageTitleText];
            }
            
        }else if ([rowContent isKindOfClass:[NSArray class]]){
            // deal with columns in this row
            NSArray *columnsArray = (NSArray*)rowContent;
            NSEnumerator *columnsEnumerator = [columnsArray objectEnumerator];
            NSString* columnType = nil;
            int x=0;
            float xPosition = 0.0f;
            int numOfColumns = [columnsArray count];
            float columnWidth = (totalWidth-CONTENT_AREA_MARGIN_SIDE-CONTENT_AREA_MARGIN_SIDE)/numOfColumns;
            
            while ((columnType = [columnsEnumerator nextObject])){
                
                // temporary
                Story* someStory = [shortMessagesArray objectAtIndex:x];
                
                
                if ([columnType isEqualToString:SECTION_TITLE_IMAGE_ABSTRACT]){
                    ImageTitleText *imageTitleText = [[ImageTitleText alloc] initWithFrame:CGRectMake(xPosition, 0, columnWidth, rowHeight)];
                    
                    if ([someStory imageURL] != nil){
                        [imageTitleText setImageURL:[someStory imageURL]];
                    }
                    if ([someStory title] != nil){
                        [imageTitleText setTitle:[someStory title]];
                    }
                    [imageTitleText setUserName:[someStory userName]];
                    [imageTitleText setUserImageURL:[someStory userImageURL]];
                    [imageTitleText setStoryAbstract:[someStory story]];
                    [imageTitleText renderContent];
                    [rowView addSubview:imageTitleText];
                }
                xPosition = xPosition + columnWidth + CONTENT_AREA_MARGIN_SIDE;
                x++;
            }            
        }
        
        rowPosY = rowPosY + rowHeight;
        [contentView addSubview:rowView];
    }
    return contentView;
}


- (UIView*) constructPageWithColumnBasedTemplate:pageTemplate storiesFeed:(StoriesFeed*)storiesFeed{
    NSArray* fillerStoriesArray = [storiesFeed fillerStoriesArray];
    NSArray* featuredStoriesArray = [storiesFeed featuredStoriesArray];
    NSArray* shortMessagesArray = [storiesFeed shortMessagesArray];
    NSArray *columnsArray = [pageTemplate columnsArray];
    int columnsCount = [columnsArray count];
    
    // the more rows, the shorter each row is
	CGRect windowBounds = [[UIScreen mainScreen] bounds];
    float totalWidth = windowBounds.size.width - CONTENT_AREA_MARGIN_SIDE - CONTENT_AREA_MARGIN_SIDE;
    float totalHeight = windowBounds.size.height - CONTENT_AREA_HEADER - CONTENT_AREA_MARGIN_SIDE - CONTENT_AREA_MARGIN_SIDE;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(CONTENT_AREA_MARGIN_SIDE, CONTENT_AREA_HEADER, totalWidth, totalHeight)];
    contentView.alpha = 1;
    [contentView setBackgroundColor:[UIColor whiteColor]];
    
    float columnWidth = totalWidth/columnsCount;
    float columnPosX = 0.0f;
    for (int i=0; i<columnsCount; i++){
        UIView *columnView = [[UIView alloc]initWithFrame:CGRectMake(columnPosX, 0.0f, columnWidth, totalHeight)];
        
        id columnContent = [columnsArray objectAtIndex:i];
        if ([columnContent isKindOfClass:[NSString class]]){
            
            // temporary
            Story* someStory = [featuredStoriesArray objectAtIndex:i];
            
            NSString *columnType = (NSString*)columnContent;
            if ([columnType isEqualToString:SECTION_TITLE_IMAGE_ABSTRACT]){
                ImageTitleText *imageTitleText = [[ImageTitleText alloc] initWithFrame:CGRectMake(0, 0, columnWidth, totalHeight)];
                
                if ([someStory imageURL] != nil){
                    [imageTitleText setImageURL:[someStory imageURL]];
                }
                if ([someStory title] != nil){
                    [imageTitleText setTitle:[someStory title]];
                }
                [imageTitleText setUserName:[someStory userName]];
                [imageTitleText setUserImageURL:[someStory userImageURL]];
                [imageTitleText setStoryAbstract:[someStory story]];
                [imageTitleText renderContent];
                [columnView addSubview:imageTitleText];
                
            }else if ([columnType isEqualToString:SECTION_IMAGE_TITLE_ABSTRACT]){
                ImageTitleText *imageTitleText = [[ImageTitleText alloc] initWithFrame:CGRectMake(0, 0, columnWidth, totalHeight)];
                
                if ([someStory imageURL] != nil){
                    [imageTitleText setImageURL:[someStory imageURL]];
                }
                [imageTitleText setTitle:[someStory title]];
                [imageTitleText setUserName:[someStory userName]];
                [imageTitleText setUserImageURL:[someStory userImageURL]];
                [imageTitleText setStoryAbstract:[someStory story]];
                [imageTitleText renderContent];
                [columnView addSubview:imageTitleText];
            }
            
        }else if ([columnContent isKindOfClass:[NSArray class]]){
            // deal with rows in this column
            NSArray *rowsArray = (NSArray*)columnContent;
            NSEnumerator *rowsEnumerator = [rowsArray objectEnumerator];
            NSString* rowType = nil;
            int x=0;
            float yPosition = 0.0f;
            int numOfRows = [rowsArray count];
            float rowHeight = (totalHeight-CONTENT_AREA_MARGIN_SIDE-CONTENT_AREA_MARGIN_SIDE)/numOfRows;
            
            while ((rowType = [rowsEnumerator nextObject])){
                
                // temporary
                Story* someStory = [shortMessagesArray objectAtIndex:x];
                if ([rowType isEqualToString:SECTION_TITLE_IMAGE_ABSTRACT]){
                    ImageTitleText *imageTitleText = [[ImageTitleText alloc] initWithFrame:CGRectMake(0, yPosition, columnWidth, rowHeight)];
                    
                    if ([someStory imageURL] != nil){
                        [imageTitleText setImageURL:[someStory imageURL]];
                    }
                    if ([someStory title] != nil){
                        [imageTitleText setTitle:[someStory title]];
                    }
                    [imageTitleText setUserName:[someStory userName]];
                    [imageTitleText setUserImageURL:[someStory userImageURL]];
                    [imageTitleText setStoryAbstract:[someStory story]];
                    [imageTitleText renderContent];
                    [columnView addSubview:imageTitleText];
                }
                yPosition = yPosition + columnWidth + CONTENT_AREA_MARGIN_SIDE;
                x++;
            }            
        }
        
        columnPosX = columnPosX + columnWidth;
        [contentView addSubview:columnView];
    }
    return contentView;
}

@end
