# funzioni che servono per analysis.ipynb

# quando fai un .py usa questo per controllare... 
# Deve venire /opt/anaconda3/bin/python

# import sys
# print(sys.executable)

import numpy as np
from datetime import datetime
import math as math

# interpolation
from scipy.interpolate import interp1d # ma vaffanculo

def chi2(meas_values, exp_values, err_on_exp_values):
    return sum((meas_values - exp_values)**2/err_on_exp_values)

# Errore sistematico su R
def instr_err_R(R_value):
    if R_value <= 2e2:
        return 1e-2
    elif R_value <= 2e3:
        return 1e-1
    elif R_value <= 2e4:
        return 1e0
    elif R_value <= 2e5:
        return 1e1
    elif R_value <= 2e6:
        return 1e2
    elif R_value <= 2e7:
        return 1e3
    elif R_value <= 1e8:
        return 1e4
    else:
        return np.inf

# l'errore sistematico su T è costante
def instr_err_T(T_value): # IN NANOMETRI
    return 0.1

def quadsum(errors):
    return np.linalg.norm(errors)

def media_mobile(values, errors, finestra = 11):
    avg_values = np.convolve(values, np.ones(finestra)/finestra, mode='valid')
    avg_errors = np.sqrt(np.convolve(errors**2, np.ones(finestra), mode='valid')) / finestra
    return avg_values, avg_errors

def string_to_seconds(stringa_tempo):
    # decodifica se numpy passa la stringa in formato bytes (succede in vecchie versioni)
    if isinstance(stringa_tempo, bytes):
        stringa_tempo = stringa_tempo.decode('utf-8')
        
    t = datetime.strptime(stringa_tempo, "%H:%M:%S.%f")
    # Calcola i secondi totali dalla mezzanotte
    return t.hour * 3600 + t.minute * 60 + t.second + t.microsecond / 1e6

def assign_uncoupling_error(filename):

    R, T, R_times, T_times = np.loadtxt(
        filename, 
        skiprows=1,
        converters={2: string_to_seconds, 3: string_to_seconds},
        unpack=True
    )
    T = T*100 # in nm

    # Prima parte dei dati: indici per i quali R è OL
    ins_mask = (R>999999999)
    R_ins = R[ins_mask]
    T_ins = T[ins_mask]

    # Qui non c'è problema
    R_values_ins = R_ins # tutti costanti, 1000000000
    T_values_ins = T_ins
    R_err_ins = np.zeros_like(R_values_ins)
    T_err_ins = np.zeros_like(T_values_ins) # 0.0 perché è solo quello del disallineamento, che qui in pratica non c'è

    # Seconda parte dei dati: tutto il resto
    cond_mask = (R<999999999)
    R_c = R[cond_mask]
    T_c = T[cond_mask]
    R_times_c = R_times[cond_mask]
    T_times_c = T_times[cond_mask]

    # Creiamo la funzione di fit
    f_R = interp1d(R_times_c, R_c, kind='linear', fill_value="extrapolate")
    f_T = interp1d(T_times_c, T_c, kind='linear', fill_value="extrapolate")

    # Per ogni coppia di misure trova il tempo medio
    # e restituisci valori con errori
    avg_times = (R_times_c + T_times_c)/2
    R_values_c = f_R(avg_times)
    T_values_c = f_T(avg_times)
    R_err_c = 2*np.abs(R_values_c - R_c)
    T_err_c = 2*np.abs(T_values_c - T_c)

    # concatenali nei valori finali
    R_values = np.concatenate((R_values_ins, R_values_c))
    T_values = np.concatenate((T_values_ins, T_values_c))
    R_err = np.concatenate((R_err_ins, R_err_c))
    T_err = np.concatenate((T_err_ins, T_err_c))

    return R_values, R_err, T_values, T_err

# utilizzo: 
# R_values, R_err, T_values, T_err = assign_uncoupling_error('data/vetro_1_28_04.txt')

# print(f"Riga n° 2086: \n {R_values[2086]}±{R_err[2086]}\t{T_values[2086]}±{T_err[2086]}")

# Sembra funzioni...

def assign_err_RT(R_values, R_err, T_values, T_err):
    # calcola l'errore su RT a partire dai singoli propagando
    ...

def assign_error_RT2(R_values, R_err, T_values, T_err): 
    ...


# Queste due non le facciamo già quando usiamo il fit????

def assign_error_ohmic_fit(boh):
    # che assegni gli errori ai valori attesi per il fit ohmico
    ...

def assign_error_linear_fit(boh):
    # che assegni gli errori ai valori attesi per il fit lineare
    ...

### Da fare: 
# *. Continuare a fare gli errori, tipo di tutto; 
# *. Interpretare la roba del grain size!!!!