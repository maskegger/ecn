* Stata wildcards and shortcuts

* Wildcards are extremely useful.

* They can save a lot of time as well as create coding outcomes that are otherwise impossible or extremely difficult to otherwise wet up.

* Let us first generate a handful of variables to experiment on:

gl A c3a3aa a1 a2 a3 b2 b3 b4 c3 c4 c5 a3a3

clear
set obs 12

* This will loop through each element of the global A and generate corresponding variables.
foreach v in $A {
  gen `v'=rnormal()
}

* Now if we want to use only some of the variables with wildcards.
* A ? allows for one character to be wild
sum a?

sum ?3

* Sometimes we can use combinations of stars and ? to target specific groups of variables
sum ?3a*

* A star allows for any number of characters to be wild
sum a*

sum *

* We can also refer to variables through variable range specifications:

sum b2-c4