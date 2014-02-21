#!/usr/bin/python
import os
from subprocess import *

# We need to have tsuprem4 in our path and setup the LM license info
os.system("source /afs/ir/class/ee/synopsys/tcad/tcad.cshrc")

# Perform the simulation. Run tsuprem4 in a subprocess
# See: http://docs.python.org/library/subprocess.html#module-subprocess
p = Popen("tsuprem4 predep.supr", shell=True, stdout=None)
sts = os.waitpid(p.pid, 0)

# Conver the output .ps file to a .jpg
p = Popen("convert test.ps foobar.jpg", shell=True, stdout=None)
sts = os.waitpid(p.pid, 0)
