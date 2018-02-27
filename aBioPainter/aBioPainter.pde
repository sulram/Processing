/**
 * BioPainter 1.0
 * 
 * Software for drawing masks for PD
 */
 
// TODO: flood fill
// http://processing.org/discourse/beta/num_1198964275.html

import processing.opengl.*;
import javax.swing.*;

String save_dir = "";

int export_width = 320;
int export_height = 240;

int brush_color = 255;
int brush_size = 30;

boolean draw_canvas = true;

PGraphics canvas;
PFont fontA;

int[] shape_x = new int[100];
int[] shape_y = new int[100];
int shape_vertex = 0;

int last_mouseX = 0;
int last_mouseY = 0;

void setup() {

  size(800, 600, P2D);
  //size(displayWidth, displayHeight, P2D);
  canvas = createGraphics(displayWidth, displayHeight, P2D);
  
  fontA = loadFont("mono10.vlw");
  textFont(fontA, 10);
  
  canvasClear();
  background(0);
  smooth();
  
  fileChoose();
}

void draw() {
  
  // clear screen
  background(0);
  
  // MODE: mouse paint / erase
  
  if (mousePressed) {
    if (mouseButton == LEFT) {
      brush_color = 255;
    }
    else {
      brush_color = 0;
    }
    
    // canvas drawing
    
    canvas.beginDraw();
    canvas.strokeWeight(brush_size);
    canvas.stroke(brush_color);
    // line between current and last mouse position: it looks better
    canvas.line(last_mouseX, last_mouseY, mouseX, mouseY);
    canvas.noStroke();
    canvas.fill(brush_color);
    // ellipse on new position
    canvas.ellipse(mouseX, mouseY, brush_size, brush_size);
    canvas.endDraw();
  }
  
  // save mouse position
  last_mouseX = mouseX;
  last_mouseY = mouseY;
  
  // draw canvas to screen
  if(draw_canvas){
    image(canvas, 0, 0);
  }  else {
    background(255);
  }
  
  // draw cursor
  
  stroke(0);
  strokeWeight(2);
  fill(255);
  ellipse(mouseX, mouseY, brush_size, brush_size);
  // draw middle if brush_size is greater than 10
  if(brush_size > 10){
    ellipse(mouseX, mouseY, 2, 2);
  }
  
  // MODE: vertex painting

  noFill();
  stroke(0, 255, 0);
  strokeWeight(4);
  strokeCap(ROUND);
  strokeJoin(ROUND);
  
  // are there two vertex saved?
  if (shape_vertex > 1) {
    beginShape();
    for (int i = 0; i < shape_vertex; i++) {
      vertex(shape_x[i], shape_y[i]);
    }
    endShape();
  }
  
  // is there at least one vertex saved:
  if (shape_vertex > 0) {
    // draw line to mouse
    stroke(0);
    strokeWeight(8);
    line(shape_x[shape_vertex-1], shape_y[shape_vertex-1], mouseX, mouseY);
    stroke(0, 255, 0);
    strokeWeight(4);
    line(shape_x[shape_vertex-1], shape_y[shape_vertex-1], mouseX, mouseY);
    // draw line to first vertex for a closed shape visualization
    strokeWeight(2);
    line(shape_x[shape_vertex-1], shape_y[shape_vertex-1], shape_x[0], shape_y[0]);
  }
  
  // list commands
  
  fill(150);
  text("BIOPAINTER 1.0", 20, 20);
  text(". . . . . . . . . . . . . .", 20, 40);
  text("enter     select save dir", 20, 60);
  text("click     paint", 20, 80);
  text("r click   erase", 20, 100);
  text("+         increase brush", 20, 120);
  text("-         decrease brush", 20, 140);
  text("L         begin/add vertex", 20, 160);
  text("K         close vertex", 20, 180);
  text("space     show projectable area", 20, 200);
  text("bkspace   clear canvas", 20, 220);
  text("0-9       save mask#.png", 20, 240);
}

void keyReleased() {

  println(keyCode);
  noCursor();

  if (keyCode >= 48 && keyCode <= 57) { // keys 0-9
    // create two extra canvas
    // first will generate a smaller version
    // second will copy only black pixels to make a mask (white will be transparent)
    PGraphics canvas_small = createGraphics(export_width, export_height, P2D);
    PGraphics canvas_small_alpha = createGraphics(export_width, export_height, P2D);
    
    // smaller copy of canvas
    canvas_small.beginDraw();
    canvas_small.image(canvas, 0, 0, export_width, export_height);
    canvas_small.endDraw();
    
    // load pixels and copy only black pixels
    canvas_small.loadPixels();
    canvas_small_alpha.loadPixels();
    for (int i = 0; i < export_width*export_height; i++) {
      if (canvas_small.pixels[i] == color(0)) {
        canvas_small_alpha.pixels[i] = canvas_small.pixels[i];
      }
    }
    // save mask after update pixels
    canvas_small_alpha.updatePixels();
    canvas_small_alpha.save(save_dir + "mask" + key + ".png");
  }

  if (keyCode == 8) { // backspace
    canvasClear();
  }

  if (keyCode == 10) { // enter
    fileChoose();
  }

  if ( keyCode == 76 ) { // l
    // add vertex and increment shape_vertex count
    shape_x[shape_vertex] = mouseX;
    shape_y[shape_vertex] = mouseY;
    shape_vertex++;
  }
  if ( keyCode == 75 ) { // k
    
    // close canvas and reset shape_vertex count 
    canvas.beginDraw();
    canvas.fill(255);
    canvas.noStroke();
    canvas.beginShape();
    for (int i = 0; i < shape_vertex; i++) {
      canvas.vertex(shape_x[i], shape_y[i]);
    }
    canvas.endShape(CLOSE);
    canvas.endDraw();
    shape_vertex = 0;
  }
  if ( keyCode == 32 ) { // space
    draw_canvas = true;
  }
}

// press and hold commands

void keyPressed() {
  if ( keyCode == 61 ) { // +
    brush_size += 4;
  }
  if ( keyCode == 45 ) { // _
    brush_size -= 4;
  }
  if ( keyCode == 32 ) { // space
    draw_canvas = false;
  }
  
}

// clear the canvas

void canvasClear() {
  canvas.beginDraw();
  canvas.noStroke();
  canvas.background(0);
  canvas.endDraw();
}

// select directory to save images

void fileChoose() {
  try { 
    UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
  } 
  catch (Exception e) { 
    e.printStackTrace();
  }

  final JFileChooser fc = new JFileChooser(); 
  fc.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
  fc.setDialogTitle("Select the folder where masks will be saved");
  
  // in response to a button click: 
  int returnVal = fc.showOpenDialog(this); 

  if (returnVal == JFileChooser.APPROVE_OPTION) { 
    File file = fc.getSelectedFile(); 
    save_dir = file.getPath() + "/";
  } 
  else { 
    println("Open command cancelled by user.");
  }
}

