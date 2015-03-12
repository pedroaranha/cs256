isTimeLord(doctor).
isTimeLord(timothy).
isSontaran(strax).
isDalek(davros).
isSilurian(vastra).
isCompanion(jenny).
isCyberman(bucket).
isWeepingAngel(liberty).

monster(X) :- isDalek(X).
monster(X) :- isSontaran(X).
monster(X) :- isCyberman(X).
monster(X) :- isSilurian(X).
monster(X) :- isWeepingAngel(X).
evil(X) :- isDalek(X).
scary(X) :- isWeepingAngel(X).
green(X) :- isSilurian(X).
isTimeWarrior(X) :- isTimeLord(X).
isTimeWarrior(X) :- isDalek(X).
hasNumFeet(X, 2) :- isTimeLord(X).
hasNumFeet(X, 2) :- isHuman(X).
hasNumFeet(X, 2) :- isCyberman(X).
hasNumFeet(X, 2) :- isSontaran(X).
hasNumFeet(X, 2) :- isSilurian(X).
hasNumFeet(X, 0) :- isWeepingAngel(X).
hasNumFeet(X, 0) :- isDalek(X).
isHuman(rose).
isHuman(X) :- isCompanion(X).
wants(X, genocide) :- isDalek(X).
wants(X, genocide) :- isCyberman(X).
wants(X, food) :- isWeepingAngel(X).
wants(X, violence) :- isSontaran(X).
