(defun fib (n)
	(if (<= n 0)
		'(1 1)
		(cons (+ (car (fib (- n 1))) (car (fib (-n 2)))) (fib (- n 1)))
	)

)