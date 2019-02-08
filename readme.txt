State Nicolae 333CC

    Detalii de implementare:
    
Partea FLEX:

    -  La intalnirea regexurilor pentru comentarii si declaratii de
    variabile nu se realizeaza nicio actiune.
    
    -  Dupa intalnirea unui tip de linie, am retinut in vectori pentru 
    a fi afisati in main dupa ordinea din cerinta.
    
    -  Dupa potrivirea cu un corp de metoda sau constructor,
    se vor face in continuare potriviri pe tipurile parametrilor (inclusiv
    '*', '[', ']' , numere si ',') si ii va concatena la vectorul care contine 
    corpul. La intalnirea unei paranteze inchise, se va concatena la sir si va 
    trece la urmatoarele parsari.
    
    - Pentru a diferentia constructorii de metode in ceea ce priveste
    intalnirea parametrilor (a prelucra vectorul de constructori sau cel 
    de metode), am folosit o variabila "type"(0 sau 1).
    
    - Sfasitul unei clase se determina prin intalnirea regexului " }; "
    care tine evidenta numarului de randuri gasite pentru fiecare tip
    (constructori, destructori, etc).
    
Main:
    
    - In main, se ia vectorul de constructori (care contine toti constructorii
    din fisier) si afisez numai cati au aparut in prima clasa. Retin acest numar
    la intalnirea "}:" ).
    Procedez la fel pentru restul tipurilor.
    
    - Pentru a gasi metodele suprascrise, am retinut numele metodei intr-un 
    vector "functions", populat la citirea metodelor din fisier.
    Am parcurs vectorul si am descoperit duplicatele (retinute in vectorul 
    "dups"), dupa care am sters toate  metodele care nu sunt duplicate din
    vectorul de metode(marcate cu "Wrong").
    Metodele suprascrise reprezinta ceea ce rezulta dupa stergere.
    
Alte detalii:
    - Fisierele de input se dau din linie de comanda.
    - Fisierele "in1", "in2" si "in3" sunt testele din cerinta.
    - Testele "example1" si "example2" sunt create de mine.
    - Comanda "make run" utilizeaza implicit fisierul "example1".
    