# by kadzielm 08.2022
import math
import numpy as np
import scipy
import control

def generate_kalman_gains():
    ts = 32e-6
    ti = 0.005 ** 0.5
    omega = 2*math.pi*50
    harmonics = [0]
    harmonics.extend(np.arange(1, 50, 2))

    cosine = np.zeros(len(harmonics))
    sine = np.zeros(len(harmonics))
    a = np.matrix([[1, 0], [0, 0]])
    for i in range(len(harmonics) - 1):
        sine[i + 1] = np.sin(omega * ts * harmonics[i + 1])
        cosine[i + 1] = np.cos(omega * ts * harmonics[i + 1])
        a_diag = np.matrix([[cosine[i + 1], -sine[i + 1]], [sine[i + 1], cosine[i + 1]]])
        a = scipy.linalg.block_diag(a, a_diag)

    q = np.matrix([[1, 0], [0, 1]])
    for i in range(len(harmonics) - 1):
        q_diag = np.matrix([[1, 0], [0, 1]])
        q = scipy.linalg.block_diag(q, q_diag)
    r = (ti/ts) ** 2
    h = np.zeros([1, len(harmonics) * 2])
    for i in range(len(harmonics)):
        h[0, 2 * i] = 1
    pp = control.dare(a.T, h.T, q, r)
    k_riccati = pp[0] @ h.T @ np.linalg.inv(h @ pp[0] @ h.T + r)

    f = open("Mem1_K.mem", "w+")
    for i in range(int(len(k_riccati) / 2)):
        f.write(float_to_mem(cosine[i]) + " //cosine " + str(harmonics[i]) + " harmonic [" + str(cosine[i]) + "] \n")
        f.write(float_to_mem(sine[i]) + " //sine " + str(harmonics[i]) + " harmonic [" + str(sine[i]) + "] \n")
        f.write(float_to_mem(k_riccati[i * 2]) + " //gain x1 " + str(harmonics[i]) + " harmonic " + str(k_riccati[i * 2]) + " \n")
        f.write(float_to_mem(k_riccati[i * 2 + 1]) + " //gain x2 " + str(harmonics[i]) + " harmonic " + str(k_riccati[i * 2 + 1]) + " \n")
    for i in range(512 - len(k_riccati) * 2):
        f.write("000000000\n")

def generate_resonant_gains():
    ts = 8e-6
    omega = 2*math.pi*50
    harmonics = np.arange(1, 50, 2)
    L_conv = 200e-6
    gain = 11 * L_conv * np.pi / ts /omega
    compensation2 = 0

    cosine = np.zeros(len(harmonics))
    sine = np.zeros(len(harmonics))
    cosineC = np.zeros(len(harmonics))
    sineC = np.zeros(len(harmonics))
    for i in range(len(harmonics)):
        sine[i] = np.sin(omega * ts * harmonics[i])
        cosine[i] = np.cos(omega * ts * harmonics[i])
        sineC[i] = np.sin(omega * ts * harmonics[i] * compensation2)
        cosineC[i] = np.cos(omega * ts * harmonics[i] * compensation2)


    f = open("Mem1_R.mem", "w+")
    for i in range(int(len(harmonics))):
        f.write(float_to_mem(cosine[i]) + " //cosineA " + str(harmonics[i]) + " harmonic [" + str(cosine[i]) + "] \n")
        f.write(float_to_mem(sine[i]) + " //sineA " + str(harmonics[i]) + " harmonic [" + str(sine[i]) + "] \n")
        temp = gain/harmonics[i]*(cosine[i]-1)
        f.write(float_to_mem(temp) + " //cosineB " + str(harmonics[i]) + " harmonic [" + str(temp) + "] \n")
        temp = gain/harmonics[i]*sine[i]
        f.write(float_to_mem(temp) + " //sineB " + str(harmonics[i]) + " harmonic [" + str(temp) + "] \n")
        f.write(float_to_mem(cosineC[i]) + " //cosineC " + str(harmonics[i]) + " harmonic [" + str(cosineC[i]) + "] \n")
        f.write(float_to_mem(sineC[i]) + " //sineC " + str(harmonics[i]) + " harmonic [" + str(sineC[i]) + "] \n")

    for i in range(512 - len(harmonics) * 6):
        f.write("000000000\n")

def generate_resonant_grid_gains():
    ts = 8e-6
    omega = 2*math.pi*50
    harmonics = np.arange(1, 50, 2)
    L_conv = 200e-6
    gain = 11 * L_conv * np.pi / ts /omega
    compensation2 = 0

    cosine = np.zeros(len(harmonics))
    sine = np.zeros(len(harmonics))
    cosineC = np.zeros(len(harmonics))
    sineC = np.zeros(len(harmonics))
    for i in range(len(harmonics)):
        sine[i] = np.sin(omega * ts * harmonics[i])
        cosine[i] = np.cos(omega * ts * harmonics[i])
        sineC[i] = np.sin(omega * ts * harmonics[i] * compensation2)
        cosineC[i] = np.cos(omega * ts * harmonics[i] * compensation2)


    f = open("Mem1_RG.mem", "w+")
    for i in range(int(len(harmonics))):
        f.write(float_to_mem(cosine[i]) + " //CA " + str(harmonics[i]) + " harmonic [" + str(cosine[i]) + "] \n")
        f.write(float_to_mem(sine[i]) + " //SA " + str(harmonics[i]) + " harmonic [" + str(sine[i]) + "] \n")
        f.write(float_to_mem(cosine[i]-1) + " //GCB " + str(harmonics[i]) + " harmonic [" + str(cosine[i]-1) + "] \n")
        f.write(float_to_mem(sine[i]) + " //GSB " + str(harmonics[i]) + " harmonic [" + str(sine[i]) + "] \n")
        temp = gain/harmonics[i]*(cosine[i]-1)
        f.write(float_to_mem(temp) + " //CCB " + str(harmonics[i]) + " harmonic [" + str(temp) + "] \n")
        temp = gain/harmonics[i]*sine[i]
        f.write(float_to_mem(temp) + " //CSB " + str(harmonics[i]) + " harmonic [" + str(temp) + "] \n")
        f.write(float_to_mem(cosine[i]) + " //GCC " + str(harmonics[i]) + " harmonic [" + str(cosine[i]) + "] \n")
        f.write(float_to_mem(sine[i]) + " //GSC " + str(harmonics[i]) + " harmonic [" + str(sine[i]) + "] \n")
        f.write(float_to_mem(cosineC[i]) + " //CCC " + str(harmonics[i]) + " harmonic [" + str(cosineC[i]) + "] \n")
        f.write(float_to_mem(sineC[i]) + " //CSC " + str(harmonics[i]) + " harmonic [" + str(sineC[i]) + "] \n")

    for i in range(512 - len(harmonics) * 6):
        f.write("000000000\n")

def float_to_mem(float_data):
    int_data = int(float_data * (2 ** (36 - QMATH_SHIFT)))
    string = "{:09X}".format((int_data & 0xFFFFFFFFF), '09X')
    return string

QMATH_SHIFT = 1
generate_kalman_gains()
QMATH_SHIFT = 2
generate_resonant_gains()
generate_resonant_grid_gains()
