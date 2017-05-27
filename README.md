# OptionPricing
Binomial pricing module

Implements the the Cython example found in this paper: <br>
IMPLEMENTING OPTION PRICING MODELS USING PYTHON AND CYTHON by Sanjiv Das and Brian Granger. <br>
JOURNAL OF INVESTMENT MANAGEMENT, Vol. 8, No. 4, (2010), pp. 1–12 <br>
http://srdas.github.io/Papers/cython.pdf

Requires C++ compiler.  For Python 3.6.0 on 64-bit Windows, I used Visual C++ 2015 Build Tools with 8.1 SDK.
http://landinghub.visualstudio.com/visual-cpp-build-tools

I use PyCharm.  The standard install did not make the SDK headers and libraries available.  I had to add the INCLUDE and LIB environment variables:
* INCLUDE=C:\Program Files (x86)\Windows Kits\8.1\Include\shared
* LIB=C:\Program Files (x86)\Windows Kits\8.1\Lib\winv6.3\um\x64

Python.org keeps a list of Windows compilers for the various versions of the Setup package and Python versions.
https://wiki.python.org/moin/WindowsCompilers
