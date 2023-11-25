theory Test
  imports "TimingFunction"
begin

chapter \<open>Definition on example\<close>

text \<open>The following function sums up all integers from 0 to n\<close>
fun f :: "nat \<Rightarrow> nat" where
  "f 0 = 0"
| "f (Suc n) = Suc n + f n"

text \<open>It should be translated into the following timing function\<close>
fun t_f :: "nat \<Rightarrow> nat" where
  "t_f 0 = 1"
| "t_f (Suc n) = t_f n + 1"

text \<open>Hereby we run through the following steps:
\<E>\<lbrakk>f 0 = 0\<rbrakk>
= (T_f 0 = \<T>\<lbrakk>0] + 1)
= (T_f 0 = 1 + 1)
\<leadsto> (T_f 0 = 1)
and
\<E>\<lbrakk>f (Suc n) = Suc n + f n\<rbrakk>
= (T_f (Suc n) = \<T>\<lbrakk>Suc n + f n\<rbrakk> + 1)
= (T_f (Suc n) = 1 + \<T>\<lbrakk>Suc n\<rbrakk> + \<T>\<lbrakk>f n\<rbrakk> + 1)
= (T_f (Suc n) = 1 + 1 + \<T>\<lbrakk>f n\<rbrakk> + 1)
= (T_f (Suc n) = 1 + 1 + T_f n + \<T>\<lbrakk>1\<rbrakk> + 1)
= (T_f (Suc n) = 1 + 1 + T_f n + 1 + 1)
= (T_f (Suc n) = T_f n + 4)
\<leadsto> (T_f (Suc n) = T_f n + 1)\<close>

text \<open>The same function should be generated with the following command\<close>
define_time_fun f
lemma "t_f n = T_f n"
  by (induction n) auto

text \<open>Example proof (Conversion still TODO)\<close>
lemma "T_f n = Suc n"
  by (induction n) simp+

text \<open>Also a non asymptotic version can be created\<close>
fun g :: "nat \<Rightarrow> nat" where
  "g 0 = 0"
| "g (Suc n) = Suc n + g n"
define_time_fun g

lemma "T_g x = 1 + x"
  by (induction x) auto

text \<open>The command should work for all input types\<close>
fun len :: "'a list \<Rightarrow> nat" where
  "len [] = 0"
| "len (_#xs) = Suc (len xs)"
define_time_fun len

lemma "T_len xs = Suc (length (xs))"
  by (induction xs) auto

text \<open>An also multiple inputs and different output types\<close>
fun itrev :: "'a list \<Rightarrow> 'a list \<Rightarrow> 'a list" where
  "itrev [] ys = ys"
| "itrev (x#xs) ys = itrev xs (x#ys)"
define_time_fun itrev

lemma "T_itrev xs ys = 1 + length xs"
  by (induction xs arbitrary: ys) auto

text \<open>Used functions of the same theory should be converted automatically\<close>
fun itrev' :: "'a list \<Rightarrow> 'a list \<Rightarrow> 'a list" where
  "itrev' [] ys = ys"
| "itrev' (x#xs) ys = itrev' xs (x#ys)"
fun Itrev' :: "'a list \<Rightarrow> 'a list" where
  "Itrev' xs = itrev' xs []"
define_time_fun Itrev'
value "T_Itrev' [a, b, c]"
lemma T_itrev': "T_itrev' xs ys = 1 + length xs"
  by (induction xs arbitrary: ys) auto
lemma "T_Itrev' xs = 2 + length xs"
  by (simp add: T_itrev')

text \<open>If conditions should be handled accordingly\<close>
fun is_odd :: "nat \<Rightarrow> bool" where
  "is_odd 0 = False"
| "is_odd (Suc n) = (if is_odd n then \<not> (is_odd n) else \<not> (is_odd n))"
fun t_is_odd :: "nat \<Rightarrow> nat" where
  "t_is_odd 0 = 1"
| "t_is_odd (Suc n) = 1 + (if is_odd n then t_is_odd n else t_is_odd n) + t_is_odd n"
define_time_fun is_odd
lemma "T_is_odd n = t_is_odd n"
  by (induction n) auto

text \<open>Example proof\<close>
lemma "T_is_odd n = 2^(Suc n) - 1"
  apply (induction n)
  apply simp
  by (metis (no_types, opaque_lifting) Suc_1 Suc_eq_plus1_left Suc_mask_eq_exp T_is_odd.simps(2) add_Suc_right add_diff_cancel_left' diff_Suc_Suc mult_2 mult_Suc_right power.simps(2))

text \<open>More complex example for non asymptotic version\<close>
fun add :: "nat \<Rightarrow> nat \<Rightarrow> nat" where
  "add 0 y = y"
| "add (Suc x) y = add x (Suc y)"
fun mul where
  "mul 0 y = 0"
| "mul (Suc 0) y = y"
| "mul (Suc (Suc x)) y = add y (mul (Suc x) y)"
define_time_fun mul

text \<open>Example proof\<close>
lemma T_add: "T_add n m = 1 + n"
  by (induction n arbitrary: m) auto
lemma "T_mul (Suc n) m = 1 + n*(m+2)"
  by (induction n arbitrary: m) (auto simp: T_add)

text \<open>The command should define the timing function and prove termination with help of the original function\<close>
function terminationA :: "nat \<Rightarrow> nat \<Rightarrow> nat" where
  "terminationA a b = (if a < b then terminationA (Suc a) b else a)"
  by auto
termination
  by (relation "measure (\<lambda>(a,b). b - a)") auto
define_time_fun terminationA
lemma "T_terminationA 10 22 = 13"
  by simp

function terminationB :: \<open>nat \<Rightarrow> bool\<close> where
\<open>terminationB n = (if n \<le> 1 then True else if (Suc 1) dvd n then terminationB (n div (Suc 1)) else terminationB ((Suc (Suc 1)) * n + 1))\<close>
  by auto
termination sorry
define_time_0 "(div)"
define_time_0 "(dvd)"
define_time_0 "(*)"
define_time_0 "(\<le>)"
define_time_fun terminationB

text \<open>The command should handle case expressions\<close>
fun default :: "'a option \<Rightarrow> 'a \<Rightarrow> 'a" where
  "default opt d = (case opt of None \<Rightarrow> d | Some v \<Rightarrow> v)"
fun t_default :: "'a option \<Rightarrow> 'a \<Rightarrow> nat" where
  "t_default opt d = 1"
define_time_fun default
lemma "T_default opt d = t_default opt d"
  by auto

fun default' :: "'a option \<Rightarrow> 'a \<Rightarrow> 'a" where
  "default' opt d = (case opt of None \<Rightarrow> d | Some v \<Rightarrow> v)"
fun t_default' :: "'a option \<Rightarrow> 'a \<Rightarrow> nat" where
  "t_default' opt d = 1"
define_time_fun default'
lemma "T_default' opt d = t_default' opt d"
  by (auto split: option.split)

fun caseAdd :: "nat \<Rightarrow> nat \<Rightarrow> nat" where
  "caseAdd a b = (case a of 0 \<Rightarrow> b | Suc a' \<Rightarrow> Suc (caseAdd a' b))"
fun t_caseAdd :: "nat \<Rightarrow> nat \<Rightarrow> nat" where
  "t_caseAdd a b = 1 + (case a of 0 \<Rightarrow> 0 | Suc a' \<Rightarrow> t_caseAdd a' b)"
define_time_fun caseAdd
lemma "T_caseAdd a b = t_caseAdd a b"
  by (induction a) auto

fun caseAdd' :: "nat \<Rightarrow> nat \<Rightarrow> nat" where
  "caseAdd' a b = (case a of 0 \<Rightarrow> b | Suc a' \<Rightarrow> Suc (caseAdd' a' b))"
fun t_caseAdd' :: "nat \<Rightarrow> nat \<Rightarrow> nat" where
  "t_caseAdd' a b = 1 + (case a of 0 \<Rightarrow> 0 | Suc a' \<Rightarrow> t_caseAdd' a' b)"
define_time_fun caseAdd'
lemma "T_caseAdd' a b = t_caseAdd' a b"
  by (induction a) auto

text \<open>Edge case of reduced cases\<close>
fun edge_case :: "nat * nat \<Rightarrow> nat" where
  "edge_case n = (case n of (a, b) \<Rightarrow> add a b)"
define_time_fun edge_case

text \<open>Allow conversion of library functions\<close>
define_time_fun rev
lemma T_append_length: "T_append xs ys = Suc (length xs)"
  by (induction xs) auto
lemma "T_rev xs = \<Sum>{1..Suc (length xs)}"
  by (induction xs) (auto simp: T_append_length)

text \<open>Also allow definitions to be converted\<close>
definition wrapper where "wrapper a b = add a b"
define_time_fun wrapper


text \<open>Handle let expressions correctly\<close>
datatype dummyTree = Leaf | Node dummyTree dummyTree
fun dummy where "dummy T = T"
fun mirror :: "dummyTree \<Rightarrow> dummyTree" where
  "mirror Leaf = Leaf"
| "mirror (Node l r) =
    (let l' = mirror l in let r' = mirror r
    in dummy (Node r' l'))"
define_time_fun mirror

text \<open>Handle pattern matching in let\<close>
fun first :: "'a * 'b \<Rightarrow> 'a" where
  "first pair =
    (let (a,b) = dummy pair in dummy a)"
define_time_fun first

end