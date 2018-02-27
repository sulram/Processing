import fullscreen.*; 

FullScreen fs; 

double frequency = 0.025;
int res = 10;
float inertia = .05;

float x = 0;
float y = 0;

void setup() {
  size(800, 600);
  smooth();
  fs = new FullScreen(this);
  //fs.setResolution(1280, 800);
}

void keyPressed() {
  println(keyCode);
  if (keyCode == 70) { //f
    if (fs.isFullScreen()) {
      fs.leave();
    }
    else {
      fs.enter();
    }
  }
}

void draw() {

  noStroke();

  x += inertia*(mouseX-x);
  y += inertia*(mouseY-y);

  res = int(y)+1;

  for (int i = 0; i < res; ++i)
  {

    int col = (int(x)+i) ;//% res;

    float  r = (float)( Math.sin(frequency * col + 0) * 127 + 128 );
    float  g = (float)( Math.sin(frequency * col + 2) * 127 + 128 );
    float  b = (float)( Math.sin(frequency * col + 4) * 127 + 128 );

    fill(r, g, b);
    float colX = 1.0 * width / res * i;
    float colW = 1.0 * width / res;
    rect(colX, 0, colW, height);
  }

  int mousePix = width*int(y) + int(x)%width;

  if (mousePressed && mousePix > 0 && mousePix < width*height) {
    noCursor();
    loadPixels();
    color pixel = pixels[ mousePix ];
    updatePixels();
    fill(pixel);
    stroke(255);
    strokeWeight(10);
    ellipse(x, y, 100, 100);
  }
  else {
    cursor();
  }
}

