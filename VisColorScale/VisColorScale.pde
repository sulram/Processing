
ColorScale scale = new ColorScale();

void setup(){

  size(800,600);

  scale.addColor(color(168, 33, 108), 100);
  scale.addColor(color(237, 27, 77), 50);
  scale.addColor(color(243, 108, 68), 50);
  scale.addColor(color(248, 220, 105), 50);
  scale.addColor(color(46, 150, 152), 100);

}

void draw(){

  background(0);
  noStroke();

  int shades = 20;
  float w = (width * 1.0 / shades);

  for(int i = 0; i < shades; i++){
    float x = i * w;
    fill(scale.getColorAt(i * 1.0 / shades));
    rect(x, 0, w, height);
  }

  if(mousePressed){
    scale.drawRect(0, height / 2 - 50, width, 100);
  }

}
