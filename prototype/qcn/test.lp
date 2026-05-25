% Save this as test.lp
animal(cat).
animal(elephant).
animal(dog).

big_animal(A) :- animal(A), A > cat.
