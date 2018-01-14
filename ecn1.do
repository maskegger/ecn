* Commenting in Stata

* There are several common and useful ways to insert comments into Stata documents

*1. The very useful "*".  I don't think I need say more.

*2. You can comment out a section of text by starting it with

/* and ending it with */

di "This" /* form of commenting can be quite useful because it */ " can appear within a command!"

/*

or
extend 
across
many
lines

*/

*3.
di "There "  /*
 */ "is also a " /*
 */ "useful way " /*
 */ "of using comments " /*
 */ "to continue lines in Stata " /*
 */ "though I prefer a slightly " ///
 "different " ///
 "form of comment (///). " ///
 "Which comments out the " ///
 "end of a line."
 