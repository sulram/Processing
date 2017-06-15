PVector pos = new PVector();
PVector vel = new PVector();

void setup() {
  
  size(512, 512);
  
}

void draw() {
  
  background(0);
  spring(pos, vel, new PVector(mouseX, mouseY), 0.9, 0.1);
  ellipse(pos.x, pos.y, 32, 32);
  
}


void spring (PVector pos, PVector vel, PVector center, float inertia, float k) {
  
  float x = center.x - pos.x;
  float y = center.y - pos.y;
  
  vel.x = vel.x * inertia + x * k ;
  vel.y = vel.y * inertia + y * k ;

  pos.x += vel.x ;
  pos.y += vel.y ;
  
}
