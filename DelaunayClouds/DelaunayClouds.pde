import megamu.mesh.*;

int PCOUNT = 50;
float PVELO = 2.0;

Particle particulas[] = new Particle[PCOUNT];

float[][] points = new float[PCOUNT][2];
      
void setup(){
  
  size(1280,720);
  
  background(0);
  
  // criando particulas e primeiros pontos
  
  for (int i=0; i<PCOUNT; i++){
    particulas[i] = new Particle(width,height);
    points[i][0] = particulas[i].x;
    points[i][1] = particulas[i].y;
  }
}

void draw(){
  smooth();
  noStroke();
  
  if(random(100) > 70){
    fill(0,0,0,10);
    rect(0,0,width,height);
  }
  
  stroke(255,10);
  
  for (int i=0; i<PCOUNT; i++){
    particulas[i].update();
    if(mousePressed){
      particulas[i].draw();
    }
    points[i][0] = particulas[i].x;
    points[i][1] = particulas[i].y;
  }
  
  Delaunay myDelaunay = new Delaunay( points );
  
  float[][] myEdges = myDelaunay.getEdges();
  
  for(int i=0; i<myEdges.length; i++)
  {
    float startX = myEdges[i][0];
    float startY = myEdges[i][1];
    float endX = myEdges[i][2];
    float endY = myEdges[i][3];
    if(mousePressed){
      line( startX, startY, endX, endY );
    }else{
      drawWavyLine( new PVector(startX, startY), new PVector(endX, endY));
    }
  }
  //saveFrame();
  
  for (int i=0; i<PCOUNT; i++){
    if(mousePressed){
      fill(255);
      particulas[i].draw();
    }
  }
}

void drawWavyLine(PVector a, PVector b) {
  
  PVector diff = PVector.sub(b,a);
  float len = diff.mag();
 
  // now calculate the normal, normalized
  PVector n = PVector.div(diff,len);
 
  // turn (x, y) into (y, -x) - this flips the vector 90 degrees
  float ny = n.y;
  n.y = -n.x;
  n.x = ny;
  
  noFill();
  beginShape();
  for(float f = 0; f < PI*2; f+=PI/5.0) {
    float d = f/TWO_PI;
    float window = 1-4*(d-0.5)*(d-0.5);
    PVector sine = PVector.mult(n,sin(f)*map(len, 0, 200, 0, 8)*window);
    PVector p = PVector.add(PVector.add(sine, a), PVector.mult(diff, d));
    vertex(p.x, p.y);
  }
  vertex(b.x, b.y);
  endShape();
}

class Particle {

  int w, h;
  float velx, vely, x, y;

  Particle(int w, int h) {
    this.w = w;
    this.h = h;
    x = random(w);
    y = random(h);
    velx = random(-PVELO, PVELO);
    vely = random(-PVELO, PVELO);
  }

  void update() {
    
    x += velx;
    y += vely;
    
    if (x<0) {
      x = 0;
      velx *= -1;
    }

    if (y<0) {
      y = 0;
      vely *= -1;
    }

    if (x>w) {
      x = w;
      velx *= -1;
    }

    if (y>h) {
      y = h;
      vely *= -1;
    }
  }
  
  void draw() {
    ellipse(x, y, 10, 10);
  }
  
}

