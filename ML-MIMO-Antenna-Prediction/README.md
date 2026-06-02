ML-Based Performance Prediction of an Orthogonal MIMO Antenna
1.Project Overview

This project presents a Machine Learning (ML) based framework for predicting the performance of a 2×2 Orthogonal MIMO Antenna designed for Sub-6 GHz 5G applications.

Conventional antenna optimization relies heavily on repeated full-wave electromagnetic simulations, which are computationally expensive and time-consuming. To overcome this challenge, this project combines HFSS simulation data with Machine Learning algorithms to rapidly predict antenna performance metrics such as:

Return Loss (S11)
Isolation (S21)
Envelope Correlation Coefficient (ECC)
Diversity Gain (DG)
Channel Capacity Loss (CCL)
Total Active Reflection Coefficient (TARC)

The proposed framework significantly reduces simulation time while maintaining high prediction accuracy.

2.Key Features

 Design of a 2×2 Orthogonal MIMO Antenna for 5G

 Dataset generation using HFSS parametric sweeps

 MATLAB-based data extraction and preprocessing

 Machine Learning model training using Python

 Comparative study of KNN, Random Forest, Gradient Boosting and XGBoost

 High-accuracy antenna performance prediction

 Reduced dependency on repeated electromagnetic simulations

3. Background
Why MIMO?

Multiple Input Multiple Output (MIMO) technology employs multiple transmitting and receiving antennas to improve:

Channel Capacity
Spectral Efficiency
Data Throughput
Link Reliability

MIMO systems are widely used in:

4G LTE
5G NR
Wi-Fi 6
Future 6G Communication Systems

However, compact MIMO antenna design introduces mutual coupling effects that degrade performance. Orthogonal placement of antenna elements helps reduce coupling while improving polarization diversity.

4. Proposed Antenna Design

The antenna was designed and simulated in Ansys HFSS.

Design Specifications
Parameter	Value
Operating Frequency	3.5 GHz
Substrate Material	FR4
Relative Permittivity	4.4
Substrate Height	1.6 mm
Configuration	2×2 Orthogonal MIMO
Antenna Geometry



