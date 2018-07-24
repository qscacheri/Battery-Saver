import controlP5.*;

import processing.serial.*;

ControlP5 cp5;
String s="";
boolean found=false;
PFont f;
ControlFont cf1;
int tan=#C09F80;
int aqua=#69D6CC;
int grain=#d7cec7;
int orange=#E68D5D;
int orangeL=#F09664;
int orangeB=#FAA06E;
int red=#76323f;

boolean start=false;
long lastStepTime=0;
int setTo;
int currentDiff=0;
int lastDiff=0;
String portName;
import java.io.InputStreamReader;
String response=null;
String commandToRun = "pmset -g batt";
String a="";
Serial myPort;
int currentPerc=0; 
int lastPerc=0;
int [] info=new int[2];

void setup() {
  
 // PImage icon = loadImage("BatteryLogo7.png");
 // surface.setIcon(icon);
  surface.setTitle("Battery Saver");
  cp5=new ControlP5(this);
  f = createFont("helvetica neue", 30, true);
  cf1 = new ControlFont(createFont("helvetica neue", 20, true));
  textFont(f, 40);
  size(600, 600);
  background(0);
  drawUI();
  //portName = Serial.list()[1]; //change the 0 to a 1 or 2 etc. to match your port
  portName="/dev/cu.HC-05-DevB";
  println(portName);

  try {
    myPort = new Serial(this, portName, 9600);
    print("found");
    found=true;
  }
  catch(Exception e) {
    found=false;
    print("lost");
    textAlign(CENTER, CENTER);
    textFont(f, 20);
    text("No device connected", 300, 550);
  }
}


void draw() {
  if (found==false) {
    try {
      myPort = new Serial(this, portName, 9600);
      print("found");
      found=true;
    }
    catch(Exception e) { 
      found=false;
      //print(e);
      textAlign(CENTER, CENTER);
      textFont(f, 20);
      //background(0);
    }
  }
  update();

  if (start) {
    currentDiff=setTo-currentPerc; 
    if (currentDiff<=0){
      myPort.write((int)0);
      println("turned off");
    }
  }

  //cf1.draw(cp5,cp5.getController("Start").getCaptionLabel());
}




void getPerc(String s) {
  String p="";
  int counter;
  p="";

  for (int i=0; i<s.length(); i++) {
    if (s.charAt(i)=='%') {
      counter=i;

      while (s.charAt(counter)!='\t') {
        counter--;
        p+=s.charAt(counter);
      }
    }
  }

  p=flipString(p);

  p=p.replaceAll("\t", "");
  p=p.trim();
  p.replaceAll("\n", "");
  currentPerc= Integer.valueOf(p);
}


String flipString(String s) {
  String flipped="";
  for (int i=s.length()-1; i>=0; i--) {
    flipped+=s.charAt(i);
  }
  return flipped;
}

void getBatt() {
  a="";
  try {
    Process proc = (Runtime.getRuntime()).exec(commandToRun);

    BufferedReader stdInput = new BufferedReader(new InputStreamReader(proc.getInputStream()));


    while ((response = stdInput.readLine()) != null) {
      //System.out.println(response);
      a+=response;
    }
  }
  catch(Exception e) {
    println(e);
  }
}

void update() {
  getBatt();
  getPerc(a);
}


void drawUI() {
  cp5.addKnob("knob")
    .setPosition(225, 240)
    .updateDisplayMode(CENTER)
    .setMax(100)
    .setNumberOfTickMarks(100)
    .hideTickMarks()
    .snapToTickMarks(true)
    .setSize(150, 150)
    .setColorBackground(aqua)
    .setColorValue(aqua)
    .setColorForeground(0)
    .setColorActive(0)
    .setStartAngle(TWO_PI*.375)
    .setColorLabel(0);
  ;

  Button b=cp5.addButton("Start")
    .setPosition(250, 420)
    .setSize(100, 50)
    .setColorBackground(orange)
    .setColorForeground(orangeL)
    .setColorActive(orangeB);

  b.setFont(cf1);
  Label label = b.getCaptionLabel(); 
  label.setFont(cf1);
  label.toUpperCase(false);



  //cp5.addButton("search")
  //  .setPosition(265, 500)
  //  .setSize(70, 20)
  //  .setColorBackground(orange)
  //  .setColorForeground(orangeL)
  //  .setColorActive(orangeB);
  //;
}

void drawText() {
  textAlign(CENTER, CENTER);
  stroke(#ffffff);
  text("Shut off at "+(int)cp5.getController("knob").getValue()+"%", 300, 200);
  if (found==false) {
    text("No device connected", 300, 550);
  }
}



void knob(int theValue) {
  background(0);
  drawText();
  setTo=(int)cp5.getController("knob").getValue();
}

void Start(int theValue) {
  if (found==true) {
    start=!start;
    if (start)
      cp5.getController("Start").setLabel("Reset");

    else if (start==false) {
      cp5.getController("Start").setLabel("Start");
      myPort.write((int)1);
      println("sent");
      println("reset");
    }
  }
}