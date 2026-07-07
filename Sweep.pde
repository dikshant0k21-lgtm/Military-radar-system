// =====================================
// MILITARY RADAR SWEEP V2.1
// =====================================

void drawSweep()
{
  pushMatrix();
  translate(centerX, centerY);

  // -----------------------------
  // Sweep Glow
  // -----------------------------
  int dir = sweepDirection;

  for (int i = 0; i < 35; i++)
  {
    float a = sweepAngle - (i * dir);
    stroke(0, 255, 0, 8 + (35 - i) * 3);
    strokeWeight(2);
    line(0, 0, radarRadius * cos(radians(a)), -radarRadius * sin(radians(a)));
  }

  // -----------------------------
  // Main Sweep
  // -----------------------------
  stroke(0,255,0);
  strokeWeight(4);
  line(
    0,
    0,
    radarRadius*cos(radians(sweepAngle)),
    -radarRadius*sin(radians(sweepAngle))
  );

  // -----------------------------
  // Sweep Head
  // -----------------------------
  noStroke();
  fill(0,255,0);
  circle(
    radarRadius*cos(radians(sweepAngle)),
    -radarRadius*sin(radians(sweepAngle)),
    10
  );

  previousSweepAngle = sweepAngle;
  popMatrix();
}
