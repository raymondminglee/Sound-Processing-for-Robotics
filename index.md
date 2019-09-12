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
<img src="pic/mic.PNG?raw=true"/>  
<br><br>  
Signal recording is performed using MATLAB Data Acquisition app, and individual microphone captured signal are stored unmixed and independent from the other signal for ten seconds session.

# DSP
---
The first step for signal processing is using the Frequency-Domain Independent Component Analysis(FDICA) to extract each of the individual sound from mixtures. And the second step is to find the incidence angle for each of the sound source through the TDOA method that uses the correlation between the extracted signal and the original signal.   

## Source Seperation using FDICA
For this project, the implemented MATLAB code for Short-Time Fourier Transform and Inverse Short-Time Fourier transform is open source on MathWorks written by Hristo Zhivomirov. For complex signal source separation, one of the function called jade incorporated from JF Cardoso. 
The FDICA is conducted in the following sequence: first, the signals are transformed from time-domain to frequency-domain using STFT, Short-Time Fourier Transform. Then the signals are divided into narrow sub-bands, and the inverse of the mixing matrix A is optimized in each sub band. Finally, the results are reconstructed back from the smaller sub bands.
<img src="pic/ica.PNG?raw=true"/>

## Source Localization Using TDOA
Sound localization using TDOA is one of the most conventional ways to localize sound a source. Since the microphone array configures microphones such that the distance between any two is not zero, a specific sound signal will arrive at each microphone at a slightly different time. The incidence angle of a sound source could be estimated using this time difference, under the assumption that sound travels at a constant speed in air. 
<img src="pic/tdoa.PNG?raw=true"/>

### Cross Correlation
The accuracy of the time delay between signals from a pair of microphones is a key parameter to implement the above localization method. This time delay is found by performing a cross-correlation function in MATLAB.  
 
### Multi-Source Localization
Multi-source localization is achieved by implementing TDOA localization method to both extracted source signals and microphone signals.  
After ICA, each extracted source signal is first compared with the four signals captured from the microphones on the mid-plane.  
Whichever microphone signal that has the highest correlation with the extracted source means that this microphone is the closest to the source location. Then we use cross-correlation again to find the time delay between the extracted source and the adjacent microphones. Noted that for multi-source localization, the time delay of arrival is not simply the time delay between two microphone signals, but time delay between two microphone signals relative to the extracted source signal.  
Similarly, for the vertical axis, an elevation angle for each sound source can be obtained.  
All the Matlab DSP function are availabel on to the [repository](https://github.com/raymondminglee/Sound-Processing-for-Robitics/code) 
<img src="pic/dsp.png?raw=true"/>



# Result
---
## Single Source Localization 
The accuracy of the single-source localization method was obtained through experiments in which a speaker at a known location was recorded and compared to the calculated results.  

|Trail|Actual (degree)|Calculated (degree)|Difference (degree)| 
|-----|---------------|-------------------|-------------------|
| 1  |  270  |  273.7  |  -3.7  |
| 2  |  45  |  45  |  0   |
| 3  |  160  |  154.3  |  5.7  |
| 4  |  330  |  331  |  -1  |
| 5  | 90  | 95.8  |  -5.9  |


## Source Extraction Result
For source extractions, a total of 5 sources were estimated. For each extracted source signal, we listened and subjectively identified which speaker the sound best represents.For the trail shown below, Speaker A is a female participant, and speaker B is a male participant.  

The following graphs show the comparison between the participants’ voices and extracted source signals in time-domain.
<img src="pic/source.png?raw=true"/>

the extracted source signals resemble the actual signal in time-domain. This resemblance indicates that the ICA algorithm can extract sound source successfully. 

However, the sound quality of the extracted signals is unstable, especially for the male speaker. The reason for this instability is suspected to be due to the low-frequency content of the male voice, which might be mixed up with the low-frequency background noise from the rooms' HVAC system. 

## Multi Source Localization
For one of the trails, during which two speakers are talking at the same time while the background music is playing, six microphones are used. Hence, we can extract up to five sources. Out of the five extracted sources, three of them contain useful audio content from the two-original speech. The localization result is shown below.

|Extracted Signal|Planar Angle|Error|Elevation Angle|Error|
|---|---|---|---|---|
|Speaker A|	230|-5|	92|	3|
|Speaker B|	56|	-56|99|	11|
|Speaker A|	228|-3|	180|.-75|

<img src="pic/loc.png?raw=true"/>

The accuracy of the multi-source localization is highly dependent on the quality of the ICA extracted signal. When the extracted signals can be identified subjectively as one of the known sound sources, the error between the actual and the estimated angle are relatively small (less than 10 degrees). However, for example, the above trail doesn’t have a clear extracted signal for Speaker B. Thus, the error is relatively large. The elevation angle is calculated using the similar methodology. However, its error doesn’t correspond to the quality of the ICA algorithm. 








