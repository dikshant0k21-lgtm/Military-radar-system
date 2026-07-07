#include <Servo.h>

// =========================
// Pin Definitions
// =========================
const int SERVO_PIN = 6;
const int TRIG_PIN = 9;
const int ECHO_PIN = 10;
const int BUZZER_PIN = 8;

// =========================
// Servo Object
// =========================
Servo radarServo;

// =========================
// Buzzer Variables
// =========================
unsigned long previousBeepTime = 0;
bool buzzerState = false;

// =========================
// Filtered Distance Variables
// =========================
float previousReading = 240;
int confirmCounter = 0;
float confirmedDistance = 240;

// =========================
// Distance Measurement
// =========================
float getDistance()
{
  digitalWrite(TRIG_PIN, LOW);
  delayMicroseconds(2);

  digitalWrite(TRIG_PIN, HIGH);
  delayMicroseconds(10);

  digitalWrite(TRIG_PIN, LOW);

  long duration = pulseIn(ECHO_PIN, HIGH, 30000);

  if (duration == 0)
    return 240;

  float distance = duration * 0.0343 / 2.0;

  if (distance > 240)
    distance = 240;

  return distance;
}

// =========================
// Filtered Distance
// =========================
float getFilteredDistance()
{
  float raw = getDistance();

  if (abs(raw - previousReading) < 8)
  {
    confirmCounter++;
  }
  else
  {
    confirmCounter = 0;
  }

  previousReading = raw;

  if (confirmCounter >= 2)
  {
    confirmedDistance = raw;
  }

  return confirmedDistance;
}

// =========================
// Smart Buzzer
// =========================
void updateBuzzer(float distance)
{
  unsigned long currentMillis = millis();

  // -------------------------
  // Out of range - silent
  // -------------------------
  if (distance > 80)
  {
    digitalWrite(BUZZER_PIN, LOW);
    buzzerState = false;
    return;
  }

  // -------------------------
  // Very close - continuous tone
  // -------------------------
  if (distance <= 30)
  {
    digitalWrite(BUZZER_PIN, HIGH);
    return;
  }

  // -------------------------
  // Choose beep interval based on distance
  // -------------------------
  unsigned long interval;

  if (distance <= 80)
    interval = 150;   // fast beep when close
  else
    interval = 1000;  // slow single beep when far

  if (currentMillis - previousBeepTime >= interval)
  {
    previousBeepTime = currentMillis;

    buzzerState = !buzzerState;

    digitalWrite(BUZZER_PIN, buzzerState);
  }
}
// =========================
// Setup
// =========================
void setup()
{
  Serial.begin(9600);

  radarServo.attach(SERVO_PIN);

  pinMode(TRIG_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);

  pinMode(BUZZER_PIN, OUTPUT);

  digitalWrite(BUZZER_PIN, LOW);

  radarServo.write(90);

  delay(1000);
}

// =========================
// Main Loop
// =========================
void loop()
{
  // Left -> Right Sweep
for (int angle = 0; angle <= 180; angle++)
{
  radarServo.write(angle);
  delay(20);

  float distance = getFilteredDistance();
  updateBuzzer(distance);

  Serial.print(angle);
  Serial.print(",");
  Serial.print(distance);
  Serial.print(",");
  Serial.println(1);
  
}
for (int angle = 180; angle >= 0; angle--)
{
  radarServo.write(angle);
  delay(20);

  float distance = getFilteredDistance();
  updateBuzzer(distance);

  Serial.print(angle);
  Serial.print(",");
  Serial.print(distance);
  Serial.print(",");
  Serial.println(-1);
  
}
}