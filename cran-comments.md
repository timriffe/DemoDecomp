This is a second release of the DemoDecomp package, adding a new method, and some other minor fixes.

## Test environments
* Ubuntu 20.04.6 LTS, R version 4.4.1
* win-builder (Windows Server 2022 x64 )
  * R version 4.3.3
  * R Under development (2024-09-15 r87152 ucrt)
  * R version 4.4.1 
* via rhub::check_rhub()
  * linux Ubuntu 22.04.4, R-devel
  * macos 13.6.9, R-devel
  * macOS 14.6.1, R-devel
  * Microsoft Windows Server 2022 10.0.20348, R-devel

## R CMD check results
all of the above were OK and returned
0 errors | 0 warnings | 0 notes 

Except the win-builder, which notes for all cases: "Version jumps in minor (submitted: 1.14.0, existing: 1.0.1)". 

2) Possibly mis-spelled words in DESCRIPTION are all cited author names, OK

