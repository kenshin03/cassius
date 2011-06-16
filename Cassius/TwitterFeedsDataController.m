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


#import "TwitterFeedsDataController.h"


@implementation TwitterFeedsDataController


- (StoriesFeed*) retrieveTwitterFeeds{
	NSMutableString* twitterURLString = [[NSMutableString alloc] initWithCapacity:100];
    [twitterURLString appendString:TWITTER_STORIES_URL];
    NSLog(@"twitterURLString: %@", twitterURLString);
    
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:twitterURLString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
    [twitterURLString release];
    
    NSURLResponse *response;
    NSError *error;
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
	NSString *responseDataString = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
    
    StoriesFeed *storiesFeed = [[StoriesFeed alloc]init];
    NSMutableArray *featuredStoriesArray = [[NSMutableArray alloc]initWithCapacity:30];
    NSMutableArray *fillerStoriesArray = [[NSMutableArray alloc]initWithCapacity:30];
    NSMutableArray *shortMessgesArray = [[NSMutableArray alloc]initWithCapacity:30];
    
    NSDictionary *responseDataDict = [responseDataString JSONValue];
    
    NSArray *featureStoriesNodesArray = [responseDataDict objectForKey:@"featuredStories"];
    for (NSDictionary *dataNode in featureStoriesNodesArray) {
        
        Tweet *tweet = [[Tweet alloc] init];
        [tweet setDate:[dataNode objectForKey:@"date"]];
        [tweet setTitle:[dataNode objectForKey:@"title"]];
        [tweet setStory:[dataNode objectForKey:@"story"]];
        if ([dataNode objectForKey:@"imageURL"] != nil){
            [tweet setImageURL:[dataNode objectForKey:@"imageURL"]];
        }
        [tweet setUserName:[dataNode objectForKey:@"authorName"]];
        [tweet setUserImageURL:[dataNode objectForKey:@"authorImageURL"]];
        
        [featuredStoriesArray addObject:tweet];
    }
    [storiesFeed setFeaturedStoriesArray:featuredStoriesArray];
    
    
    NSArray *fillerStoriesNodesArray = [responseDataDict objectForKey:@"fillerStories"];
    for (NSDictionary *dataNode in fillerStoriesNodesArray) {
        
        Tweet *tweet = [[Tweet alloc] init];
        [tweet setDate:[dataNode objectForKey:@"date"]];
        [tweet setTitle:[dataNode objectForKey:@"title"]];
        [tweet setStory:[dataNode objectForKey:@"story"]];
        if ([dataNode objectForKey:@"imageURL"] != nil){
            [tweet setImageURL:[dataNode objectForKey:@"imageURL"]];
        }
        [tweet setUserName:[dataNode objectForKey:@"authorName"]];
        [tweet setUserImageURL:[dataNode objectForKey:@"authorImageURL"]];
        
        [fillerStoriesArray addObject:tweet];
    }
    [storiesFeed setFillerStoriesArray:fillerStoriesArray];
    
    NSArray *shortMessagesNodesArray = [responseDataDict objectForKey:@"shortMessages"];
    for (NSDictionary *dataNode in shortMessagesNodesArray) {
        
        Tweet *tweet = [[Tweet alloc] init];
        [tweet setDate:[dataNode objectForKey:@"date"]];
        [tweet setTitle:[dataNode objectForKey:@"title"]];
        [tweet setStory:[dataNode objectForKey:@"message"]];
        [tweet setUserName:[dataNode objectForKey:@"authorName"]];
        [tweet setUserImageURL:[dataNode objectForKey:@"authorImageURL"]];
        
        [shortMessgesArray addObject:tweet];
    }
    [storiesFeed setShortMessagesArray:shortMessgesArray];
    
    
    [responseDataString release];
    
    return storiesFeed;
}



@end
