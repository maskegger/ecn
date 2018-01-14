* Stata Programming Basics - forvalues - or "forv" for short

* The following code tells stata to count form 1 to 20 looping through the code n the brackets { ... }

* forv i=1(1)20 { 
* is the same as:
* forv i=1/20 { 
* the (1) indicates increment of 1.  A (2) would indicate an increment of 2. Such as 1 3 5 7 9 .. 17 19

forv i=1(2)20 {
  di "Hello World - `i'"
}

sysuse auto, clear

* Generate 10 variables which are copies of price
forv i=1/10 {
  generate price_`i' = price
}

* Imagine you want to run a seperate OLS regression for each set of turn radiuses between 31 and 51 with +-5 ft.

forv i=31/51 {
  reg  price mpg rep78 headroom trunk weight foreign if turn >= `i'-3 & turn <= `i'+3
}

* Finanally let's imagine that you would like to calculate the sum product of 5 ys
* y1*y2 + y1*y3 + ... y1*y5 + y2*y2 + ... y5*y4

* I will show three ways to do this:

* first let us make 5 ys

forv i=1/5 {
  generate y`i'=`i'
}

* The direct way of doing this is to set up a nested loop:
local repcount=0
gen ycross_a=0
forv i=1/5 {
  forv ii=1/5 {
    local repcount=`repcount'+1
    if `i'!=`ii' replace ycross_a=ycross_a+y`i'*y`ii'
  }
}
di "`repcount' repetitions"

* However this is slightly inefficient because there is some symetry in the calculation because we know that y2*y3 = y3*y2.
* So we can set up the nested loop so that it only needs to calculate one side of this process.
* Thus the original 25 repetitions (5 x 5) is reduced to (15). 
* This is because there are 5 loops in which the sums are skipped.
* So really we have 5^2 - 5 or (5^2 - 5)/2.
* This might seem trivial but it is just a matter of scale.
* If there was 30 variables for which this calculation was to be made then things might not be so easy.
*  30^2 - 30 or (30^2 - 30)/2 repetitions can create not trivial differences in processing time.
local repcount=0
gen ycross_b=0
forv i=1/5 {
  forv ii=1/`i' {
    local repcount=`repcount'+1
    if `i'!=`ii' replace ycross_b=ycross_b+y`i'*y`ii'
  }
}
* Finally we need double the value of ycross_b in order to make up for us only doing half the repetitions in which there is a value added.
replace ycross_b=ycross_b*2
di "`repcount' repetitions"

* An indirect way of doing this is to take the sum of all ys: (y1+y2+y3+y4+y5)^2-(y1^2+y2^2+...+y5^2)
gen ysum = y1+y2+y3+y4+y5
gen ysum2 = ysum^2
gen ysum_y2 = y1^2+y2^2+y3^2+y4^2+y5^2
gen ycross_c = ysum2-ysum_y2

sum ycross*
* As we can see there are many ways to skin a cat.
* Loops are a powerful tool but a little bit of algebra can often go a long way as well.