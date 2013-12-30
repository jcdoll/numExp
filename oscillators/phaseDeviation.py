# Simulate the phase variation of an oscillator excited by thermal noise
# as a function of the steady-state phase. The in-phase (real) component of
# the drive amplitude is fixed and the out-of-phase (imaginary) component
# that does no work on the resonator but varies its frequency is varied.

# Standard setup
import numpy as np
import numpy.random as rnd
import matplotlib.pyplot as plt
import os
base_path = os.path.join(os.path.dirname(__file__), "..")
os.chdir(base_path)

import common
print_flag = 1
plot_helper = common.PlotHelper(print_flag)

# User parameters
magReal = 1
numTrials = 1e3
std_error = 0.1
num_angles = 91
angle_range = [0, 90]

phaseRange = np.linspace(angle_range[0], angle_range[1], num_angles)
magImag = np.tan(np.deg2rad(phaseRange))*magReal

meanMag = np.zeros(num_angles)
stdMag = np.zeros(num_angles)
meanAngle = np.zeros(num_angles)
stdAngle = np.zeros(num_angles)

for idx, val in enumerate(phaseRange):
    magRealNoisy = magReal + std_error*rnd.randn(numTrials,1)
    magImagNoisy = magImag[idx] + std_error*rnd.randn(numTrials,1)
    angleNoisy = np.rad2deg(np.arctan(magImagNoisy/magRealNoisy))

    meanMag[idx] = np.mean(magRealNoisy)
    stdMag[idx] = np.std(magRealNoisy)

    meanAngle[idx] = np.mean(angleNoisy)
    stdAngle[idx] = np.std(angleNoisy)

fig = plt.figure(figsize = (12,5))


plt.subplot(221)
plt.plot(phaseRange, meanMag)
plt.ylabel('Magnitude ($\mu$)')
plt.ylim(0.99, 1.01)
plt.xlim(angle_range)

plt.subplot(222)
plt.plot(phaseRange, stdMag)
plt.ylabel('Magnitude ($\sigma$)')
plt.ylim(0.09, 0.11)
plt.xlim(angle_range)

plt.subplot(223)
plt.plot(phaseRange, meanAngle)
plt.xlabel('Phase [$^\circ$]')
plt.ylabel('Phase ($\mu$)')
plt.ylim(0, 90)
plt.xlim(angle_range)

plt.subplot(224)
plt.plot(phaseRange, stdAngle)
plt.xlabel('Phase [$^\circ$]')
plt.ylabel('Phase ($\sigma$)')
plt.ylim(0, 6)
plt.xlim(angle_range)

plot_helper.print_plot('images/phaseDeviation')

plt.show()
