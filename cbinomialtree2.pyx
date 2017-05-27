import numpy as np

cimport numpy as np
cimport cython

cdef extern from "math.h" nogil:
    double exp(double)
    double sqrt(double)
    double pow(double, double)
    double fmax(double, double)

def jarrow_rudd(double s, double k, double t, double v,
                double rf, double cp, int am=0, int n=100):
    """Price an option using the Jarrow-Rudd binomial model.
    
    s : initial stock price
    k : strike price
    t : expiration time
    v : volatility
    rf : risk-free rate
    cp : +1/-1 for call/put
    am : 1/0 for American/European
    n : binomial steps
    """

    cdef double h, u, d, drift, q
    cdef int ii, jj, mm
    cdef np.ndarray[np.double_t, ndim = 2] stkval = np.zeros((n + 1, n + 1))
    cdef np.ndarray[np.double_t, ndim = 2] optval = np.zeros((n + 1, n + 1))

    # Basic calculations
    h = t/n
    u = exp((rf - 0.5 * pow(v, 2)) * h + v * sqrt(h))
    d = exp((rf - 0.5 * pow(v, 2)) * h - v * sqrt(h))
    drift = exp(rf*h)
    q = (drift - d)/(u - d)

    # Process the terminal stock price
    stkval[0, 0] = s
    for ii in range(1, n+1):
        stkval[ii, 0] = stkval[ii-1, 0] * u
        for jj in range(1, ii+1):
            stkval[ii,jj] = stkval[ii-1, jj-1] * d

    # Backward recursion for option price
    for jj in range(n+1):
        optval[n, jj] = fmax(0, cp * (stkval[n,jj] - k))
    for mm in range(n):
        ii = n-mm-1
        for jj in range(ii+1):
            optval[ii, jj] = (q * optval[ii+1, jj] +
                              (1 - q) * optval[ii + 1, jj + 1]) / drift
            if am==1:
                optval[ii, jj] = fmax(
                    optval[ii, jj], cp * (stkval[ii, jj] - k))

    return optval[0, 0]