isStrange(N) :- 0 is mod(N, 3).
isStrange(N) :- 0 is mod(N, 5).
isStrange(N) :- 0 is mod(N, 7).

strangeSum(N, 0) :- N >= 5000.
strangeSum(N, Sum) :- N < 5000, isStrange(N), M is N+1, strangeSum(M, SumM), Sum is SumM.
strangeSum(N, Sum) :- N < 5000, \+ isStrange(N), M is N+1, strangeSum(M, SumM), Sum is SumM + N.
