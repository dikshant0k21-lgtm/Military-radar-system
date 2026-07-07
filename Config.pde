// ================================
// CONFIGURATION
// ================================

// Window
int SCREEN_W = 1920;
int SCREEN_H = 1080;

// Radar
float radarRadius = 430;
float centerX;
float centerY;

// Sweep

float sweepAngle = 0;
float sweepSpeed = 0.8;
float previousSweepAngle = 0;

int sweepDirection = 1;
float lastRawAngle = 0;
// Sensor Graph History
int GRAPH_POINTS = 100;
float[] distHistory = new float[GRAPH_POINTS];
int histIndex = 0;

// Colors

color GREEN;
color GREEN_DIM;
color GREEN_BRIGHT;
color BACKGROUND;

// Serial

String COM_PORT = "COM7";
int BAUD = 9600;

// Live Data

float liveAngle = 0;
float liveDistance = 0;

// Detection

boolean targetDetected = false;

// UI

PFont radarFont;
