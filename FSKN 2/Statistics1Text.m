//
//  Statistics1Text.m
//  FSKN
//
//  Created by Дмитрий on 17.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Statistics1Text.h"
#import <CoreText/CoreText.h>


@implementation Statistics1Text

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
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:@"Сегодня в России регулярно употребляют наркотики 5, 99 млн. Официальная статистика по наркомании приводит цифру — 500 тыс. наркоманов, однако эт те, что добровольно встали на медицинский учет. Медицинские учреждения могут стационарно пролечить за год не более 50 тыс. человек.\nСредний возраст приобщения к наркотикам в России составляет по статистике 15-17 лет, резко увеличивается процент употребления наркотиков детьми 9-13 лет. Замечены и случаи употребления наркотиков детьми 6-7 лет —к наркомании их приобщают родители-наркоманы.\nОсновными очагами распространения наркотиков в городах России являются школы и места развлечения молодежи - дискотеки и клубы. 70% из опрошенных первый раз попробовали наркотики именно в здесь.\nПо мнению экспертов, каждый наркоман вовлекает вслед за собой в употребление наркотиков 13-15 человек." attributes:attrDictionary];
    
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
