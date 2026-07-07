# Military-Style Ultrasonic Radar System
### Project Report

---

## Problem Statement

**What problem are you trying to solve?**

Low-cost autonomous obstacle detection and visualization is a foundational problem in robotics, security systems, and embedded sensing — most affordable ultrasonic sensors only provide a single-point, single-direction distance reading, which is not enough to build any spatial awareness of the surrounding environment. This project solves that by combining a single ultrasonic sensor with a rotating servo to sweep across a 180° field of view, then reconstructing that sweep into a real-time, human-readable radar display — similar in principle to how real radar/sonar systems build a 2D picture of their surroundings from a single rotating sensor.

**Why is it important?**

Understanding how to convert raw, noisy, single-axis sensor data into meaningful, filtered, spatially-organized information is a core skill in embedded systems and robotics — it directly underlies obstacle avoidance in autonomous vehicles, perimeter security systems, and even early-stage concepts in autonomous drone/robot navigation. Building this from first principles (rather than using an off-the-shelf LIDAR module) forces engagement with real challenges: sensor noise filtering, serial communication protocol design, real-time visualization, and honest handling of hardware limitations — all of which scale directly to more advanced sensing systems.

---

## 1. Objective

**What does this project aim to achieve?**

To design and build a functioning 180° sweep radar system using a single ultrasonic distance sensor and a servo motor, with a real-time software visualization that displays detected objects, their distance and angle, and basic proximity alerts — while ensuring every displayed value is derived from genuine sensor data rather than simulated or fabricated readings.

**Main goals:**
- Accurately measure distance to objects across a 180° horizontal sweep
- Filter out sensor noise to produce stable, trustworthy readings
- Track distinct objects across multiple sweep angles, rather than treating every reading as a separate detection
- Provide real-time audible proximity feedback (tiered buzzer alert)
- Visualize the scan as a live, radar-style graphical interface
- Maintain full honesty in the display — no panel shows data the hardware cannot actually justify

---

## 2. Background Research

**How do existing systems solve this problem?**

Commercial and research-grade radar/LIDAR systems typically use either:
- **Mechanically rotating LIDAR units** (e.g., RPLIDAR, Velodyne) — a narrow laser beam spun continuously via a motor, giving high angular resolution
- **Phased-array radar** — no moving parts; steers the beam electronically (used in military and automotive radar, e.g., adaptive cruise control)
- **Solid-state ToF (Time-of-Flight) sensor arrays** — multiple fixed sensors covering different angles simultaneously

**What technologies are commonly used?**

- Ultrasonic sensors (HC-SR04 and similar) — low-cost, moderate accuracy, wide beam angle
- Infrared ToF sensors (VL53L0X, VL53L1X) — laser-based, narrow beam, higher precision
- Servo or stepper motors for mechanical sweep-based systems
- Microcontroller-based signal filtering (Kalman filters, moving averages, simple threshold-based confirmation)

**What are their limitations?**

- Ultrasonic sensors suffer from **wide beam divergence** (~15° cone for HC-SR04), meaning angular resolution is fundamentally limited regardless of software processing
- Mechanical sweep systems are slower than solid-state/phased-array systems, since physical rotation takes real time
- Low-cost ultrasonic sensors are prone to noise from weak/angled echoes, requiring software-side filtering
- Servo-based systems introduce mechanical wear and potential jitter compared to purely electronic beam steering

This project deliberately uses the low-cost, mechanically-swept ultrasonic approach — a good balance of feasibility and genuine engineering challenge for a student-built system, while being transparent about its known limitations rather than treating it as if it had LIDAR-grade precision.

---

## 3. Theory

**Distance measurement principle (Ultrasonic Time-of-Flight):**

The HC-SR04 emits a 40kHz ultrasonic pulse and measures the time taken for the echo to return after reflecting off an object. Distance is calculated using the speed of sound:

```
distance = (time_elapsed × speed_of_sound) / 2
```

The division by 2 accounts for the sound traveling to the object and back — the measured time covers the round trip, not just the one-way distance. Using the speed of sound at room temperature (~343 m/s, or 0.0343 cm/µs):

```
distance (cm) = (duration_in_microseconds × 0.0343) / 2
```

**Beam divergence and angular resolution:**

The HC-SR04's ultrasonic beam is not a narrow ray — it radiates in a cone of roughly 15°. This means the sensor cannot distinguish a reflection originated; it only confirms "something is present at this distance, somewhere within this angular spread." This directly limits the achievable angular precision and causes systematic overestimation when calculating object width from angular span, since:

```
apparent_width ≈ distance × angle_span_in_radians
```

includes both the object's true physical width and the beam's inherent angular spread — a real, physically-grounded limitation, not a software bug.

**Polar-to-Cartesian coordinate conversion (for display):**

Since the sensor reports distance and the servo reports angle, this is inherently **polar coordinate data** (r, θ). To draw a detected point on a 2D screen, it must be converted to Cartesian (x, y):

```
x = centerX + r × cos(θ)
y = centerY − r × sin(θ)
```

(The negative sign on the y-component accounts for screen coordinate systems typically having y increase downward, while standard trigonometric convention has angles increasing counter-clockwise from the positive x-axis.)

**Signal filtering (noise rejection):**

Raw ultrasonic readings can contain occasional erroneous spikes due to weak or angled echoes. This project uses a simple **two-hit confirmation filter**: a new reading is only accepted as valid once two consecutive readings fall within a small tolerance of each other, rejecting single-frame noise spikes while still responding quickly to genuine changes.

---

## 4. Hardware Selection

| Component | Why Chosen | Possible Alternatives |
|---|---|---|
| Arduino Uno | Widely available, simple to program, sufficient I/O and processing power for this task, well-documented | ESP32 (more powerful, wireless capable, but unnecessary complexity for this scope), STM32 (steeper learning curve) |
| HC-SR04 Ultrasonic Sensor | Low cost, simple digital trigger/echo interface, adequate range (up to ~4m) for indoor testing | VL53L0X/VL53L1X ToF laser sensor (narrower beam, higher precision, but higher cost and requires I2C rather than simple digital timing) |
| SG90 Micro Servo | Inexpensive, sufficient torque for sweeping a lightweight sensor, standard PWM control compatible with Arduino's Servo library | Stepper motor (more precise positioning, but requires a driver circuit and more complex control logic) |
| Piezo Buzzer | Simple, low-power audible alert mechanism, directly PWM/digital-pin controllable | Active buzzer module (simpler but less control over tone), speaker + amplifier (overkill for simple alerts) |
| Processing (Java-based) | Free, well-suited for rapid 2D graphics and real-time visualization, straightforward serial communication with Arduino | Python with Pygame/Matplotlib (viable alternative, similar capability), a native mobile/web app (significantly more development overhead) |

---

## 5. System Design

**Overall Architecture:**

The system consists of two independent programs connected via USB serial communication:

1. **Arduino (embedded firmware)** — controls the servo sweep, triggers the ultrasonic sensor at each angular step, applies real-time noise filtering, controls the buzzer, and transmits `angle,distance,direction` as a comma-separated string over serial for each step.
2. **Processing (desktop visualization application)** — receives and parses the serial stream, performs object clustering/tracking, and renders a real-time radar-style graphical interface.

**Block Diagram (described):**

```
[HC-SR04 Sensor] --(echo timing)--> [Arduino: distance calc + filter]
                                              |
[Servo Motor] <--(angle control)-- [Arduino: sweep control]
                                              |
                                     [Serial: angle,distance,direction]
                                              |
                                    [Processing: SerialReader]
                                              |
                        -----------------------------------------
                        |              |               |         |
                 [Target Clustering] [Sweep Draw]  [Grid Draw]  [Panels/UI]
                        -----------------------------------------
                                              |
                                    [Live Radar Display]
```

**Wiring:**

| Component | Pin | Arduino Pin |
|---|---|---|
| HC-SR04 | VCC | 5V |
| HC-SR04 | GND | GND |
| HC-SR04 | TRIG | D9 |
| HC-SR04 | ECHO | D10 |
| SG90 Servo | Signal | D6 |
| SG90 Servo | VCC | 5V |
| SG90 Servo | GND | GND (common ground) |
| Piezo Buzzer | + | D8 |
| Piezo Buzzer | − | GND |

**Flowchart (Arduino loop, described):**

```
START
  |
Set servo angle (0 to 180, then 180 to 0)
  |
Trigger ultrasonic pulse
  |
Measure echo duration
  |
Calculate raw distance
  |
Apply two-hit confirmation filter
  |
Update buzzer (based on filtered distance tier)
  |
Send angle, distance, direction over serial
  |  
Repeat (loop back to servo angle step)
```

---

## 6. Implementation

**Circuit Assembly:**
Components were wired per the table above on a breadboard, with all grounds tied to a single common rail (star grounding) to avoid electrical noise between the buzzer and ultrasonic sensor circuits — an issue identified and resolved during testing (see Results & Analysis).

**Programming:**
The Arduino firmware was written in C++ (Arduino IDE), structured into clearly separated functions: `getDistance()` (raw sensor reading), `getFilteredDistance()` (noise rejection), `updateBuzzer()` (tiered audible alert logic), and the main sweep loop. The Processing visualization was structured into multiple tabs, each with a single responsibility (serial communication, target tracking, grid rendering, sweep rendering, panel/UI rendering) — a deliberate software engineering practice known as separation of concerns.

**Algorithms:**
- **Two-hit confirmation filtering** — described in Theory section
- **Target clustering** — incoming confirmed readings are compared against a list of currently tracked objects; a match (within angular and distance tolerance) updates the existing object, while no match creates a new tracked object, preventing a single physical object from being miscounted as many separate detections
- **Sweep smoothing (frame interpolation)** — the displayed sweep angle is eased toward the latest reported angle by a fixed fraction each rendered frame, producing visually smooth motion despite discrete serial updates

**Calibration and Testing:**
Distance readings were cross-checked against a physical tape measure at several known distances to confirm accuracy within expected sensor tolerance. Buzzer tier thresholds and clustering tolerances were empirically tuned by observing live behavior against real objects at varying distances and angles.

---

## 7. Results & Analysis

**Observations:**
- The system reliably detects and tracks objects within its 240cm operating range
- The two-hit confirmation filter substantially reduced false-positive buzzer triggers caused by sensor noise
- Target clustering successfully reduced a previously inflated, meaningless "target count" (which had climbed to 20+ from a single stationary object due to counting every individual reading) down to an accurate count of genuinely distinct objects

**Expected vs. Actual Performance:**
The system performs as expected for its intended scope — reliable detection and tracking within an indoor range, with known and explainable limitations in angular precision due to the ultrasonic sensor's beam divergence (see Limitations below), which was anticipated from the sensor's datasheet specifications rather than discovered as an unexpected failure.

---

## 8. Limitations & Future Improvements

**Current Shortcomings:**
- The HC-SR04's ~15° beam angle limits true angular resolution and causes systematic overestimation in any object-width calculation
- The system uses one-way serial communication only (Arduino → computer); there is no manual override or two-way control
- Sweep timing uses fixed-interval stepping rather than adaptive speed based on detection proximity
- The visualization currently only supports a 180° field of view, not a full 360° scan

**Possible Hardware Upgrades:**
- Replacing the HC-SR04 with a VL53L0X/VL53L1X laser Time-of-Flight sensor would substantially improve angular precision by using a much narrower beam
- Adding a second servo+sensor pair to cover the remaining 180°, achieving full 360° coverage
- External power supply for the servo to eliminate any residual risk of current-draw brownout affecting sensor timing

**Software Improvements:**
- Converting the sweep interpolation from frame-rate-dependent to time-delta-based smoothing, ensuring consistent visual behavior regardless of the host computer's performance
- Implementing a beam-divergence calibration offset in width estimation calculations
- Adding data logging to a file for post-session analysis

**Ideas for Future Versions:**
- Two-way serial communication enabling manual scan control
- Sensor fusion with a camera module for basic object classification, moving toward genuine autonomous perception
- Migration to a full 360° dual-sensor architecture with a non-blocking, state-machine-based sweep control loop

---

## 9. Conclusion

**Final Outcome:**
A fully functional, autonomous 180° ultrasonic radar system with real-time filtered detection, distinct object tracking, tiered proximity alerting, and an honest, data-accurate visual interface — built and debugged from first principles, with every displayed value traceable to genuine sensor input.

