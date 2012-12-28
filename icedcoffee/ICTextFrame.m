//
//  Copyright (C) 2012 Tobias Lensing, Marcus Tillmanns
//  http://icedcoffee-framework.org
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//  of the Software, and to permit persons to whom the Software is furnished to do
//  so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "ICTextFrame.h"
#import "ICTextLine.h"
#import "icFontTypes.h"
#import "icFontUtils.h"

@interface ICTextFrame ()
- (void)updateFrame;
@property (nonatomic, retain) NSMutableArray *lines;
@end

@implementation ICTextFrame

@synthesize lines = _lines;
@synthesize attributedString = _attributedString;

+ (id)textFrameWithFrame:(kmVec4)frame string:(NSString *)string font:(ICFont *)font
{
    return [[[[self class] alloc] initWithFrame:frame string:string font:font] autorelease];
}

- (id)initWithFrame:(kmVec4)frame string:(NSString *)string font:(ICFont *)font
{
    return [self initWithFrame:frame
                        string:string
                    attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                font, ICFontAttributeName, nil]];
}

- (id)initWithFrame:(kmVec4)frame string:(NSString *)string attributes:(NSDictionary *)attributes
{
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:string
                                                                           attributes:attributes];
    self = [self initWithFrame:frame attributedString:attributedString];
    [attributedString release];
    return self;
}

- (id)initWithFrame:(kmVec4)frame attributedString:(NSAttributedString *)attributedString
{
    if ((self = [super init])) {
        [self addObserver:self
               forKeyPath:@"attributedString"
                  options:NSKeyValueObservingOptionNew
                  context:nil];
        self.position = kmVec3Make(frame.x, frame.y, 0);
        self.size = kmVec3Make(frame.width, frame.height, 0);
        self.attributedString = attributedString;
    }
    return self;
}

- (void)dealloc
{
    self.attributedString = nil;
    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == self && [keyPath isEqualToString:@"attributedString"]) {
        [self updateFrame];
    }
}

// FIXME: must set bounds on self
- (void)updateFrame
{
    [self removeAllChildren];
    
    CGRect frameRect = CGRectMake(self.origin.x, self.origin.y, self.size.width, self.size.height);
    CGPathRef path = CGPathCreateWithRect(frameRect, NULL);
    
    NSAttributedString *ctAttString = icCreateCTAttributedStringWithAttributedString(self.attributedString);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)ctAttString);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);

    CFArrayRef lines = CTFrameGetLines(frame);
    CFIndex lineCount = CFArrayGetCount(lines);
    self.lines = [NSMutableArray arrayWithCapacity:lineCount];

    CGPoint *origins = (CGPoint *)malloc(sizeof(CGPoint) * lineCount);
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);

    for (CFIndex i=0; i<lineCount; i++) {
        CTLineRef line = (CTLineRef)CFArrayGetValueAtIndex(lines, i);
        ICTextLine *textLine = [[ICTextLine alloc] initWithCoreTextLine:line];
        CGPoint origin = origins[i];
        origin.y += roundf([textLine ascent]);
        NSLog(@"origin: %f", origin.y);
        [textLine setPositionY:self.size.height - origin.y];
        [self.lines addObject:textLine];
        [self addChild:textLine];
        [textLine release];
    }
    
    [ctAttString release];
    free(origins);
    CFRelease(path);
    CFRelease(framesetter);
    CFRelease(frame);
}

@end
