import numpy as np
import math

def jarrow_rudd(s, k, t, v, rf, cp, am=False, n=100):
    """Price an option using the Jarrow-Rudd binomial model.
    
    s : initial stock price
    k : strike price
    t : expiration time
    v : volatility
    rf : risk-free rate
    cp : +1/-1 for call/put
    am : True/False for American/European
    n : binomial steps
    """

    # Basic calculations
    h = t/n
    u = math.exp((rf - 0.5 * math.pow(v, 2)) * h + v * math.sqrt(h))
    d = math.exp((rf - 0.5 * math.pow(v, 2)) * h - v * math.sqrt(h))
    drift = math.exp(rf*h)
    q = (drift - d)/(u - d)

    # Process the terminal stock price
    stkval = np.zeros((n + 1, n + 1))
    optval = np.zeros((n + 1, n + 1))
    stkval[0, 0] = s
    for ii in range(1, n+1):
        stkval[ii, 0] = stkval[ii-1, 0] * u
        for jj in range(1, ii+1):
            stkval[ii,jj] = stkval[ii-1, jj-1] * d

    # Backward recursion for option price
    for jj in range(n+1):
        optval[n, jj] = max(0, cp * (stkval[n,jj] - k))
    for ii in range(n-1, -1, -1):
        for jj in range(ii + 1):
            optval[ii, jj] = (q * optval[ii+1, jj] +
                              (1 - q) * optval[ii + 1, jj + 1]) / drift
            if am:
                optval[ii, jj] = max(
                    optval[ii, jj], cp * (stkval[ii, jj] - k))

    return optval[0, 0]