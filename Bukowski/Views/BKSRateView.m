//
//  BKSRateView.m
//  Bukowski
//
//  Created by Ezra on 12/15/14.
//  Copyright (c) 2014 CozE. All rights reserved.
//

#import "BKSRateView.h"

@implementation BKSRateView

- (void)baseInit {
    _notSelectedImage = nil;
    _fullSelectedImage = nil;
    _greyImage = nil;
    _rating = nil;
    _editable = NO;
    _imageViews = [[NSMutableArray alloc] init];
    _numberOfStars = 5;
    _midMargin = 5;
    _leftMargin = 5;
    _minImageSize = CGSizeMake(5, 5);
    _delegate = nil;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self baseInit];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self baseInit];
    }
    
    return self;
}

- (void)refresh {
    for (int i=0; i < self.imageViews.count; i++) {
        UIImageView *imageView = [self.imageViews objectAtIndex:i];
        if (!self.rating) {
            imageView.image = self.greyImage;
        } else if (self.rating >= [NSNumber numberWithInt:i+1]) {
            imageView.image = self.fullSelectedImage;
        } else {
            imageView.image = self.notSelectedImage;
        }
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.notSelectedImage == nil) return;
    
    float desiredImageWidth = (self.frame.size.width - (self.leftMargin*2) - (self.midMargin*self.imageViews.count)) / self.imageViews.count;
    float imageWidth = MAX(self.minImageSize.width, desiredImageWidth);
    float imageHeight = MAX(self.minImageSize.height, self.frame.size.height);
    
    for (int i = 0; i < self.imageViews.count; i++) {
        UIImageView *imageView = [self.imageViews objectAtIndex:i];
        CGRect imageFrame = CGRectMake(self.leftMargin + i*(self.midMargin+imageWidth), 0, imageWidth, imageHeight);
        imageView.frame = imageFrame;
    }
        
}

- (void)setNumberOfStars:(int)numberOfStars {
    _numberOfStars = numberOfStars;
    
    // Remove old image views
    for(int i = 0; i < self.imageViews.count; ++i) {
        UIImageView *imageView = (UIImageView *) [self.imageViews objectAtIndex:i];
        [imageView removeFromSuperview];
    }
    [self.imageViews removeAllObjects];
    
    // Add new image views
    for(int i = 0; i < numberOfStars; ++i) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.imageViews addObject:imageView];
        [self addSubview:imageView];
    }
    
    // Relayout and refresh
    [self setNeedsLayout];
    [self refresh];
}

- (void)setRating:(NSNumber*)rating {
    _rating = rating;
    [self refresh];
}

- (void)handleTouchAtLocation:(CGPoint)touchLocation {
    if (!self.editable) {
        return;
    }
    
    NSNumber *newRating = 0;
    for (long i = self.imageViews.count  - 1; i >= 0; i--) {
        UIImageView *imageView = [self.imageViews objectAtIndex:i];
        if (touchLocation.x > imageView.frame.origin.x) {
            newRating = [NSNumber numberWithInt:i+1.0];
            break;
        }
    }
    self.rating = newRating;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    [self handleTouchAtLocation:touchLocation];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    [self handleTouchAtLocation:touchLocation];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
