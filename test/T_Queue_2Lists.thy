theory T_Queue_2Lists
  imports "HOL-Data_Structures.Define_Time_Function" "HOL-Data_Structures.Queue_2Lists"
begin

declare [[time_prefix = "T'_"]]

text \<open>Helper functions\<close>
define_time_fun itrev
define_time_fun tl

text \<open>Define timing function\<close>
define_time_fun norm
define_time_fun enq
define_time_fun deq
define_time_fun first
define_time_fun is_empty


text \<open>Proove equality\<close>
lemma itrev: "T'_itrev xs ys = T_itrev xs ys"
  by (induction xs arbitrary: ys) auto

theorem norm: "T'_norm q = T_norm q"
  by (cases q) (auto simp: itrev)

theorem "T'_enq a q = T_enq a q"
  apply (cases q)
  using T'_tl.elims by (auto simp: norm)

lemma tl: "T'_tl xs = T_tl xs"
  by (induction xs) auto

theorem "T'_deq q = T_deq q"
  by (cases q) (auto simp: norm tl)

theorem "0 < length fs \<Longrightarrow> T'_first (fs,rs) = 0"
  by (cases fs) auto

theorem "T'_is_empty q = 0"
  by (cases q) auto

end