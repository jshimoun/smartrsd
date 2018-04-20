# import relevant libraries here
import numpy as np
import matplotlib.pyplot as plt
import scipy as sp
from scipy import interpolate
import math

# Initializations
l = 1.2
den = 2700
r = 0.1
mass = math.pi*r**2*l*den
mee = 40
ree = 0.2
mtot = mee + mass + 36
delTheta = math.pi/4
t = np.arange(2,10,0.01)
#print(mtot)


# Moments of Inertia
Igrap = 1/12*mass*(l/2)**2
Iee = 2/5*mee*ree**2
Ijoint = 6.63e-4
Ibase = Ijoint + Igrap + mass*l/2**2 + Iee + mee*(l+r)**2

# lambda function
Torque = lambda time: Ibase * 2*delTheta/(time**2)
trqs = Torque(t)
badt = []
badT = []
badt2 = []
badT2 = []
for i,val in enumerate(trqs):
	if val > 10:
		badt.append(t[i])
		badT.append(val)
	if  t[i] > 5:
		badt2.append(t[i])
		badT2.append(val)

#print('time with T = 10: ',np.amax(badt), 'Torque with time = 5 :', np.amax(badT2))
fig = plt.figure()
ax = fig.add_subplot(111)
plt.plot(t,trqs,'g')
plt.plot(badt,badT,'r')
plt.plot(badt2,badT2,'r')
fs = 20
#ax.xaxis.get_major_ticks()
for tick in ax.xaxis.get_major_ticks():
	tick.label.set_fontsize(fs)
for tick in ax.yaxis.get_major_ticks():
	tick.label.set_fontsize(fs)
plt.ylabel('Torque Required (N-m)', fontsize = fs)
plt.xlabel('Time to 45$^\circ$ Angle', fontsize = fs)
plt.title('Torque vs Time', fontsize = fs)
plt.show()

#inp = float(input('time? '))

def tool(time):
	trq = Torque(time)
	trq = str(trq)
	print('Torque required = ' + trq)
	
def tool2(trq2):
	time = np.sqrt(Ibase*2*delTheta/trq2)
	print(time)
	
trqInp = float(input('torque? '))
tool2(trqInp)

#tool(inp)