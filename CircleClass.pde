int nPoints = 3; 
int j = 0; 
int k = 0; 
color c1, c2;  
float teta = 0;  
PVector[] mp = new PVector[2];  
PVector O;
float R; 
points[] T;
//PFont font; 
boolean displayText = true; 
float Det;


void keyPressed()
{
  if (key == 'c' || key == 'C') 
  {
    j = 0;
  }
  
  if (key == 'd' || key == 'D')
  {
    displayText = !displayText;
  }
}
void displayCenter()
{
  PVector rPosition;
  
  fill(255, 160, 0);
  stroke(255, 160, 0); 
  ellipse(O.x, O.y, 5, 5); 
  arrow(O,T[2].p); 
  
  fill(200,100,0);

  
  rPosition = midpoint(O,T[2].p); 
  
}


void center(PVector[] P)
{
  float ox, oy, a;
  PVector[] eq = new PVector[2];
  
  for (int i = 0; i < 2; i++)
  { 
    a = tan(P[i].z); 
    eq[i] = new PVector (a, -1, -1*(P[i].y - P[i].x*a));       
  }
  
  //calculate x and y coordinates of the center of the circle
  ox = (eq[1].y * eq[0].z - eq[0].y * eq[1].z) / (eq[0].x * eq[1].y - eq[1].x * eq[0].y);
  oy =  (eq[0].x * eq[1].z - eq[1].x * eq[0].z) / (eq[0].x * eq[1].y - eq[1].x * eq[0].y);
  O = new PVector(ox,oy); 
}



void displayCircle()
{
  fill(153);
  stroke(200);
  
  for (k = 0; k < 2; k++)
  {
    mp[k] = midpoint(T[k].p,T[k+1].p); 
  }
  center(mp);   
  R = sqrt(sq(O.x-T[2].p.x)+sq(O.y - T[2].p.y)); 

  ellipse(O.x, O.y, 2*R, 2*R); 
}


PVector midpoint(PVector A, PVector B)
{
  PVector C;
  float r, teta;
  PVector p;
   
  PVector distance = tetaTest(A, B); 
  r = distance.x; 
  teta = distance.y; 
  
  r /= 2; 
  C = new PVector(A.x + r*cos(teta), A.y + r*sin(teta)); 
  teta -= HALF_PI; 
  
  
  p = new PVector(C.x, C.y, teta);  
  return p;
}


PVector tetaTest(PVector A, PVector B)
{
  float cteta, steta;
  float teta = 0;
  float r;
  PVector v;
  
  r = sqrt(sq(B.y-A.y)+sq(B.x-A.x));  
  
  cteta = (B.x - A.x)/r;
  steta = (B.y - A.y)/r;
  
  if (cteta >= 0 && steta >= 0) {teta = acos(abs(cteta));} 
  if (cteta < 0 && steta > 0) {teta = PI - acos(abs(cteta));} 
  if (cteta <= 0 && steta <= 0) {teta = acos(abs(cteta)) + PI;} 
  if (cteta > 0 && steta < 0) {teta = acos(abs(cteta)) * (-1);} 
  
  v = new PVector(r,teta);
  return v;
}

void arrow(PVector a, PVector b)
{
  line(a.x, a.y, b.x, b.y);
  PVector angle = tetaTest(a,b);
  line (int(b.x), int(b.y), int(b.x + 10*cos(angle.y + radians(150))), int(b.y + 10*sin(angle.y + radians(150))));
  line (int(b.x), int(b.y), int(b.x + 10*cos(angle.y + radians(210))), int(b.y + 10*sin(angle.y + radians(210))));  
}


void coloring()
{
  if (j == 0) //first dot is red
  {
    c1 = color(230,0,0);
    c2 = color(230,128,128);
  }
  else if (j == 1) 
  {
    c1 = color(0,200,0);
    c2 = color(128,200,128);
  }
  else 
  {
    c1 = color(0,30,230);
    c2 = color(128,158,230);
  } 
}
class points
{
  int diam; 
  PVector p; 
  float dx, dy; 
  boolean dragging, roll;
  color c1, c2; //colors of the dot
  
  points(float x_, float y_, color c1_, color c2_)
  {
    dragging = false;
    roll = false;
    diam = 10;
    p = new PVector(x_, y_);
    c1 = c1_;
    c2 = c2_;
    dx = 0;
    dy = 0;
  }
  
  void display()
  {
    strokeWeight(2);
    stroke(c1);
    if (dragging) {  fill(c1);  }  
    else if (roll) {  fill(c2);  }     
    else {  noFill();  }     
    ellipse(p.x, p.y, diam, diam);
    point(p.x,p.y);
  }
  void rollover(float mx,float my) 
  {
    if (dist(p.x, p.y, mx, my) < diam/2) {  roll = true;  }
    else {  roll = false;  }
  }
  
  void pressed(float mx, float my) 
  {
    if (dist(p.x, p.y, mx, my) < diam/2)
    {
      dragging = true;
      //track the displacement
      dx = p.x - mx;
      dy = p.y - my;
    }
  }
  
  void drag(float mx, float my) 
  {
    if (dragging)
    {
      p.x = mx + dx;
      p.y = my + dy;
    }
  }
  
  void stopdrag()
  {
    dragging = false;
  }
  
}