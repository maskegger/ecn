*Fun with Macros

* Stata can use macros in a manner that can be very creative.

* One use could be in a manner similar to that of functions in R.
* If we would like to find the value of y at different levels of x where y is defined as y=x^2

local x = 1

* This immediately evaluates the value of y
local y = `x'^2

di "`y' = " `y'

* Thus the following display will be the same as the previous one despite x changing in value
local x = 2
di "`y' = " `y'

* If on the other hand, we specify y as the following:
local y = "\`x'^2"

local x = 1
di "`y' = " `y'
local x = 2
di "`y' = " `y'

* Then thw two different displays are different because y is waiting to evaluate the x until the display command.

* We can do this with multiple locals
local z = "100/(\`y')"

local x = 1
di "`z' = " `z'
local x = 2
di "`z' = " `z'

* Globals work in an identical fassion
global a = "(\`z')^(\`x') - \`y'"

local x = 1
di "$a = " $a

local x = 2
di "$a = " $a

global b = "(\$a)*cos(\$a)"

local x = 1
di "$b = " $b

local x = 2
di "$b = " $b

# R uses functions in a standard manner for programmers
y = function(x) x^2
z = function(x) 100/y(x)
a = function(x) z(x)^x - y(x)
b = function(x) a(x)*cos(a(x))

y(1); y(2)
z(1); z(2)
a(1); a(2)
b(1); b(2)
# Produces the same results as above