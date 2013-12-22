# Simulate the phase variation of an oscillator excited by thermal noise
# as a function of the steady-state phase. The in-phase (real) component of
# the drive amplitude is fixed and the out-of-phase (imaginary) component
# that does no work on the resonator but varies its frequency is varied.

import numpy as np
import matplotlib.pyplot as plt
from Constants import Constants

# Setup figure defaults
constants = Constants(printflag = 1)

magReal = 1
numTrials = 1e3
std_error = 0.1

phaseRange = np.linspace(0, 90, 91)
magImag = np.tan(np.deg2rad(phaseRange))*magReal

meanMag = np.zeros(91)
stdMag = np.zeros(91)
meanAngle = np.zeros(91)
stdAngle = np.zeros(91)

for idx, val in enumerate(phaseRange):
    magRealNoisy = magReal + std_error*np.random.randn(numTrials,1)
    magImagNoisy = magImag[idx] + std_error*np.random.randn(numTrials,1)
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

plt.subplot(222)
plt.plot(phaseRange, stdMag)
plt.ylabel('Magnitude ($\sigma$)')
plt.ylim(0.09, 0.11)

plt.subplot(223)
plt.plot(phaseRange, meanAngle)
plt.xlabel('Phase [$^\circ$]')
plt.ylabel('Phase ($\mu$)')
plt.ylim(0, 90)

plt.subplot(224)
plt.plot(phaseRange, stdAngle)
plt.xlabel('Phase [$^\circ$]')
plt.ylabel('Phase ($\sigma$)')
plt.ylim(0, 6)

constants.printPlot('images/phaseDeviation')

plt.show()
