(defun final(x)
(cond
  ((= (mod x 2) 0) (+ (collatz (/ x 2)) 1))
  ((> x 1) (+ (collatz (+ (* 3 x) 1)) 1 ))
  (t 0)))
