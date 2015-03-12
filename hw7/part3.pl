%a
access(X) :- weapon_access(X), key_access(X), crime_access(X).

%b
weapon_access(X) :- stay(X,thursday,barts).
weapon_access(X) :- stay(X,wednesday,yard).
weapon_access(X) :- stay(X,thursday,tower).
weapon_access(X) :- stay(X,wednesday,tower).

%c
key_access(X) :- stay(X,monday,yard).
key_access(X) :- stay(X,tuesday,barts).
key_access(hudson).

%d
crime_access(X) :- stay(X,thursday,tower).
crime_access(X) :- stay(X,friday,tower).

%e
stay(donovan, monday, yard).
stay(donovan, tuesday, yard).
stay(donovan, wednesday, barts).
stay(donovan, thursday, yard).
stay(donovan, friday, tower).

stay(mycroft, monday, barts).
stay(mycroft, tuesday, barts).
stay(mycroft, wednesday, barts).
stay(mycroft, thursday, yard).
stay(mycroft, friday, tower).

stay(irene, monday, tower).
stay(irene, tuesday, barts).
stay(irene, wednesday, tower).
stay(irene, thursday, tower).
stay(irene, friday, tower).

stay(hudson, monday, tower).
stay(hudson, tuesday, barts).
stay(hudson, wednesday, barts).
stay(hudson, thursday, yard).
stay(hudson, friday, tower).

stay(mary, monday, tower).
stay(mary, tuesday, tower).
stay(mary, wednesday, yard).
stay(mary, thursday, tower).
stay(mary, friday, tower).

stay(anderson, monday, tower).
stay(anderson, tuesday, barts).
stay(anderson, wednesday, barts).
stay(anderson, thursday, tower).
stay(anderson, friday, tower).

stay(molly, monday, yard).
stay(molly, tuesday, yard).
stay(molly, wednesday, barts).
stay(molly, thursday, yard).
stay(molly, friday, tower).

stay(moriarty, monday, tower).
stay(moriarty, tuesday, yard).
stay(moriarty, wednesday, yard).
stay(moriarty, thursday, yard).
stay(moriarty, friday, tower).

%f
victim(sherlock).

motive(X) :- insane(X).
motive(X) :- poor(X).
motive(X) :- victim(Y), jealous(X,Y).

%g
insane(mary).
insane(moriarty).

%h
poor(hudson).
poor(donovan).
poor(moriarty).
poor(molly).

%i
jealous(X,Y) :- involved_with(X,Z), involved_with(Y,Z).

%j
involved_with(X,Y) :- involved(X,Y).
involved_with(X,Y) :- involved(Y,X).

%k
involved(sherlock, molly).
involved(molly, mycroft).
involved(sherlock, donovan).
involved(donovan, anderson).
involved(anderson, irene).
involved(irene, moriarty).
involved(mary, moriarty).
involved(mary, mycroft).

%l
murderer(X) :- motive(X), access(X).
