//
//  ViewController.m
//  SampleApp
//
//  Created by Charley Robinson on 12/13/11.
//  Copyright (c) 2011 Tokbox, Inc. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController {
    OTSession* _session;
    OTPublisher* _publisher;
    OTSubscriber* _subscriber;
}

// *** Fill the following variables using your own Project info from the Dashboard  ***
// ***                  (https://dashboard.tokbox.com/projects)                     ***
static NSString* const kApiKey = @"29677082";    // Replace with your API Key
static NSString* const kSessionId = @"1_MX4yOTY3NzA4Mn4xMjcuMC4wLjF-U3VuIE1heSAxOSAxMTo0OTo0MCBQRFQgMjAxM34wLjg0NjQxMjN-"; // Replace with your generated Session ID
static NSString* const kToken = @"T1==cGFydG5lcl9pZD0yOTY3NzA4MiZzZGtfdmVyc2lvbj10YnJ1YnktdGJyYi12MC45MS4yMDExLTAyLTE3JnNpZz1lYjdjMWFjZGZmNzA3MTQwOWE0MjMzNjJhZWQyZTZlOWUwZTNmZjYzOnJvbGU9cHVibGlzaGVyJnNlc3Npb25faWQ9MV9NWDR5T1RZM056QTRNbjR4TWpjdU1DNHdMakYtVTNWdUlFMWhlU0F4T1NBeE1UbzBPVG8wTUNCUVJGUWdNakF4TTM0d0xqZzBOalF4TWpOLSZjcmVhdGVfdGltZT0xMzY4OTg5NDUzJm5vbmNlPTAuMzM1MDMxNDgwMzk3MTExNSZleHBpcmVfdGltZT0xMzY5MDc1ODUyJmNvbm5lY3Rpb25fZGF0YT0=";     // Replace with your generated Token (use Project Tools or from a server-side library)

static bool subscribeToSelf = NO; // Change to YES if you want to subscribe to your own stream.

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _session = [[OTSession alloc] initWithSessionId:kSessionId
                                           delegate:self];
    [self doConnect];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return NO;
    } else {
        return YES;
    }
}

- (void)updateSubscriber {
    for (NSString* streamId in _session.streams) {
        OTStream* stream = [_session.streams valueForKey:streamId];
        if (![stream.connection.connectionId isEqualToString: _session.connection.connectionId]) {
            _subscriber = [[OTSubscriber alloc] initWithStream:stream delegate:self];
            break;
        }
    }
}

#pragma mark - OpenTok methods

- (void)doConnect 
{
    [_session connectWithApiKey:kApiKey token:kToken];
}

- (void)doPublish
{
    _publisher = [[OTPublisher alloc] initWithDelegate:self];
    [_publisher setName:@"Hubo"];
    [_session publish:_publisher];
    //[self.view addSubview:_publisher.view];
    //[_publisher.view setFrame:CGRectMake(0, 0, widgetWidth, widgetHeight)];
}

- (void)sessionDidConnect:(OTSession*)session
{
    NSLog(@"sessionDidConnect (%@)", session.sessionId);
    [self doPublish];
}

- (void)sessionDidDisconnect:(OTSession*)session
{
    NSString* alertMessage = [NSString stringWithFormat:@"Session disconnected: (%@)", session.sessionId];
    NSLog(@"sessionDidDisconnect (%@)", alertMessage);
    [self showAlert:alertMessage];
}


- (void)session:(OTSession*)mySession didReceiveStream:(OTStream*)stream
{
    NSLog(@"session didReceiveStream (%@)", stream.streamId);
    
    // See the declaration of subscribeToSelf above.
    if ( (subscribeToSelf && [stream.connection.connectionId isEqualToString: _session.connection.connectionId])
           ||
         (!subscribeToSelf && ![stream.connection.connectionId isEqualToString: _session.connection.connectionId])
       ) {
        if (!_subscriber) {
            _subscriber = [[OTSubscriber alloc] initWithStream:stream delegate:self];
        }
    }
}

- (void)session:(OTSession*)session didDropStream:(OTStream*)stream{
    NSLog(@"session didDropStream (%@)", stream.streamId);
    NSLog(@"_subscriber.stream.streamId (%@)", _subscriber.stream.streamId);
    if (!subscribeToSelf
        && _subscriber
        && [_subscriber.stream.streamId isEqualToString: stream.streamId])
    {
        _subscriber = nil;
        [self updateSubscriber];
    }
}

- (void)subscriberDidConnectToStream:(OTSubscriber*)subscriber
{
    NSLog(@"subscriberDidConnectToStream (%@)", subscriber.stream.connection.connectionId);
    CGFloat width = [[UIScreen mainScreen] applicationFrame].size.width;
    CGFloat height = [[UIScreen mainScreen] applicationFrame].size.height;
    [subscriber.view setFrame:CGRectMake(0, 0, height, width)];
    [self.view addSubview:subscriber.view];
}

- (void)publisher:(OTPublisher*)publisher didFailWithError:(OTError*) error {
    NSLog(@"publisher didFailWithError %@", error);
    [self showAlert:[NSString stringWithFormat:@"There was an error publishing."]];
}

- (void)subscriber:(OTSubscriber*)subscriber didFailWithError:(OTError*)error
{
    NSLog(@"subscriber %@ didFailWithError %@", subscriber.stream.streamId, error);
    [self showAlert:[NSString stringWithFormat:@"There was an error subscribing to stream %@", subscriber.stream.streamId]];
}

- (void)session:(OTSession*)session didFailWithError:(OTError*)error {
    NSLog(@"sessionDidFail");
    [self showAlert:[NSString stringWithFormat:@"There was an error connecting to session %@", session.sessionId]];
}


- (void)showAlert:(NSString*)string {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message from video session"
                                                    message:string
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end

