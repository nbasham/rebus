#import <Foundation/Foundation.h>

enum { SPACE, ANSWERED, UNANSWERED }; typedef NSUInteger AnswerState;

@interface RebusAnswerPlayState : NSObject<NSCoding> {
    char answer;
    char value;
}

@property(nonatomic, assign) AnswerState state;

-(id)initWithCharacter:(char)c;
-(BOOL)isCorrect;
-(NSString*)getStringValue;
-(char)getValue;
-(void)updateValue:(char)c;

@end
