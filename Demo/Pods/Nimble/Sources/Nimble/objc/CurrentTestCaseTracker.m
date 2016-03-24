#import <XCTest/XCTest.h>
#import <Nimble/Nimble-Swift.h>

SWIFT_CLASS("_TtC6Nimble22CurrentTestCaseTracker")
@interface CurrentTestCaseTracker : NSObject <XCTestObservation>
+ (CurrentTestCaseTracker *)sharedInstance;
@end

@interface CurrentTestCaseTracker (Register) @end

@implementation CurrentTestCaseTracker (Register)

+ (void)load {
    CurrentTestCaseTracker *tracker = [CurrentTestCaseTracker sharedInstance];
    [[XCTestObservationCenter sharedTestObservationCenter] addTestObserver:tracker];
}

@end
