// ======================================
// MILITARY RADAR GRID V2.1
// ======================================

void drawRadarGrid()
{
  pushMatrix();

  translate(centerX, centerY);

  noFill();

  // -----------------------------
  // Radar Rings
  // -----------------------------

  strokeWeight(2);

  for (int i = 1; i <= 6; i++)
  {
    stroke(0, 255, 0, 120);

    float r = radarRadius * i / 6.0;

    arc(0, 0, r * 2, r * 2, PI, TWO_PI);
  }

  // -----------------------------
  // Distance Labels
  // -----------------------------

  fill(0,255,0);

  textAlign(CENTER);

  textSize(18);

  for(int i=1;i<=6;i++)
  {
    float r = radarRadius*i/6.0;

    text(i*40+" cm",0,-r-8);
  }

  // -----------------------------
  // Angle Lines
  // -----------------------------

  stroke(0,255,0,80);

  for(int a=0;a<=180;a+=30)
  {
    line(
      0,
      0,
      radarRadius*cos(radians(a)),
      -radarRadius*sin(radians(a))
    );
  }

  // -----------------------------
  // Outer Arc
  // -----------------------------
noFill();
  stroke(0,255,0);

  strokeWeight(3);

  arc(
    0,
    0,
    radarRadius*2,
    radarRadius*2,
    PI,
    TWO_PI
  );

  popMatrix();

  // -----------------------------
  // Angle Labels
  // -----------------------------
  fill(0,255,0);

  textAlign(CENTER);

  textSize(18);

  for(int a=0;a<=180;a+=30)
  {
    float x=centerX+radarRadius*cos(radians(a));
    float y=centerY-radarRadius*sin(radians(a));

    text(a+"°",x,y-15);
  }
}
