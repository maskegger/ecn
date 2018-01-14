*Stata Programming Basics - Macros

* Macros are an extremely useful tool in Stata and essential to any kind of complex programming.

* They fulfill multiple functions at the same time.

* Primarily they are used as variable value holders (scalars or text).

* That is if you forget the definition of how stata defines a variable for a second and think of the algebraic definition of a variable instead then you will understand what I am talking about.

* Imaging you want to know what c is equal to where: a + b = c and a=123 and b=-234.

* In stata you could make a column vector called "a" and a column vector called "b" and a:

* Observe:
clear
set obs 1

gen a=123
gen b=-234

gen c=a+b
sum

* Thus c is equal to -111

* This approach can be useful at times but is obviously overkill especially if you have  a lot of observations.

* An alternative approach would be (using locals):

local a=123
local b=-234
local c=`a'+`b'
display `c'

* Or
global a=123
global b=-234
global c=$a+$b
display $c

*  You can see that the three methods above produce the same results.

* What is the difference between a global and a local you may wonder:

* Well a local is a temporary variable that is only defined with the current environment (do file or program or shell)

* So if you were to run the first 40 lines of this code then stopped and reran the following separately.

* You would find that the global still displays the results of c while the local displays nothing because in effect the local has already forgotten what c was.
display `c'
display $c

* In generally you can approach locals and globals however you want.

* Globals are often useful for debugging since they retain their values yet because they are global they can more easily have name conflicts.

* In general it is best to use locals whenever possible and to use macros when locals are not possible.

* As you may have noticed the display command is extremely useful since it allows one to easily display the value of macros local or global.

* The following command:
macro list

* Also lists the values of macros however it is only of limited use since by the time you may want to know what the value of a particular local is it is already wiped from the memory.

* Macros can be defined three different ways.

* Macros can take on numeric values as observed previously:
global a=123
global b=-234
global c=$a+$b
display "c=$c"

* Macros can take on string values
global a="123"
global b="-234"
global c="$a $b"
display "c=$c"

* Macros can take on stata list values
global a 123
global b -234
global c $a $b
display "c= $c =" $a $b

* This lists can be very long and are often extremely helpful.
* Imagine you have 100 variables named variable_1 variable_2 variable_3 ... variable_99 variable_100
* And you want a list of all 100 of them in order to recode all of their values simultaneously.

* First define and empty global
global var_list
  * Let's imagine that we did not know better and tried to do this with a string macros as well.
global var_string=""

* For forvalues (see stata-programming-basics-forvalues)
forv i=1/100 {
  * So this is first saying that global varlist is equal to the current value of global varlist as well as a new element.
  global var_list $var_list variable_`i'
  global var_string="$var_string variable_`i'"

  * Notice the `i' used in the for loop is a local macro
}

* Now lets see what we have
di "$var_list"
di "$var_string"

* We can see that the string variable which has a low maximum number of characters is quickly exhausted while the macros list can easily become quite long.

* In addition to holding very lists Macro can hold quite about any single line command or partial command.

* When stata encounters a indicator of a macro $xyz or `xyz' it searches its active environment for it, if it does not find it then it ignores it like it never existed.

* For example:

di "Hello, what follows is a really big undefined macro [`helljdsaflksadlkfadsjfldsaflkadsflkasjdfldsaflkadsflkdsajflkadsf'] which is effectively invisible!"

* Though it might seem strange right now the ability of macros to take on commands can be extremely useful.

* For example, imagine that every time you open up a new file you want to do a number of commands.

* Such as recode (.=-9999) and display summary statistics.

* One way of doing this (not the only way) would be through globals

global a1 recode price (.=-9999)
global a2 sum
global a3 *left blank for future changes
global a4 *left blank for future changes

sysuse auto, clear
$a1
$a2
$a3
$a4

* I have actually not done that much with using macros in this way but there is some potential.

* In general, I find it more effective to write my own little programs to do repetitive commands.

* Finally the last concept I will discuss is the use of macros to refer to macros.

* Image that we would like to discover the contents of globals a1-a4 without having to write them out individually

* One way of doing this would be:

forv i=1/4 {
  di "${a`i'}"
}

* Likewise you could call all four macros the same way

forv i=1/4 {
  ${a`i'}
}

* The key is the {}.

* It tells stata to evaluate the macros within the brackets before evaluating that is outside of the brackets.

* The same can be done with globals as well:

forv i=1/4 {
  gl i=`i'
  di "${a$i}"
}

* Or locals in a similar manner were the brackets are not neccesary because the locals already have an inherent definition of what is inside the local.

* Ie `everything_inside_the_local'

* For example:

forv i=1/4 {
  gl i=`i'
  local a`i'="${a$i}"
  di "$`a`i''"
}

* In general it is good to be aware of how to use brackets with globals even if you do not intend to recursively refer to them.

* This is because Stata can only guess (have specific rules) for when a global name is done.

* But adding brackets always makes such an ending clear.

* For example,

global pay=100

di "I would like to be paid ${pay}dollars"

* Maybe this is not the best example but you will find that knowing how to use brackets can be extremely helpful.

****** Finally I will go over a couple of common uses of macros

**** WARNING: THE FOLLOWING CODE WILL NOT WORK ON YOUR SYSTEM WITHOUT MODIFICATIONS

* At the beginning of a do file people often change the working directory with the command

cd "c:/my_current_directory"

* This allows people to easy target files and folders since all of the commands will assume that the files are in the working directory unless otherwise indicated.

* For example:
use "my_favorite_data.dta"
* will look in  "C:my_current_directory" for "my_favorite_data.dta" which could have been alternatively written:

use "c:/my_current_directory/my_favorite_data.dta"

* An alternative might be to set a global:

gl mydir "c:/my_current_directory"

* Then the command could read:

use "${mydir}/my_favorite_data.dta"

* This is obviously not as clean as just changing the current directory.

* However, if you had multiple directory that you switched between or saved to then globals could be preferred.

* For example:
gl mydir1 "c:/my_current_load_directory"
gl mydir2 "c:/my_current_save_directory"

use "${mydir1}/my_favorite_data.dta"
save "${mydir2}/my_favorite_data.dta"

* That is it for now, however I could go on much more since macros are one of the most essential tools in Stata programming.