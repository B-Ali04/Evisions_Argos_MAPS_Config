-- Degree Level
 select distinct degc_code, degc_desc from rel_student_degree
 order by degc_desc

-- Exp Graduation Date
select distinct sgbstdn_exp_grad_date
 from sgbstdn
 where sgbstdn_exp_grad_date < sysdate
  order by sgbstdn_exp_grad_date desc