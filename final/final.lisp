(defun is-strange(x)
(and (> (mod x 3) 0) 
     (> (mod x 5) 0) 
     (> (mod x 7) 0) 
     t))

(defun strange-sum (current_number total)
  (if (= current_number 5000)
    total
    (strange-sum (+ current_number 1)
      (if (is-strange current_number)
        (+ total current_number)
        total))))