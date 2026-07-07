import processing.serial.*;
Serial myPort;

void initSerial()
{
  println(Serial.list());
  myPort = new Serial(this, COM_PORT, BAUD);
  myPort.bufferUntil('\n');
}

void serialEvent(Serial p)
{
  String data = trim(p.readStringUntil('\n'));
  if (data == null)
    return;

  String values[] = split(data, ',');
  if (values.length != 3)
    return;

  float newAngle = float(values[0]);
  float newDistance = float(values[1]);
  int newDir = int(values[2]);

  sweepDirection = newDir;

  newDistance = constrain(newDistance, 0, 240);

  liveAngle = newAngle;
  liveDistance = newDistance;
  sweepAngle = liveAngle;
}
