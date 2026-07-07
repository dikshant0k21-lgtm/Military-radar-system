# 🛰️ Military-Style Ultrasonic Radar System

A 180° sweep radar built with an Arduino and an HC-SR04 ultrasonic sensor mounted on a servo, with a real-time visualization dashboard built in Processing — live sweep line, distinct object tracking, tiered proximity buzzer, and a HUD-style display.

(![Radar Demo](https://github.com/user-attachments/assets/9f36f0f6-f047-45c1-bae3-f104c70718f0)

## Overview

Most low-cost ultrasonic sensors only report distance in a single fixed direction. This project adds a servo to sweep the sensor across a 180° field, then reconstructs that sweep in real time into a radar-style display — similar in principle to how rotating sensors build spatial awareness in robotics and autonomous systems.

**Key features:**
- Real-time 180° ultrasonic sweep with servo control
- Two-hit confirmation filtering to reject sensor noise
- Distinct object tracking (clustering) — correctly counts physical objects instead of raw readings
- Tiered audible proximity alert (continuous / fast beep / slow beep based on distance)
- Live radar-style visualization: sweep line with fading trail, bracket-style target reticles, distance graph, system status panels
- Every value shown on screen is derived from live sensor data — no fabricated or placeholder readings

---

## Hardware Used

| Component | Purpose |
|---|---|
| Arduino Uno | Main microcontroller |
| HC-SR04 Ultrasonic Sensor | Distance measurement |
| SG90 Micro Servo | Sweeps the sensor across 180° |
| Piezo Buzzer | Tiered proximity alert |

**Wiring:**

| Component | Pin | Arduino Pin |
|---|---|---|
| HC-SR04 | VCC / GND | 5V / GND |
| HC-SR04 | TRIG | D9 |
| HC-SR04 | ECHO | D10 |
| SG90 Servo | Signal | D6 |
| SG90 Servo | VCC / GND | 5V / GND (common ground) |
| Piezo Buzzer | + / − | D8 / GND |

---

## How It Works

1. **Arduino** sweeps the servo 0°→180°→0° continuously, measuring distance at each angular step via the HC-SR04.
2. Raw readings pass through a **two-hit confirmation filter** — a value is only trusted once two consecutive readings agree within a small tolerance, rejecting single-frame noise spikes.
3. The filtered distance drives a **three-tier buzzer**: silent when clear, slow beep at medium range, fast beep when closer, continuous tone when very close.
4. Angle, distance, and sweep direction are sent over USB serial as `angle,distance,direction`.
5. **Processing** reads this stream, applies **object clustering** (grouping nearby readings into distinct tracked targets rather than counting every reading separately), and renders the full radar display in real time — including a smoothed, fading sweep line, bracket-style target markers, a live sensor data graph, and system status panels.

---

## Software Architecture

The Processing sketch is split by responsibility, not by size — a deliberate separation-of-concerns approach:

- `SerialReader` — the only tab that communicates with Arduino
- `Target` — object clustering and tracking logic
- `RadarGrid` / `Sweep` — the static grid and the moving sweep line
- `Panels` — all UI information boxes (System Status, Radar Info, Target List, Sensor Graph)
- `Header` — title banner and live clock
- `Config` — shared variables used across tabs

---

## Known Limitations

- The HC-SR04 has a ~15° beam angle (not a narrow beam), which limits true angular resolution and would cause any object-width estimate to be an overestimate — a genuine physical sensor limitation, not a software bug
- Currently one-way serial communication only (Arduino → computer), no manual override
- 180° field of view only, not full 360°
- Sweep uses fixed-interval stepping rather than adaptive speed

See the [full project report](Military_Radar_Project_Report.md) for detailed theory, design decisions, and future improvement plans.

---

## Getting Started

1. Wire the hardware per the table above
2. Upload `MilitaryRadar.ino` to your Arduino via the Arduino IDE
3. Open the Processing sketch, set `COM_PORT` in the `Config` tab to match your Arduino's serial port
4. Run the Processing sketch — the radar display should start immediately once the Arduino is connected and powered

## Author

Built by Dikshant as part of an ongoing embedded systems / edge AI learning path (C → Arduino → STM32 → FreeRTOS → Edge AI).
