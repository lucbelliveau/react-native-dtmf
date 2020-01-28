
#import "RNDtmf.h"
#import "ToneGenerator.h"

@implementation RNDtmf

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

RCT_EXPORT_MODULE()

- (NSDictionary *)constantsToExport
{
  return @{
    @"DTMF_1": [NSNumber numberWithInteger:DTMF_1],
    @"DTMF_2": [NSNumber numberWithInteger:DTMF_2],
    @"DTMF_3": [NSNumber numberWithInteger:DTMF_3],
    @"DTMF_4": [NSNumber numberWithInteger:DTMF_4],
    @"DTMF_5": [NSNumber numberWithInteger:DTMF_5],
    @"DTMF_6": [NSNumber numberWithInteger:DTMF_6],
    @"DTMF_7": [NSNumber numberWithInteger:DTMF_7],
    @"DTMF_8": [NSNumber numberWithInteger:DTMF_8],
    @"DTMF_9": [NSNumber numberWithInteger:DTMF_9],
    @"DTMF_0": [NSNumber numberWithInteger:DTMF_0],
    @"DTMF_S": [NSNumber numberWithInteger:DTMF_S],
    @"DTMF_STAR": [NSNumber numberWithInteger:DTMF_S],
    @"DTMF_P": [NSNumber numberWithInteger:DTMF_P],
    @"DTMF_POUND": [NSNumber numberWithInteger:DTMF_P],
    @"DTMF_A": [NSNumber numberWithInteger:DTMF_A],
    @"DTMF_B": [NSNumber numberWithInteger:DTMF_B],
    @"DTMF_C": [NSNumber numberWithInteger:DTMF_C],
    @"DTMF_D": [NSNumber numberWithInteger:DTMF_D],
  };
}

RCT_EXPORT_METHOD(startTone:(NSInteger)tone) {
  startTone((int)tone, 5000);
}

RCT_EXPORT_METHOD(playTone:(NSInteger)tone durationMs:(NSInteger)duration) {
  startTone((int)tone, (int)duration);
}

RCT_EXPORT_METHOD(stopTone) {
  stopTone();
}

@end

