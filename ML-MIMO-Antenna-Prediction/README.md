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

5.Methodology

The complete workflow is illustrated below.

The project follows the following stages:

Antenna Design in HFSS
Parametric Sweep Generation
S-Parameter Extraction
MATLAB Data Processing
Dataset Creation
Machine Learning Training
Model Evaluation
Performance Prediction
6. Dataset Generation

Simulation data was generated using HFSS parametric sweeps.

Input Features
Feature
Frequency (f)
Dielectric Constant (k)
Defected Ground Length (Ldf)
Patch Length (Lp)
Patch Width (Wp)
Substrate Width (Ws)
Output Features
Output Parameter
S11
Isolation
ECC
DG
CCL
TARC

Each combination of antenna dimensions generated a unique simulation sample for ML model training.

7. Antenna Performance Parameters
Return Loss (S11)

Measures reflected power at the input port.

Desired:

S11 < -10 dB




Envelope Correlation Coefficient (ECC)

Measures correlation between antenna elements.

Desired:

ECC ≈ 0




Channel Capacity Loss (CCL)

Represents loss in MIMO communication capacity.

Lower values indicate better performance.




Diversity Gain (DG)

Measures diversity improvement.

Ideal value:

DG ≈ 10 dB

Total Active Reflection Coefficient (TARC)

Represents active reflection from all ports.

Lower values indicate better antenna efficiency.

8. Machine Learning Models

Four regression algorithms were evaluated.

K-Nearest Neighbors (KNN)
Distance-based regression
Simple implementation
Effective for small datasets
Random Forest
Ensemble learning approach
Multiple decision trees
Robust against overfitting
Gradient Boosting
Sequential boosting method
Learns from residual errors
Captures nonlinear relationships
XGBoost
Advanced gradient boosting framework
Faster convergence
Better regularization
Higher prediction accuracy

XGBoost achieved the best overall performance and was selected as the final surrogate model.

9. Model Performance Comparison
Model	ECC R²	CCL R²
XGBoost	0.8806	0.6554
Random Forest	0.8470	0.7039
Gradient Boosting	0.8610	0.6510
KNN	0.6684	0.5101

Authors

Sireesha P

Brunda R A

Sinchana Y R

Manasa K R

Department of Electronics and Communication Engineering

Dayananda Sagar University, Bengaluru
