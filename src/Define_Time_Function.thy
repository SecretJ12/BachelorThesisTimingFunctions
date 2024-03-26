(*
Author: Jonas Stahl

Automatic definition of running time functions from HOL functions
following the translation described in Section 1.5, Running Time, of the book
Functional Data Structures and Algorithms. A Proof Assistant Approach.
*)

theory Define_Time_Function
  imports Main
  keywords "time_fun" :: thy_decl
    and    "time_function" :: thy_goal
    and    "time_definition" :: thy_goal
    and    "equations"
    and    "time_0" :: thy_decl
begin

ML_file Define_Time_0.ML
ML_file Define_Time_Function.ML

declare [[time_prefix = "T_"]]

text \<open>The pre-defined functions below are assumed to have constant running time.
In fact, we make that constant 0.
This does not change the asymptotic running time of user-defined functions using the
pre-defined functions because 1 is added for every user-defined function call.

Note: Many of the functions below are polymorphic and reside in type classes.
The constant-time assumption is justified only for those types where the hardware offers
suitable support, e.g. numeric types. The argument size is implicitly bounded, too.

The constant-time assumption for \<open>(=)\<close> is justified for recursive data types such as lists and trees
as long as the comparison is of the form \<open>t = c\<close> where \<open>c\<close> is a constant term, for example \<open>xs = []\<close>.\<close>

time_0 "(+)"
time_0 "(-)"
time_0 "(*)"
time_0 "(/)"
time_0 "(div)"
time_0 "(<)"
time_0 "(\<le>)"
time_0 "Not"
time_0 "(\<and>)"
time_0 "(\<or>)"
time_0 "Num.numeral_class.numeral"
time_0 "(=)"

end