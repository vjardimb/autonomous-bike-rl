# Bicycle Balancing and Directional Control Project

## Overview

This project, conducted in collaboration with the Intelligent Systems, Vision and Control Department at the Faculty of Engineering of the University of Porto, aims to apply and compare different types of intelligent controllers in the task of balancing and directional control of a bicycle.

The project involves using a path of points in the 2D plane as a reference and passing a target velocity to the bicycle. The bicycle's control is achieved through two distinct actions: torque applied to the rear wheel, causing it to move forward, and torque applied to the handlebars, enabling it to turn. Various measurements constitute the bicycle's state for each instant, including position in the plane, orientation, velocity, lean angle, and steering angle.

A simulator is developed using Matlab and Simulink, modeling the environment using Simscape Multibody. The simulator is largely inspired by the work of Rizwan Ahmed ([YouTube link](https://www.youtube.com/watch?v=UStQpcYUEko&ab_channel=RPTULRS)).

Initially, a Deep Deterministic Policy Gradient (DDPG) agent is trained. Subsequently, a Proportional-Integral-Derivative (PID) controller, with parameters tuned using reinforcement learning, is also implemented. The results and performances of both controllers are compared.
