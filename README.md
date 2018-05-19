# winlocker
Utilities for handling passwords in a secure fashion. Specific to **Windows** only.

## Overview
winlocker is a package for managing passwords (and other secure data). This helps
fill a security gap in many database related packages available for R. Most of
these packages use ODBC or JDBC, and require credentials as part of the
connection string. It is common, then, to find passwords left in plaintext as
part of the R script, or stored plaintext in files. Even entering a password at 
the console is less than secure, because it can be saved to the global environment
as part of the command history.

This package solves the problem by prompting the user for a password and saving
that password in an encrypted file. The password prompt comes in the form of a
masked pop-up window that bypasses the console all together. 

## Installation

```R

## The easiest way to get the dependency packages is just to install the whole tidyverse.
install.packages('tidyverse')

## Alternatively you can install them individually.
install.packages('devtools')
install.packages('magrittr')
install.packages('tibble')

## Then you can install winlocker from the IT&S Github.
devtools::install_git('https://githubdev.medcity.net/mye7180/winlocker')
```




