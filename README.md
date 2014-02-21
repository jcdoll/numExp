numExp
================

Simple numerical computing experiments in various languages (Matlab, Julia, Python)

## Setup

### Matlab
- Install your favorite flavor of Matlab, preferably R2008 or later for OOP

### Julia
- Download and install Julia (http://julialang.org/downloads/)
- Download and install JuliaStudio (http://forio.com/products/julia-studio/)

### Python
- Windows x64 using WinPython (https://code.google.com/p/winpython/)
- For small projects, use Spyder (WinPython/spyder.exe)
- For large projects, use PyCharm (http://www.jetbrains.com/pycharm/download/)
- In PyCharm, File > Settings > Project Interpreter > Select WinPython/python/python.exe
- Also see http://sjbyrnes.com/?page_id=67

## Projects

### afm_hertz_analysis
Fits Hert elastic contact theory to the case of a pyramidal indentor indenting an elastic half space. Assumes that the sample is negligibly viscoelastic, smooth, and much thicker than the indentation depth. Intended for extracting the elastic modulus from atomic force microscope (AFM) data on polydimethylsiloxane and biological samples.

### uncertainty_analysis
Simple error propagation uncertainty analysis for the spring constant of a cantilever beam. Calculates the uncertainty from provided tolerances in elastic modulus, density and dimensions. Intended for estimating the uncertainty in the stiffness of a microfabricated silicon beam.

### power_spectral_density
Calculate and plot the power spectral density of time series data. The window size and overlap is adjustable in the code, and several plots are generated. Useful for analysing the resolution of MEMS sensors.

## web_suprem
Everyone loves tsuprem. Too bad you need to run it from the shell. Wouldn't it be great if you could run simple simulations from your browser? This code is built to run on Stanford Linux servers (e.g. hedge.stanford.edu)