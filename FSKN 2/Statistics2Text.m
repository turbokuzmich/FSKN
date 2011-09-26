//
//  Statistics2Text.m
//  FSKN
//
//  Created by Дмитрий on 17.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Statistics2Text.h"
#import <CoreText/CoreText.h>


@implementation Statistics2Text

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"Helvetica Neue", 16.0f, NULL);
    CTTextAlignment paragraphAlignment = kCTLeftTextAlignment;
    CGFloat leading = 2.0f;
    CGFloat paragraphSpacing = 11.0f;
    CTParagraphStyleSetting setting[3] = {
        {kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), &paragraphAlignment},
        {kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &leading},
        {kCTParagraphStyleSpecifierParagraphSpacing, sizeof(CGFloat), &paragraphSpacing}
    };
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(setting, 3);
    NSDictionary *attrDictionary = [NSDictionary dictionaryWithObjectsAndKeys:(id)fontRef, (NSString *)kCTFontAttributeName, paragraphStyle, (NSString *)kCTParagraphStyleAttributeName, nil];
    CFRelease(fontRef);
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:@"Опиаты – наркотики, обладающие седативным, «затормаживающим» действием. К этой группе относятся природные и синтетические морфиноподобные соединения. Все природные наркотические средства опийной группы получают из мака. Вызывают состояние эйфории, спокойствия, умиротворения. Включаясь в обменные процессы, приводят к быстрому возникновению сильнейшей психической и физической зависимости. Крайне разрушительно действуют на организм. Наркотические зависимости, вызываемые опиатами, очень трудно поддаются лечению. К опиатам относятся: героин, маковая соломка, ацетилированный опий, опий-сырец, метадон." attributes:attrDictionary];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Flip the coordinate system
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGMutablePathRef path = CGPathCreateMutable(); //5
    CGPathAddRect(path, NULL, CGRectMake(0.0, 0.0, 473.0, 564.0)); // 6
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString); // 7
    CTFrameRef theFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attString length]), path, NULL); // 8
    CFRelease(framesetter); //9
    CFRelease(path); //10
    
    CTFrameDraw(theFrame, context); //11
    CFRelease(theFrame); //12
    
    [attString release];
}

- (void)dealloc
{
    [super dealloc];
}

@end
