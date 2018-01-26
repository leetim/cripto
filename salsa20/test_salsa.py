from salsa import Salsa

s = Salsa(20)
for i in s([5 if i%4==0 else 0 for i in range(32)]):
    print i
