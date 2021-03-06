/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2010 Ricardo Quesada
 * Copyright (c) 2011 Zynga Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 *
 * File autogenerated with Xcode. Adapted for cocos2d needs.
 * Finally adapted for use in IcedCoffee.
 */

#import "../../icMacros.h"
#ifdef __IC_PLATFORM_IOS

#import <QuartzCore/QuartzCore.h>

#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>

/**
 @brief Defines methods to be implemented by OpenGL ES 2 renderers
 */
@protocol ICESRenderer <NSObject>

- (id)initWithDepthFormat:(unsigned int)depthFormat
          withPixelFormat:(unsigned int)pixelFormat
           withSharegroup:(EAGLSharegroup*)sharegroup
        withMultiSampling:(BOOL) multiSampling
      withNumberOfSamples:(unsigned int)requestedSamples;

- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer;

- (EAGLContext*) context;
- (CGSize) backingSize;

- (unsigned int) colorRenderBuffer;
- (unsigned int) depthBuffer;
- (unsigned int) defaultFramebuffer;
- (unsigned int) msaaFramebuffer;
- (unsigned int) msaaColorBuffer;
@end

#endif // __CC_PLATFORM_IOS
