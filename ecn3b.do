* Stata Coding Basics - foreach

* Stata has two types of for commands

* 1. is the forvalues commands which are used to loop through sets of numbers. (see previous post)

* 2. is the foreach command which has a different syntax and can loop through just about any other list of interest.

* For instance, lets imagine we have a list of variables we would like to create.

clear
set obs 100

foreach v in varA varB varC varD VarE VarF {
  gen `v' = rt(100)
}

* The v tells stata what the local that the foreach loop will use is called.

* The in after v tells Stata to take a discrete list of objects and loop through them.

* This list can use quotes to join items seperated by a space together.

foreach v in "varA varB" "varC varD" "VarE" VarF {
  di "The first value of `v' =" `v'
}
* Notice that there is no difference between "VarE" and VarF
* Also notice how the difference in how `v' outside of quotes and "`v'" within quotes behaves.

* Foreach loops can also use wildcards:

foreach v of varlist var* {
  di "The first value of `v' =" `v'
}
* Notice VarE and VarF are not displayed. 

* This is because Stata is case sensitive.

* We can make sure to loop through all of the variables through more general choice of wildcards.

foreach v of varlist ?ar* {
  di "The first value of `v' =" `v'
}

* Of course if we are going general with wildcards then we can do the following:
foreach v of varlist * {
  di "The first value of `v' =" `v'
}

* Note the "of varlist" is important.

* Otherwise Stata does not know what you are referring to with the wildcard.

* There are several other specifications that can take the place of varlist.

* I will go few a few briefly but I don't really see their value above what I have already mentioned.

* If we a global called A then we can loop through the elements of A via:

gl A "" "Time-$S_TIME" "" "Hello," "" "How are you `c(username)'?" "Do you like tuna fish?"

foreach v of global A {
  di `v' "`v'"
}

* However, an equally effective way of doing this would be:
foreach v in $A {
  di "`v'"
}

* This summarizes my thoughts and examples of foreach for now.

* It is an essential and efficient command for many circumstances.
