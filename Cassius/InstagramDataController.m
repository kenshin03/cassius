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


#import "InstagramDataController.h"



@implementation InstagramDataController


- (NSMutableArray*) retrieveTrendingImages{
	NSMutableString* instagramURLString = [[NSMutableString alloc] initWithCapacity:100];
    [instagramURLString appendString:INSTAGRAM_TRENDING_IMAGES_URL];
    NSLog(@"instagramURLString: %@", instagramURLString);
    
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:instagramURLString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
    [instagramURLString release];
    
    NSURLResponse *response;
    NSError *error;
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
	NSString *responseDataString = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSMutableArray *instagramImageArray = [[NSMutableArray alloc]initWithCapacity:10];
    NSLog(@"responseDataString: %@", responseDataString);
    NSDictionary *instagramDict = [responseDataString JSONValue];
    NSArray *dataArray = [instagramDict objectForKey:@"data"];
    for (NSDictionary *dataNode in dataArray) {
        
        InstagramImage *instaImage = [[InstagramImage alloc] init];
        
        if (![[dataNode objectForKey:@"type"] isEqualToString:@"image"]){
            continue;
        }
        NSDictionary *imageNodeDict = [[dataNode objectForKey:@"images"] objectForKey:@"standard_resolution"];
        NSDictionary *fromDict = [dataNode objectForKey:@"user"];
        
        [instaImage setImageURL:[imageNodeDict objectForKey:@"url"]];
        if ([dataNode objectForKey:@"caption"] != nil){
            if ([[dataNode objectForKey:@"caption"] respondsToSelector:@selector(objectForKey:)]){
                [instaImage setCaption:[[dataNode objectForKey:@"caption"] objectForKey:@"text"]];
            }
        }
        [instaImage setInstagramURL:[dataNode objectForKey:@"link"]];
        if (fromDict != nil){
            [instaImage setFromUserName:[fromDict objectForKey:@"username"]];
            [instaImage setFromUserProfileImage:[fromDict objectForKey:@"profile_picture"]];
        }
        [instagramImageArray addObject:instaImage];
    }
    
    [responseDataString release];

    return instagramImageArray;
}


@end
