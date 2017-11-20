s = open("TheHacker7.txt").read()
ex = "".join(open("ex2.txt").read().lower().split("\n"))
alphabet = set("abcdifghijklmnopqrstuvwxyz0123456789 \\,.\"-?![]")

def change(s, src, to):
    return "".join([to if i == src else i for i in s])
def analise(s):
    return sorted([(-len(filter(lambda x: x == i, s)), i) for i in set(s)])
def word_analise(s, count):
    return analise(list(filter(lambda x: len(x) == count, s.split())))

s = change(s, " ", "U")
s = change(s, "]", "P")
s = change(s, "[", "?")
s = change(s, "\"", "G")
s = change(s, "5", " ")#X Z
s = change(s, "0", "E")
s = change(s, "d", "Z")
s = change(s, "2", "T")
s = change(s, "8", "H")
s = change(s, "w", "S")
s = change(s, "n", "J")
s = change(s, "4", "I")
s = change(s, "!", "A")
s = change(s, ".", "O")
s = change(s, "a", "Y")
s = change(s, "z", "D")
s = change(s, "m", "F")
s = change(s, "r", "L")
s = change(s, "p", "R")
s = change(s, "1", "M")
s = change(s, "6", "N")
s = change(s, "?", "W")
s = change(s, "c", "B")
s = change(s, "t", "\'")
s = change(s, "b", ",")
s = change(s, "s", "K")
s = change(s, "h", "C")
s = change(s, "j", "V")
s = change(s, "k", "Q")
s = change(s, "x", "\"")


ex_word_analise1 = word_analise(ex, 1)
s_word_analise1 = word_analise(s, 1)
ex_word_analise2 = word_analise(ex, 2)
s_word_analise2 = word_analise(s, 2)
ex_word_analise3 = word_analise(ex, 3)
s_word_analise3 = word_analise(s, 3)

ex_analise = analise(ex)
h = analise(s)

print "\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"
print ex_analise
print "\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"
print h
print "\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"
print ex_word_analise1
print "\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"
print s_word_analise1
print "\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"
print ex_word_analise2
print "\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"
print s_word_analise2
print "\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"
print ex_word_analise3
print "\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"
print s_word_analise3
print "\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"
print s
print "\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"
