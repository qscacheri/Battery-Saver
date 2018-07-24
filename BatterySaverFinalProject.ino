 #define ledPin 11
int ledPin2 = 10;
int state = 0;
int counter = 0;
int val;
void setup() {
  pinMode(ledPin, OUTPUT);
  pinMode(13, OUTPUT);
  pinMode(ledPin2, OUTPUT);
  digitalWrite(ledPin, LOW);
  Serial1.begin(9600  );
  Serial.begin(9600); // Default communication rate of the Bluetooth module
}

void loop() {
  digitalWrite(ledPin2, HIGH);
  if (Serial1.available() > 0) {
    digitalWrite(ledPin, HIGH);
    val = Serial1.read();
    Serial1.println(val);
    
    
    if (val == 0)
      digitalWrite(13, HIGH);
    else if (val == 1)
      digitalWrite(13, LOW);


    }
}
