# Introduction
---
## Overview
This project aims at improving current sound processing methods for robotics applications. The improved methodology involves the usage of a microphone array and allows the robot to differentiate and localize simultaneous sound sources to perform better in a complex sound environment.  
First, independent source signals from the recordings were extracted; then, the incidence angles of those sound sources were found. Several digital signal processing techniques are incorporated in the proposed method. Frequency-Domain Independent Component Analysis(FDICA) is used to extract independent sound sources from sound mixtures, and Time Delay of Arrival(TDOA) method is used to perform source localization. 

## Methodology
Sound source separation is used to distinguish independent sound from a sound mixture, and it can be done using Independent Component Analysis (ICA).   
ICA allows robots to extract and recover the different sound content of a particular source from the mixtures of signals captured from microphones. After separating each sound source, the location of those sources can be determined.  
Sound localization aims at giving robots spatial instructions, such as what direction to turn its head or what position to walk towards.  This can be done using the Time Delay of Arrival (TDOA) method: since there are multiple microphones in an array, the sound intensities and phase information captured by an individual microphone is different from the others. The time difference of arrival on microphone pairs can be used to approximate corresponding angles of incidence, and the angles calculated can be used to approximate the possible source location.

# Apparatus Design
---
The main consideration in the apparatus design is the capability of capturing and transferring multi-channel audio signals to a computer. Thus, the microphone selected should have corresponding operating range to the human audible range, and the data acquisition unit should be able to sample all channels simultaneously. 
	* The microphone used is the Polsen OLM-19 model, which consists of an omnidirectional microphone, an external 5V power supply, and a 3.5mm audio jack. The audio jack is converted to a balanced XLR connection before connected the data acquisition device for noise reduction. The diameter of the microphone is only 50 mm, allowing the array to be easily portable.  
	* The microphones are arranged in an octahedron shape as shown in figure 1. Mic 1 through 4 are arranged in the mid-horizontal plane, and Mic 5& 6 are located on the vertical axis through the center of the mid-plane.
	* The data acquisition device used for this project is the TASCAM US1608 audio interface. It can support a simultaneous sampling frequency of 44.1kHz across all 16 input channels, including 8 XLR channels. 
Signal recording is performed using MATLAB Data Acquisition app, and individual microphone captured signal are stored unmixed and independent from the other signal for ten seconds session.


