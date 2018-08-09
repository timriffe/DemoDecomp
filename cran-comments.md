This is a first release of the DemoDecomp package, which has so far only been available on github under the name DecompHoriuchi

## Test environments
* Ubuntu 14.04.3 LTS, R version 3.4.0
### via devtools::check_rhub():
* Windows Server 2008 R2 SP1, R-devel, 32/64 bit
* Ubuntu Linux 16.04 LTS, R-release, GCC
* Fedora Linux, R-devel, clang, gfortran
### via devtools::check_win*()
*  x86_64-w64-mingw32 (64-bit) R version 3.5.1 (2018-07-02)
### via devtools::rhub()
 * Windows Server 2008 R2 SP1, R-devel, 32/64 bit
 * Ubuntu Linux 16.04 LTS, R-release, GCC

## R CMD check results
all of the above were OK and returned
0 errors | 0 warnings | 0 notes 

except some had NOTE: 'new submission', which is true.
