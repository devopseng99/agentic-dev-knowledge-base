---
title: "Meridian Orrery — A 3D Printed Solar System on Your Desk Powered by ESP32C3"
url: "https://dev.to/bittobuild/meridian-orrery-a-3d-printed-solar-system-on-your-desk-powered-by-esp32c3-5ej5"
author: "Bit to Build"
category: "esp32-hardware"
---
# Meridian Orrery — A 3D Printed Solar System on Your Desk Powered by ESP32C3

**Author:** Bit to Build  **Published:** 2026-05-01

## Overview

The Meridian Orrery is an open-source project enabling users to build a functional mechanical solar system model using an ESP32C3 microcontroller and 3D-printed components. The system calculates planetary positions locally using onboard algorithms without internet connectivity.

## Key Concepts

- **Fully Functional Orrery**: Mechanical model of the solar system with all 8 planets plus Earth's Moon in motion
- **Offline Orbital Calculations**: Planetary positions computed directly on ESP32C3 microcontroller without internet
- **Moon Mechanics**: Orbits Earth via 1:11 gear ratio mechanism with software corrections for eccentricity
- **No Soldering Required**: Beginner-friendly design using connectors and 3D-printed enclosures
- **Stepper Motor Control**: TMC2209 stepper driver controls precision planetary motion
- **DS3231 RTC**: Hardware real-time clock maintains accuracy independently of WiFi/NTP

## Hardware Components

- ESP32C3 Super Mini (computational core)
- DS3231 RTC module (±2ppm precision timekeeping)
- TMC2209 stepper motor driver
- 3D-printed mechanical parts (all files open source)
- Reed switch + magnet (homing/calibration sensor)

## Orbital Mechanics on MCU

The ESP32C3 implements:
- Kepler's laws of planetary motion
- Simplified perturbation corrections
- Moon phase calculations
- Gear ratio compensation for mechanical accuracy

## Instructables Project

Full build guide, CAD files, and firmware:
https://www.instructables.com/Meridian-Orrery/

Tags: #esp32 #3dprinting #arduino #maker #orbital-mechanics
