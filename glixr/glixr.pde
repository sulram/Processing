import java.util.Date;
import javax.swing.*;
import javax.swing.filechooser.*;

import sojamo.drop.*;

SDrop drop;
PImage img;
PFont font;

boolean show_help = true;

int mode = 0;
String modes[] = {
  "random", 
  "position x y"
};

String img_file = "";
String img_file_glitch = "";

void setup() {
  size(500, 500, P2D);
  frame.setResizable(true);
  drop = new SDrop(this);
  font = loadFont("Monospaced-12.vlw");
  textFont(font, 12);
  background(0);
}

void draw() {

  background(0);

  // DRAW IMAGE
  if (img != null) {
    image(img, 0, 0);
  }

  // DRAW HELP

  if (show_help) {
    text("mode " + (mode + 1) + ": " + modes[mode], 20, 30);
    text("press enter or drop image to load", 20, 60);
    text("press 1–2 ...... change mode", 20, 80);
    text("mouse left ..... glitch", 20, 100);
    text("mouse right .... reset", 20, 120);
    text("press s ........ save glitch to output dir", 20, 140);
    text("press h ........ show hide help", 20, 160);
  }
}

void keyPressed() {
  switch(keyCode) {
  case 10: // ENTER
    fileChoose();
    break;
  case 49: // 1
    mode = 0;
    break;
  case 50: // 2
    mode = 1;
    break;
  case 72: // h
    show_help = !show_help;
    break;
  case 83: // s
    Date d = new Date();
    byte[] data = loadBytes(img_file_glitch);
    saveBytes(filename_append(img_file_glitch, "_" + String.valueOf(d.getTime())), data);
    break;
  }
  println(keyCode);
}

void mousePressed() {

  if (img_file.equals("")) return;

  // MOUSE LEFT BUTTON: GLITCH
  if (mouseButton == LEFT) {
    byte[] data = loadBytes(img_file_glitch);   
    switch(mode) {
    case 0:
      // RANDOM
      // 4 = 100 changes
      // 128 = file header
      for (int i = 0; i < 4; i++) {
        int loc = (int)random(128, data.length);
        data[loc] = (byte)random(255);
      }
      break;
    case 1:
      // MOUSE POSITION
      // map mouseX and mouseY to 128 (file header) and number of bytes
      int loc = (int)map(mouseX*mouseY, 0, width * height, 128, data.length);
      data[loc] = (byte)random(255);
      break;
    }
    saveBytes(img_file_glitch, data);
    img = loadImage(img_file_glitch);
  }
  // MOUSE RIGHT BUTTON: RESET
  else if (mouseButton == RIGHT) { 
    byte[] data = loadBytes(img_file);
    saveBytes(img_file_glitch, data);
    img = loadImage(img_file_glitch);
  }
}

String filename_append(String file, String a) {
  String[] file_name = split(file, '.');
  file_name[file_name.length-2] += a;
  return join(file_name, ".");
}

void image_init(String path, String file) {
  
  if(!file.toLowerCase().endsWith(".jpg")) {
    println("File is not JPG.");
    return;
  }
  
  img_file = path + "/" + file;
  img_file_glitch = "glixr_output/" + filename_append(file, "_glitch");

  byte[] data = loadBytes(img_file);
  saveBytes(img_file_glitch, data);
  img = loadImage(img_file);

  frame.setSize(img.width, img.height);
}

void dropEvent(DropEvent event) {
  if (event.isImage()) {
    image_init(event.file().getParent(), event.file().getName());
  }
}

void fileChoose() {
  try { 
    UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
  } 
  catch (Exception e) { 
    e.printStackTrace();
  }
  final JFileChooser fc = new JFileChooser();
  FileFilter filter = new FileNameExtensionFilter("JPG images", "jpg");
  fc.setFileSelectionMode(JFileChooser.FILES_ONLY);
  fc.addChoosableFileFilter(filter);
  fc.setAcceptAllFileFilterUsed(false);
  fc.setDialogTitle("Select image");
  if (fc.showOpenDialog(null) == JFileChooser.APPROVE_OPTION) {
    File file = fc.getSelectedFile();
    image_init(file.getParent(), file.getName());
  } 
  else { 
    println("Open command cancelled by user.");
  }
}

