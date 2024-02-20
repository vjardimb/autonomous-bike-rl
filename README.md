# Bicycle Balancing and Directional Control Project

## Overview

This project, conducted in collaboration with the Intelligent Systems, Vision and Control Department at the Faculty of Engineering of the University of Porto, aims to apply and compare different types of intelligent controllers in the task of balancing and directional control of a bicycle.

The project involves using a path of points in the 2D plane as a reference and passing a target velocity to the bicycle. The bicycle's control is achieved through two distinct actions: torque applied to the rear wheel, causing it to move forward, and torque applied to the handlebars, enabling it to turn. Various measurements constitute the bicycle's state for each instant, including position in the plane, orientation, velocity, lean angle, and steering angle.

A simulator is developed using Matlab and Simulink, modeling the environment using Simscape Multibody. The simulator is largely inspired by the work of Rizwan Ahmed ([YouTube link](https://www.youtube.com/watch?v=UStQpcYUEko&ab_channel=RPTULRS)).

![Perfomance demonstration](include/animations/autonomous_bicycle_RL.mp4)

## File Organization

- `manualControlBike/`: Basic version of the project where the bike is controlled by explicit inputs. Mainly used for debugging and testing.
- `steerControlBikeRL/`: Bicycle controlled only by steering. The controller here is a DDPG agent. A simpler and initial version of the challenge. The initial velocity parameter in the `config.m` file should not be zero to make the bike move and balance itself throughout the desired path.
- `steerSpeedControlBikeRL/`: More complex version of the problem. The cycling torque is now added as a control variable. A reference velocity is set at the beginning of every simulation. Controller is still a DDPG agent.
- `include/`: Folder holding images, animations, and CAD models necessary for proper simulation.
- `Extr_Data_Mesh.m`: Function to avoid errors in the `config.m` file.
- `config.m`: Configuration file with all the necessary parameters for running any of the simulations cited above.

## Usage

1. Clone the repository:
```bash
git clone https://github.com/vjardimb/autonomous-bike-rl.git
```
2. Navigate to the desired simulation folder, for instance:
```bash
cd steerControlBikeRL/
```
3. Run the desired .slx file.
