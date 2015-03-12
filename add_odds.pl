%addOdds(N, 0) :- N>= 20.
% addOdds(N, Sum) :- N < 20, M is N+2, addOdds(M, SumM), Sum is SumM + N.

isOdd(N) :- 1 is mod(N, 2).

addOdds(N, 0) :- N>= 20.
addOdds(N, Sum) :- N < 20, isOdd(N), M is N+1, addOdds(M, SumM), Sum is SumM + N.

addOdds(N, Sum) :- N < 20, \+ isOdd(N), M is N+1, addOdds(M, SumM), Sum is SumM.

printSeries(N) :- N<0.
printSeries(N) :- N >= 0, print(N), nl, M is N-1, printSeries(M).

getLength([], 0).
getLength([H|T], N) :- getLength(T, M), N is 1 + M.

myReverse([], []).
myReverse([H|T], X) :- myReverse(T,Y), append(Y, [H], X).
