void settings()
{
    fullScreen();
}

void setup()
{
  frameRate(60);
  GREEN = color(0,255,0);
  GREEN_DIM = color(0,120,0);
  GREEN_BRIGHT = color(100,255,100);

  BACKGROUND = color(0);

  centerX = width/2;
  centerY = height-60;

  initFonts();
  initSerial();
}

void draw()
{
  background(BACKGROUND);
  
  
 distHistory[histIndex] = liveDistance;
histIndex = (histIndex + 1) % GRAPH_POINTS; 
 
 
  float angleDiff = liveAngle - sweepAngle;
sweepAngle += angleDiff * 0.1;
  drawHeader(); 
  drawClock ();
  drawRadarGrid();
  drawSweep();
  drawTarget();
  drawPanels();
  drawTargetList();
  drawSensorGraph();
}
