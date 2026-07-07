void drawPanels()
{
  // --------------------------
  // Left Information Panel
  // --------------------------
  // --------------------------
// System Status Panel
// --------------------------
fill(0, 40, 0, 170);
stroke(0, 255, 0);
strokeWeight(2);
rect(20, 20, 300, 210, 12);

fill(0, 255, 0);
textAlign(LEFT);
textSize(20);
text("SYSTEM STATUS", 35, 50);

textSize(16);
text("STATUS", 35, 85);
text("OPERATIONAL", 180, 85);

text("MODE", 35, 110);
text("AUTO SCAN", 180, 110);

text("RADAR", 35, 135);
text("ONLINE", 180, 135);

text("SERIAL PORT", 35, 160);
text(COM_PORT, 180, 160);

text("BAUD RATE", 35, 185);
text(BAUD, 180, 185);
  // --------------------------
  // Right Threat Panel
  // --------------------------
  // --------------------------
// Radar Info Panel
// --------------------------
fill(0,40,0,170);
stroke(0,255,0);
strokeWeight(2);
rect(width-320,20,300,210,12);

fill(0,255,0);
textSize(20);
text("RADAR INFO", width-300, 50);

textSize(16);
text("MAX RANGE", width-300, 85);
text("240 cm", width-140, 85);

text("RESOLUTION", width-300, 110);
text("1°", width-140, 110);

text("SCAN SPEED", width-300, 135);
text("20 ms/step", width-140, 135);

text("FPS", width-300, 160);
text(int(frameRate), width-140, 160);

text("TARGETS", width-300, 185);
text(activeTargetCount, width-140, 185);

  // --------------------------
  // Bottom Status Bar
  // --------------------------
  fill(0,40,0,170);
  stroke(0,255,0);
  rect(20,height-45,width-40,25,8);

  fill(0,255,0);
  textAlign(CENTER);
  textSize(16);
  text(
  "SCAN RANGE : 240 cm   |   CURRENT ANGLE : " + nf(liveAngle,0,1) + "°" +
  "   |   CURRENT DISTANCE : " + nf(liveDistance,0,1) + " cm",
  width/2,
  height-26
);
}
void drawTargetList()
{
  fill(0, 40, 0, 170);
  stroke(0, 255, 0);
  strokeWeight(2);
  rect(width-320, 250, 300, 160, 12);

  fill(0,255,0);
  textAlign(LEFT);
  textSize(18);
  text("TARGET LIST", width-300, 280);

  textSize(13);
  int row = 0;
  for (int i = 0; i < MAX_TARGETS; i++)
  {
    if (!targetActive[i]) continue;

    String line = nf(row+1,2) + "   " + nf(targetAngle[i],0,1) + "°" +
                  "   " + nf(targetDist[i],0,1) + "cm";
    text(line, width-300, 305 + row*20);
    row++;
  }
}
void drawSensorGraph()
{
  float gx = 20, gy = 250, gw = 300, gh = 160;

  fill(0, 40, 0, 170);
  stroke(0, 255, 0);
  strokeWeight(2);
  rect(gx, gy, gw, gh, 12);

  fill(0,255,0);
  textAlign(LEFT);
  textSize(18);
  text("SENSOR DATA", gx + 15, gy + 30);

  noFill();
  stroke(0,255,0);
  strokeWeight(1);
  beginShape();
  for (int i = 0; i < GRAPH_POINTS; i++)
  {
    int idx = (histIndex + i) % GRAPH_POINTS;
    float x = gx + 15 + (gw - 30) * i / float(GRAPH_POINTS - 1);
    float y = gy + gh - 15 - map(distHistory[idx], 0, 240, 0, gh - 55);
    vertex(x, y);
  }
  endShape();
}
