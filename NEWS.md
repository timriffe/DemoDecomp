# Changes with version 1.14.2 
* horiuchi() documentation updated
* new argument `components` allows far faster `horiuchi()` computations for complex decomposition problems where results are destined to be aggregated anyway. For example, if computations require single ages but results are only meany to be communicated in 10-year age groups. See examples.

# Changes with version 1.14.1 
* DESCRIPTION updated to use Authors@R field properly

# Changes with version 1.14.0 
*  vector names now passed to `func()` in all three decomposition methods, as well as appended to output.

# Changes with version 1.12.0
*  `ltre()` method added, including numerical derivative backup.
