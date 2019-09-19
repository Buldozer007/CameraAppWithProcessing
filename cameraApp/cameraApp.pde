import processing.video.*;
import controlP5.*;

PImage[] starAndCircles = new PImage[10];
PImage[] squares = new PImage[10];
PImage[] circles = new PImage[10];
PImage[] curves = new PImage[10];


float gridSize = 20;
float margin = 20;

int mode; //For shape mode
int colorLayer; //number of the chosen layer
ColorPicker layer1; //
ColorPicker layer2; //Color pickers
ColorPicker layer3; //

Capture myImage;
ControlP5 cp5;

void setup() {
  size(1280, 720);

  myImage = new Capture(this, Capture.list()[0]);
  myImage.start();

  cp5 = new ControlP5(this);

  cp5.addSlider("gridSize").setPosition(20, 20).setRange(10, 100);                                                                                                               //
  cp5.addSlider("margin").setPosition(20, 40).setRange(5, 25);                                                                                                                   //
                                                            
  layer1 = cp5.addColorPicker("Layer1").setPosition(1000, 40).setColorValue(color(255, 0, 0, 255)).setVisible(false);                                                            //
  layer2 = cp5.addColorPicker("Layer2").setPosition(1000, 120).setColorValue(color(0, 255, 0, 255)).setVisible(false);                                                           //UI components
  layer3 = cp5.addColorPicker("Layer3").setPosition(1000, 200).setColorValue(color(0, 0, 255, 255)).setVisible(false);                                                           //
  
  cp5.addDropdownList("mode").setPosition(20, 80).addItem("Descending", 0).addItem("Ascending", 1).addItem("Curves", 2);                                                         //
  cp5.addDropdownList("colorLayer").setLabel("Color Picker").setPosition(1000, 20).addItem("None", 0).addItem("Layer1", 1).addItem("Layer2", 2).addItem("Layer3", 3);            //




    

  strokeCap(SQUARE);

  for (int i = 0; i<=9; i++) {
    starAndCircles[i] = loadImage("PNG_series/" + i + ".png");    //
    squares[i] = loadImage("PNG_series/" + (i+10) + ".png");      //Image
    circles[i] = loadImage("PNG_series/" + (i+20) + ".png");      //importing
    curves[i] = loadImage("PNG_series/" + (i+30) + ".png");       //
  }
}

void draw() {
  switch(colorLayer) {
    case 1:
    
    layer1.setVisible(true);
    layer2.setVisible(false);
    layer3.setVisible(false);
    break;
    
    case 2:
    
    layer1.setVisible(false);
    layer2.setVisible(true);                  
    layer3.setVisible(false);
    break;
    
    case 3:
    
    layer1.setVisible(false);
    layer2.setVisible(false);
    layer3.setVisible(true);
    break;
    
    default:
    
    layer1.setVisible(false);
    layer2.setVisible(false);
    layer3.setVisible(false);
    break;
  }
  
  
  blendMode(ADD);
  if (myImage.available()) {
    myImage.read();
  }

  background(0);

  myImage.loadPixels();

  if (myImage != null && myImage.pixels.length > 0) {
    for (int x = round(margin); x < width - margin; x += gridSize) {
      for (int y = round(margin); y < height - margin; y += gridSize) {
        color c = myImage.pixels[x + y * width];

        float redChannel = red(c);
        int unitIndexRedChannel = round(map(redChannel, 0, 255, 0, starAndCircles.length - 1));

        float greenChannel = green(c);
        int unitIndexGreenChannel = round(map(greenChannel, 0, 255, 0, squares.length - 1 ));

        float blueChannel = blue(c);
        int unitIndexBlueChannel = round(map(blueChannel, 0, 255, 0, circles.length - 1));

        switch(mode) 
        {
          case(0):
          tint(layer1.getArrayValue(0), layer1.getArrayValue(1), layer1.getArrayValue(2));
          image(starAndCircles[unitIndexRedChannel + (9-2*unitIndexRedChannel)], x, y, gridSize, gridSize);

          tint(layer2.getArrayValue(0), layer2.getArrayValue(1), layer2.getArrayValue(2));
          image(squares[unitIndexGreenChannel + (9-2*unitIndexGreenChannel)], x, y, gridSize, gridSize);

          tint(layer3.getArrayValue(0), layer3.getArrayValue(1), layer3.getArrayValue(2));
          image(circles[unitIndexBlueChannel + (9-2*unitIndexBlueChannel)], x, y, gridSize, gridSize);
          break;



          case(1):

          tint(layer1.getArrayValue(0), layer1.getArrayValue(1), layer1.getArrayValue(2));
          image(starAndCircles[unitIndexRedChannel], x, y, gridSize, gridSize);

          tint(layer2.getArrayValue(0), layer2.getArrayValue(1), layer2.getArrayValue(2));
          image(squares[unitIndexGreenChannel], x, y, gridSize, gridSize);

          tint(layer3.getArrayValue(0), layer3.getArrayValue(1), layer3.getArrayValue(2));
          image(circles[unitIndexBlueChannel], x, y, gridSize, gridSize);
          break;



          case(2):

          unitIndexRedChannel = round(map(redChannel, 0, 255, 0, curves.length - 1));
          unitIndexGreenChannel = round(map(greenChannel, 0, 255, 0, curves.length - 1 ));
          unitIndexBlueChannel = round(map(blueChannel, 0, 255, 0, curves.length - 1));

          pushMatrix();
          translate(x + gridSize/2, y + gridSize/2);

          pushMatrix();
          tint(layer1.getArrayValue(0), layer1.getArrayValue(1), layer1.getArrayValue(2));
          image(curves[unitIndexRedChannel + (9-2*unitIndexRedChannel)], -gridSize/2, -gridSize/2, gridSize, gridSize);
          popMatrix();

          pushMatrix();
          tint(layer2.getArrayValue(0), layer2.getArrayValue(1), layer2.getArrayValue(2));
          rotate(PI/2);
          image(curves[unitIndexGreenChannel + (9-2*unitIndexGreenChannel)], -gridSize/2, -gridSize/2, gridSize, gridSize);
          popMatrix();

          pushMatrix();
          tint(layer3.getArrayValue(0), layer3.getArrayValue(1), layer3.getArrayValue(2));
          rotate(PI);
          image(curves[unitIndexBlueChannel + (9-2*unitIndexBlueChannel)], -gridSize/2, -gridSize/2, gridSize, gridSize);
          popMatrix();
          popMatrix();
          break;
        }
      }
    }
    blendMode(NORMAL);
  }
}
