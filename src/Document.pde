class DrawnShape{

  String shapeType;
  
  // fill and line style
  public int lineThickness = 1; // set to 0 for no line
  public color lineColor = color(0,0,0);
  public boolean filled = true;
  public color fillColor = color(127,127,127);
  
  // used during interactive drawing
  PVector mouseStart, mouseDrag, mouseEnd;
  
  // used once the shape has been drawn
  UIRect bounds;
  
  boolean isSelected = false;
  boolean isBeingDrawn = false;
  public DrawnShape(){}
  
  
  public void startMouseDrawing(String shapeType, PVector startPoint){
    this.isBeingDrawn = true;
    this.shapeType  = shapeType;
    this.mouseStart = startPoint;
    this.mouseDrag = startPoint;
  }
  
  public void duringMouseDrawing(PVector dragPoint){
    this.mouseDrag = dragPoint;
    
  }
  
  
  public void endMouseDrawing(PVector endPoint){
    this.mouseEnd = endPoint;
    setShapeData(this.mouseStart, this.mouseEnd);
    this.isBeingDrawn = false;
  }
  
  
  void setShapeData(PVector p1, PVector p2){
    bounds = new UIRect(p1,p2);
    
  }
  
  
  public boolean trySelect(PVector p){
    if( bounds.isPointInside(p)){
      this.isSelected = !this.isSelected;
      return true;
    }
    return false;
    
  }
  
  
  
  public void drawMe(){
    
    
    setDrawingStyle();
  
  
    if(isBeingDrawn){
      float x1 = this.mouseStart.x;
      float y1 = this.mouseStart.y;
      float wid = this.mouseDrag.x - x1;
      float hgt = this.mouseDrag.y - y1;
      switch(shapeType) {
        case "ellipse":
                
                break;
        case "rect":
              rect(x1,y1,wid,hgt);
              break;
      }
      
     // rect(x1,y1,wid,hgt);
      
    }else{
      float x1 = this.bounds.left;
      float y1 = this.bounds.top;
      float wid = this.bounds.getWidth();
      float hgt = this.bounds.getHeight();
        switch(shapeType) {
        case "ellipse":
             
              break;
        case "rect":
              rect(x1,y1,wid,hgt);
              break;
      }
      
      //rect(x1,y1,wid,hgt);
      ;
      if(this.isSelected){
        noFill();
        strokeWeight(1);
        stroke(255,50,50);
        switch(shapeType) {
       // case "l":
             // ellipse(x1, y1, wid+2, hgt+2);
            //  drawLine();
             // break;
        case "rect":
              rect(x1,y1,wid+2,hgt+2);
              break;
      }
      
       // rect(x1-1,y1-1,wid+2,hgt+2);
       
      
      }
    
    }
    
    setDefaultDrawingStyle();
   
  }
  
  
  void setDrawingStyle(){
    
    if(lineThickness ==  0){
      noStroke();
      } 
      else {
      strokeWeight(lineThickness);
      }
      
    stroke(lineColor);
    if(filled){
    fill(fillColor);
    } else {
      noFill();
    }
    
    
 
  }
  
  void setDefaultDrawingStyle(){
    strokeWeight(1);
    stroke(0,0,0);
    fill(255,255,255);
  }
  
  
}    

class Document{
  
  ArrayList<DrawnShape> shapeList = new ArrayList<DrawnShape>();
  
  // this references the currently drawn shape. It is set to null
  // if no shape is currently being drawn
  public DrawnShape currentlyDrawnShape = null;
  
  public Document(){
    
  }
  
  public void startNewShape(String shapeType, PVector mouseStartLoc){
    DrawnShape newShape = new DrawnShape();
    
    newShape.startMouseDrawing(shapeType, mouseStartLoc);
    shapeList.add(newShape);
    currentlyDrawnShape = newShape;
  }
  
  
  public void drawMe(){
    for(DrawnShape s : shapeList){
        s.drawMe();
    
        }
  }
  

  public void trySelect(PVector p){
    boolean selectionFound = false;
    for(DrawnShape s : shapeList){
        selectionFound = s.trySelect(p);
        if(selectionFound)
           
         
        break;
    
      }
  }
  
}