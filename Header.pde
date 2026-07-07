void drawHeader()
{
  float bannerW = 520;
  float bannerH = 50;
  float bannerX = width/2 - bannerW/2;
  float bannerY = 15;

  // -----------------------------
  // Hazard stripes - left side
  // -----------------------------
  stroke(0,255,0,150);
  strokeWeight(2);
  for (int i = 0; i < 6; i++)
  {
    float x1 = bannerX - 140 + i*22;
    line(x1, bannerY + bannerH, x1 + 14, bannerY);
  }

  // -----------------------------
  // Hazard stripes - right side
  // -----------------------------
  for (int i = 0; i < 6; i++)
  {
    float x1 = bannerX + bannerW + 20 + i*22;
    line(x1, bannerY + bannerH, x1 + 14, bannerY);
  }

  // -----------------------------
  // Angled banner shape
  // -----------------------------
  noFill();
  stroke(0,255,0);
  strokeWeight(2);
  beginShape();
  vertex(bannerX + 20, bannerY);
  vertex(bannerX + bannerW - 20, bannerY);
  vertex(bannerX + bannerW, bannerY + bannerH/2);
  vertex(bannerX + bannerW - 20, bannerY + bannerH);
  vertex(bannerX + 20, bannerY + bannerH);
  vertex(bannerX, bannerY + bannerH/2);
  endShape(CLOSE);

  // -----------------------------
  // Title text
  // -----------------------------
  fill(0,255,0);
  textAlign(CENTER, CENTER);
  textSize(28);
  text("MILITARY RADAR SYSTEM", width/2, bannerY + bannerH/2);
}
void drawClock()
{
  fill(0,255,0);
  textAlign(RIGHT);
  textSize(14);

  String timeStr = nf(hour(),2) + ":" + nf(minute(),2) + ":" + nf(second(),2);
  String dateStr = nf(day(),2) + "/" + nf(month(),2) + "/" + year();

  text(timeStr, width-30, 30);
  text(dateStr, width-30, 48);
}
