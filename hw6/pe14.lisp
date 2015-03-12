(defun collatz(x)
(cond
  ((= (mod x 2) 0) (+ (collatz (/ x 2)) 1))
  ((> x 1) (+ (collatz (+ (* 3 x) 1)) 1 ))
  (t 0)))
 
(defun longest_collatz (n)
  (let ((max nil)
  (win 0))
    (loop
       :for i from 2 upto n
       :do (let ((len (collatz i)))
       (if (> len win)
     (setf max i
           win (+ len 1)))))
    (multiple-value-list (values win max))
    ))