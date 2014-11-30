//
//  ViewController.m
//  GLBlender1
//
//  Created by Super User on 30.11.14.
//  Copyright (c) 2014 Super User. All rights reserved.
//

#import "ViewController.h"
#import "Cube.h"

@interface ViewController () {
    float rotate;
}

@property (strong, nonatomic) GLKBaseEffect *effect;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Set up context
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:context];
    
    // Set up view
    GLKView *glkview = (GLKView *)self.view;
    glkview.context = context;
    
    // OpenGL ES Settings
    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
    glEnable(GL_CULL_FACE);
    
    // Create effect
    [self createEffect];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    glClear(GL_COLOR_BUFFER_BIT);
    
    // Prepare effect
    [self.effect prepareToDraw];
    
    // Set matrices
    [self setMatrices];
    
    // Positions
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, cubePositions);
    
    // Normals
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 0, cubeNormals);
    
    // Texels
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, cubeTexels);
    
    // Draw Model
    glDrawArrays(GL_TRIANGLES, 0, cubeVertices);
}

- (void)createEffect {
    // Initialize
    self.effect = [[GLKBaseEffect alloc] init];
    
    // Light
    self.effect.light0.enabled = GL_TRUE;
    self.effect.light0.position = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    self.effect.lightingType = GLKLightingTypePerPixel;
    
    // Texture
    NSDictionary *options = @{ GLKTextureLoaderOriginBottomLeft: @YES };
    NSError *error;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cube.png" ofType:nil];
    GLKTextureInfo *texture = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
    
    if(texture == nil)
        NSLog(@"Error loading file: %@", [error localizedDescription]);
    
    self.effect.texture2d0.name = texture.name;
    self.effect.texture2d0.enabled = true;
}

- (void)setMatrices {
    
    // Projection Matrix
    const GLfloat aspectRatio = (GLfloat)(self.view.bounds.size.width) / (GLfloat)(self.view.bounds.size.height);
    const GLfloat fieldView = GLKMathDegreesToRadians(90.0f);
    const GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(fieldView, aspectRatio, 0.1f, 10.0f);
    
    self.effect.transform.projectionMatrix = projectionMatrix;
    
    // ModelView Matrix
    GLKMatrix4 modelViewMatrix = GLKMatrix4Identity;
    modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, 0.0f, 0.0f, -5.0f);
    modelViewMatrix = GLKMatrix4RotateX(modelViewMatrix, GLKMathDegreesToRadians(45.0f));
     // ModelView Matrix rotation
    modelViewMatrix = GLKMatrix4RotateY(modelViewMatrix, GLKMathDegreesToRadians(rotate));
    modelViewMatrix = GLKMatrix4RotateZ(modelViewMatrix, GLKMathDegreesToRadians(rotate));
    
    self.effect.transform.modelviewMatrix = modelViewMatrix;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)update
{
    rotate += 1.0f;
}

@end
