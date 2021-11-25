import java.io.File;
import controlP5.*;
ControlP5 cp5;

SimpleUIManager uiManager;
Document document;

SimpleButton greyScale, blackWhite, quitApp, lineButton, rectButton, selectButton, circleButton, sharpEdge, blurEffect;

PImage img1, photoCopy;



boolean imageLoaded = false;
boolean drawLineFlag = false;
boolean drawCircleFlag = false;
boolean drawRectFlag = false;

String path;
String toolMode = "";

float adjustBrightness, adjustContrast;
float v = 1.0 / 9.0;
float[][] kernel = {{ -1, -1, -1}, 
                    { -1,  9, -1}, 
                    { -1, -1, -1}};
                    
                    

float[][] blurKernel = {{ v, v, v }, 
                        { v, v, v }, 
                        { v, v, v }};   
                        
                        
int x, y, x0, y0, firstPress = 1;

void setup() {
 
  size(1280,600);
  int top = 0;
  
  uiManager = new SimpleUIManager();
  document = new Document();
  cp5 = new ControlP5(this);
  
  String[] menu1Items =  { "loadImage", "saveImage", "resetImage", "refreshBackground" };
  uiManager.addMenu("imageEditing", 100, top, menu1Items);
  quitApp = uiManager.addSimpleButton("QUIT", 5, 550);
 
  greyScale = uiManager.addToggleButton("Greyscale", 5, 5);
  blackWhite = uiManager.addToggleButton("B&W", 5, 55);
  sharpEdge = uiManager.addToggleButton("SharpEd", 5, 105);
  blurEffect = uiManager.addToggleButton("Blur", 5, 155);
  lineButton = uiManager.addRadioButton("line", 5, 205, "group1");
  rectButton = uiManager.addRadioButton("rect", 5, 255, "group1");
  circleButton = uiManager.addRadioButton("circle", 5, 305, "group1");
  selectButton = uiManager.addRadioButton("select", 5, 355, "group1");

  cp5.addSlider("Brightness Level").setRange(-255, 255).setValue(0).setPosition(600, 20).setSize(100, 20).getCaptionLabel().setColor(color(255,0,0));
  cp5.addSlider("Contrast Level").setRange(1, 10).setValue(1).setPosition(600, 50).setSize(100, 20).getCaptionLabel().setColor(color(255,0,0));
  cp5.addSlider("Line Weight").setRange(1, 10).setValue(1).setPosition(300, 60).setSize(100, 20).getCaptionLabel().setColor(color(255,0,0));

  uiManager.addCanvas(100,100,790,590);
  
  smooth();
  T = new points[nPoints];
  background(255);

}

void draw() {
  uiManager.drawMe();
  ;
  if (rectButton.selected || selectButton.selected) {
      
      background(255);
      uiManager.drawMe(); 
      document.drawMe();
  }
  
  if (imageLoaded) {
     background(255);
     uiManager.drawMe();
     contrastBrightness();
    
  }
  
  if (drawLineFlag && lineButton.selected) {
      drawLine();
    
  }
  
  
  if (drawCircleFlag && circleButton.selected) {
        background(255);
        uiManager.drawMe();
        document.drawMe();

        displayCirclePoints();
     
    }
  
    if (sharpEdge.selected) {
        sharpenEdges ();
     
    }
    
    if (blurEffect.selected) {
        blurImage();
      
      
    }
    
    if (greyScale.selected) { 
      grayscaleConversion();
         
    }
    
    if (blackWhite.selected) {
         blackAndWhite();
         
    }
     
     
}


void displayCirclePoints() {
  
      background(255);
      uiManager.drawMe();
      if (j == nPoints)  
      {    
        Det = (T[0].p.x * T[1].p.y)  + (T[1].p.x * T[2].p.y) + (T[2].p.x * T[0].p.y);
        Det -= (T[0].p.y * T[1].p.x)  + (T[1].p.y * T[2].p.x) + (T[2].p.y * T[0].p.x);
    
        if (abs(Det) < 50.)  
        {      
        }
        else  
        {
          displayCircle(); 
          displayCenter(); 
        }
      }
  
      if (j > 0)
      {
      for (int i = 0; i < j; i++)
        {
          T[i].rollover(mouseX,mouseY);
          T[i].drag(mouseX,mouseY);
          T[i].display();
          
        }
      } 

}


void grayscaleConversion() {
  
  photoCopy = img1.get();
  photoCopy.loadPixels();
  
  for (int x = 0; x < photoCopy.width; x++) {
    for (int y = 0; y < photoCopy.height; y++ ) {
     
      int loc = x + y*photoCopy.width;
      float grey = red(photoCopy.pixels[loc]) + green(photoCopy.pixels[loc]) + blue(photoCopy.pixels[loc]) / 3;
      
      color c = color(grey);
      photoCopy.pixels[y*photoCopy.width + x] = c;
      
    }

  }

  photoCopy.updatePixels();
  image(photoCopy,100, 100, 700, 500);
}


void blackAndWhite() {
  float threshold = 127;
  
  photoCopy = img1.get();
  photoCopy.loadPixels();
  
  for (int x = 0; x < photoCopy.width; x++) {
    for (int y = 0; y < photoCopy.height; y++ ) {
      int loc = x + y*photoCopy.width;
      
      if (brightness(photoCopy.pixels[loc]) > threshold) {
        photoCopy.pixels[loc]  = color(255);  // White
      }  else {
        photoCopy.pixels[loc]  = color(0);    // Black
      }
    }
  }
 
  photoCopy.updatePixels();
  image(photoCopy,100, 100, 700, 500);
}

void selectImage () {
  selectInput("Select image", "loadedImage");
  
}

void loadedImage (File selection) {
  
  if (selection == null) {
       println("Window was closed or the user hit cancel.");
      // exit();
        
  } else {
       println("User selected " + selection.getAbsolutePath());
       path = selection.getAbsolutePath();
       img1 = loadImage(path);
       imageLoaded = true;
      
  }
    
}
 
void drawLine () {
  
  float lineWeightSlider = cp5.getController("Line Weight").getValue();
  
   if (mousePressed == true && (mouseButton == RIGHT) && firstPress == 1) {
    strokeWeight(lineWeightSlider);
    firstPress = 0;
    x0 = mouseX;
    y0 = mouseY;
 
    point(x0, y0);
    
   }
  
  if (mousePressed == true && (mouseButton == RIGHT)  && firstPress == 0) {
    strokeWeight(lineWeightSlider);
    x = mouseX;
    y = mouseY;
    point(x, y);
    line(x0, y0, x, y);
    x0 = x;
    y0 = y;
  }
  
}

void contrastBrightness () {
  
   photoCopy = img1.get();
   photoCopy.loadPixels();
   
   int w = photoCopy.width;
   int h = photoCopy.height;
   
   adjustContrast = cp5.getController("Contrast Level").getValue();
   adjustBrightness = cp5.getController("Brightness Level").getValue();

   for(int i = 0; i < w*h; i++)
   {  
    
       int r = (int) red(photoCopy.pixels[i]);
       int g = (int) green(photoCopy.pixels[i]);
       int b = (int) blue(photoCopy.pixels[i]);
       
       r = (int)(r * adjustContrast + adjustBrightness); 
       g = (int)(g * adjustContrast + adjustBrightness);
       b = (int)(b * adjustContrast + adjustBrightness);
     
       r = r < 0 ? 0 : r > 255 ? 255 : r;
       g = g < 0 ? 0 : g > 255 ? 255 : g;
       b = b < 0 ? 0 : b > 255 ? 255 : b;
       
       photoCopy.pixels[i] = color(r ,g,b);
   }
   
   photoCopy.updatePixels();
   image(photoCopy, 100, 100, 700, 500);
    
  
  
}
void sharpenEdges () {
     photoCopy = img1.get();
     photoCopy.loadPixels();
          
     PImage edgeImg = createImage(photoCopy.width, photoCopy.height, RGB);
         
     for (int y = 1; y < photoCopy.height-1; y++) { 
            
         for (int x = 1; x < photoCopy.width-1; x++) { 
                
               float sum = 0; 
               for (int ky = -1; ky <= 1; ky++) {
                      
                     for (int kx = -1; kx <= 1; kx++) {
                              
                         int pos = (y + ky)*photoCopy.width + (x + kx);
                         float val = red(photoCopy.pixels[pos]);
                         sum += kernel[ky+1][kx+1] * val;
                       }
               }
              edgeImg.pixels[y*photoCopy.width + x] = color(sum, sum, sum);
          }
      }
      
      edgeImg.updatePixels();
      image(edgeImg,  100, 100, 700, 500); 
      
     }
     
     
void blurImage() {
  
          photoCopy = img1.get();
          photoCopy.loadPixels();
          PImage edgeImg = createImage(photoCopy.width, photoCopy.height, RGB);
      
          for (int y = 1; y < photoCopy.height-1; y++) {   
            
              for (int x = 1; x < photoCopy.width-1; x++) { 
                
                   float sum = 0;
                   for (int ky = -1; ky <= 1; ky++) {
                     
                        for (int kx = -1; kx <= 1; kx++) {
                           
                            int pos = (y + ky)*photoCopy.width + (x + kx);
                            float val = red(photoCopy.pixels[pos]);
                            sum += blurKernel[ky+1][kx+1] * val;
                         }
                    }
                edgeImg.pixels[y*photoCopy.width + x] = color(sum);
              }
        }

        edgeImg.updatePixels();
        image(edgeImg, 100, 100, 700, 500);
        photoCopy = edgeImg;
}



void mousePressed(){
  
  uiManager.handleMouseEvent("mousePressed",mouseX,mouseY);
  if (drawCircleFlag && circleButton.selected) {
    if (j < nPoints)
      {
  
    coloring();
    T[j] = new points(mouseX,mouseY,c1,c2);
    j += 1;
    }
    else
    {
      for (int i = 0; i < nPoints; i++)
      {
      
        T[i].pressed(mouseX,mouseY);
      }
    }
  }
}


void mouseReleased(){
  uiManager.handleMouseEvent("mouseReleased",mouseX,mouseY);
  
 
     if (drawCircleFlag && circleButton.selected) {
      for (int i = 0; i < j; i++)
        {
        //stop dragging
        T[i].stopdrag();
        }  
     }
     
     if (sharpEdge.selected) {
        sharpenEdges();
       
     }
  
}


void mouseClicked(){
  uiManager.handleMouseEvent("mouseClicked",mouseX,mouseY);
  
}

void mouseMoved(){
    uiManager.handleMouseEvent("mouseMoved",mouseX,mouseY);
}

void mouseDragged(){
   uiManager.handleMouseEvent("mouseDragged",mouseX,mouseY);
   //image(photoCopy, 100, 100, 300, 300);
   
}

void simpleUICallback(UIEventData eventData){
  eventData.printMe(false, false);
  
    if(eventData.uiComponentType == "RadioButton"){
        toolMode = eventData.uiLabel;
    }  
    
    switch(eventData.uiLabel) {
        case "loadImage":
              greyScale.selected = false;
              blackWhite.selected = false;
              circleButton.selected = false;
              selectImage ();
              break;  
              
        case "saveImage":
              if (greyScale.selected) {
                  photoCopy.save(path + "_greyScaleImage.jpg");
                  
              } else if (blackWhite.selected) {
                  photoCopy.save(path + "_blackWhiteImage.jpg");
                  
              } else if (adjustBrightness != 0 || adjustContrast != 1){
                  photoCopy.save(path + "_adjusted_Brightness/Contrast_Image.jpg");
                  
              } else if(sharpEdge.selected) {
                     photoCopy.save(path + "_sharpEdge.jpg");
                     
              } else if (blurEffect.selected) {
                   photoCopy.save(path + "_blurEffect.jpg"); 
              }
              break;
              
        case "resetImage":
             img1 = loadImage(path);
             image(photoCopy, 100, 100, 700, 500);
             
             greyScale.selected = false;
             blackWhite.selected = false;
             sharpEdge.selected = false;
             
             cp5.getController("Brightness Level").setValue(0);
             cp5.getController("Contrast Level").setValue(0);
             break;
    
       case "refreshBackground":
             imageLoaded = false;
             greyScale.selected = false;
             blackWhite.selected = false;
             lineButton.selected = false;
             circleButton.selected = false;
             sharpEdge.selected = false;
             rectButton.selected = false;
             blurEffect.selected = false;
             
             img1 = null;
             path = "";
             photoCopy = null;
             j = 0;
             
             drawCircleFlag = false;
             drawLineFlag = false;
             
             cp5.getController("Brightness Level").setValue(0);
             cp5.getController("Contrast Level").setValue(1);
             cp5.getController("Line Weight").setValue(1);
             
             document = new Document();
             background(255);
             break; 
             
       case "QUIT": 
             exit();

     }
     
     switch(toolMode) {
            case "rect":
                  drawLineFlag = false;
                  drawRect(eventData);
                  break;
                  
            case "circle":
                  drawLineFlag = false;
                  drawCircleFlag = true;
                  break;
            case "line": 
             
                  drawLineFlag = true;
                   break;
            case "select": 
                  trySelection(eventData);
                  break;
       
     }
 
}

void drawRect(UIEventData eventData){
  PVector p = new PVector(eventData.mousex, eventData.mousey);
  if(eventData.mouseEventType == "mousePressed" && mouseButton == RIGHT && rectButton.selected){
    document.startNewShape("rect", p);
  }
  
  if(eventData.mouseEventType == "mouseDragged"  && mouseButton == RIGHT && rectButton.selected){
    if( document.currentlyDrawnShape == null ) return;
    document.currentlyDrawnShape.duringMouseDrawing(p);
  }
  
  if(eventData.mouseEventType == "mouseReleased"  && mouseButton == RIGHT && rectButton.selected){
    if( document.currentlyDrawnShape == null ) return;
    document.currentlyDrawnShape.endMouseDrawing(p);
    document.currentlyDrawnShape  = null;
  }
  
}

void trySelection(UIEventData eventData){
  if(eventData.mouseEventType != "mousePressed") return;
  
  PVector p = new PVector(eventData.mousex,eventData.mousey);
  document.trySelect(p);
  
  
  
}