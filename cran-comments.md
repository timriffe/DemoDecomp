This is a first release of the DemoDecomp package, which has so far only been available on github under the name DecompHoriuchi.

## Test environments
* Ubuntu 14.04.3 LTS, R version 3.4.0
* win-builder on x86_64-w64-mingw32 (64-bit)
  * R version 3.5.1 (2018-07-02)
  * R Under development (unstable) (2018-08-07 r75080)
  * R version 3.4.4 (2018-03-15)
* via devtools::rhub()
  * Windows Server 2008 R2 SP1, R-devel, 32/64 bit
  * Ubuntu Linux 16.04 LTS, R-release, GCC
  * Fedora Linux, R-devel, clang, gfortran
* R travis-ci Ubuntu 14.04.5 LTS.
  * R version 3.4.4 (2017-01-27)
  * R version 3.5.0 (2017-01-27)
  * R Under development (unstable) (2018-08-08 r75089)
* App-veyor
  * i386-w64-mingw32/i386 (32-bit)

## R CMD check results
all of the above were OK and returned
0 errors | 0 warnings | 1 notes 

NOTE: 
1) Maintainer: ‘Tim Riffe <tim.riffe@gmail.com>’
New submission

This is in order.

2) Possibly mis-spelled words in DESCRIPTION:
  Andreev (8:232)
  Horiuchi (8:117)
  Pletcher (8:140)
  Shkolnikov (8:241)
  Wilmoth (8:127)
these are all OK

## Comments from Uwe Ligges
 * Is there some reference about the method you can add in the Description field in the form Authors (year) <doi:.....>? (done)
 * We see most of your examples are wrapped in \sontrun{}. Why?
   * I put plotting code inside \dontrun{}. Important decomposition code gets executed, also added \dontshow{} for tests to make sure code running as expected. Added example to other main decomposition function, stepwise_replacement().

Many thanks
