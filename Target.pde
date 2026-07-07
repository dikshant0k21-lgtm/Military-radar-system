final int MAX_TARGETS = 10;
float[] targetAngle = new float[MAX_TARGETS];
float[] targetDist = new float[MAX_TARGETS];
int[] targetAge = new int[MAX_TARGETS];
boolean[] targetActive = new boolean[MAX_TARGETS];
int activeTargetCount = 0;

float lastDistance = 240;
float lastAngle = 0;
int confirmCount = 0;

void updateTargetList(float angle, float distance)
{
  for (int i = 0; i < MAX_TARGETS; i++)
  {
    if (!targetActive[i]) continue;

    if (abs(targetAngle[i] - angle) < 6 && abs(targetDist[i] - distance) < 15)
    {
      targetAngle[i] = angle;
      targetDist[i] = distance;
      targetAge[i] = 255;
      return;
    }
  }

  for (int i = 0; i < MAX_TARGETS; i++)
  {
    if (!targetActive[i])
    {
      targetAngle[i] = angle;
      targetDist[i] = distance;
      targetAge[i] = 255;
      targetActive[i] = true;
      return;
    }
  }
}

void ageTargets()
{
  activeTargetCount = 0;
  for (int i = 0; i < MAX_TARGETS; i++)
  {
    if (!targetActive[i]) continue;

    targetAge[i] -= 2;
    if (targetAge[i] <= 0)
    {
      targetActive[i] = false;
    }
    else
    {
      activeTargetCount++;
    }
  }
}
void drawReticle(float x, float y, float size, color c, int alphaVal)
{
  float half = size/2;
  float armLen = size*0.35;

  stroke(c, alphaVal);
  strokeWeight(2);
  noFill();

  // Top-left corner
  line(x-half, y-half+armLen, x-half, y-half);
  line(x-half, y-half, x-half+armLen, y-half);

  // Top-right corner
  line(x+half-armLen, y-half, x+half, y-half);
  line(x+half, y-half, x+half, y-half+armLen);

  // Bottom-left corner
  line(x-half, y+half-armLen, x-half, y+half);
  line(x-half, y+half, x-half+armLen, y+half);

  // Bottom-right corner
  line(x+half-armLen, y+half, x+half, y+half);
  line(x+half, y+half, x+half, y+half-armLen);

  // Center dot
  noStroke();
  fill(c, alphaVal);
  circle(x, y, 8);
}
void drawTarget()
{
  ageTargets();

  noStroke();
  for (int i = 0; i < MAX_TARGETS; i++)
  {
    if (!targetActive[i]) continue;

    float r = map(targetDist[i], 0, 240, 0, radarRadius);
    float x = centerX + r * cos(radians(targetAngle[i]));
    float y = centerY - r * sin(radians(targetAngle[i]));

    color reticleColor;
if (targetDist[i] < 40)
  reticleColor = color(255, 0, 0);
else if (targetDist[i] < 100)
  reticleColor = color(255, 255, 0);
else
  reticleColor = color(0, 255, 0);

drawReticle(x, y, 22, reticleColor, targetAge[i]);

fill(reticleColor, targetAge[i]);
textAlign(CENTER);
textSize(11);
text(nf(targetDist[i],0,1) + "cm", x, y + 24);
  }

  if (liveDistance <= 0 || liveDistance >= 220)
    return;

  if (abs(liveDistance - lastDistance) < 8 &&
      abs(liveAngle - lastAngle) < 3)
  {
    confirmCount++;
  }
  else
  {
    confirmCount = 0;
  }
  lastDistance = liveDistance;
  lastAngle = liveAngle;

  if (confirmCount < 2)
    return;

  updateTargetList(liveAngle, liveDistance);
}
