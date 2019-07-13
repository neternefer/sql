/*1. Wyświetl nazwiska i etaty pracowników pracujących w tym samym zespole co pracownik o nazwisku
--Brzeziński*/

SELECT NAZWISKO, ETAT 
FROM PRACOWNICY
WHERE ID_ZESP = (SELECT ID_ZESP FROM PRACOWNICY WHERE NAZWISKO = 'BRZEZINSKI');

/*2. Wyświetl poniższe dane o najdłużej zatrudnionym profesorze*/
SELECT NAZWISKO, ETAT, ZATRUDNIONY
FROM PRACOWNICY
WHERE  ZATRUDNIONY = (SELECT MIN(ZATRUDNIONY) FROM PRACOWNICY WHERE ETAT = 'PROFESOR');

/*3. Wyświetl najkrócej pracujących pracowników każdego zespołu. Uszereguj wyniki zgodnie z kolejnością
zatrudnienia*/
SELECT NAZWISKO, ZATRUDNIONY, ID_ZESP
FROM PRACOWNICY
WHERE ZATRUDNIONY IN (SELECT MAX(ZATRUDNIONY) FROM PRACOWNICY GROUP BY ID_ZESP)
ORDER BY ZATRUDNIONY;

/*4. Wyświetl informacje o zespołach, które nie zatrudniają pracowników. Podaj dwa rozwiązania:
(1) z podzapytaniem zwykłym i (2) z podzapytaniem skorelowanym*/
SELECT ID_ZESP, NAZWA, ADRES
FROM ZESPOLY
WHERE ID_ZESP NOT IN (SELECT ID_ZESP FROM PRACOWNICY);

/*5. Wyświetl poniższe informacje o pracownikach zarabiających więcej niż średnia pensja dla ich etatu*/
SELECT  NAZWISKO, PLACA_POD, ETAT
FROM PRACOWNICY p
WHERE PLACA_POD >  (SELECT AVG(PLACA_POD) FROM PRACOWNICY WHERE p.ETAT = PRACOWNICY.ETAT);
/*Użycie klauzuli WHERE zamiast GROUP pozwala uzyskać jeden wynik dla kolejnych osób zamiast całej tabeli średnich dla etatów*/

/*6. Wyświetl nazwiska i pensje pracowników którzy zarabiają co najmniej 75% pensji swojego szefa*/
SELECT NAZWISKO, PLACA_POD 
FROM PRACOWNICY p
WHERE p.PLACA_POD >= (SELECT PLACA_POD * 0.75 FROM PRACOWNICY s WHERE  p.ID_SZEFA = s.ID_PRAC);

/*7. Wyświetl nazwiska tych profesorów, którzy wśród swoich podwładnych nie mają żadnych stażystów*/
SELECT NAZWISKO 
FROM PRACOWNICY 
WHERE ID_PRAC NOT IN (SELECT ID_SZEFA FROM PRACOWNICY  WHERE  ETAT = 'STAZYSTA')
AND ETAT = 'PROFESOR';
/* Znajdujemy wszystkich szefów pracowników którzy są stażystami, szukamy id_prac których w tej grupie nie ma ale są profesorami*/

/*8. Wyświetl numer zespołu wypłacającego miesięcznie swoim pracownikom najwięcej pieniędzy*/
SELECT *
FROM (SELECT ID_ZESP, SUM(PLACA_POD) AS SUMA_PLAC FROM PRACOWNICY GROUP BY ID_ZESP) AS SUMY
ORDER BY SUMY.SUMA_PLAC DESC LIMIT 1;

SELECT ID_ZESP, SUM(PLACA_POD) AS SUMA_PLAC 
FROM PRACOWNICY 
GROUP BY ID_ZESP 
ORDER BY SUM(PLACA_POD) DESC LIMIT 1;

/*9. Wyświetl nazwiska i pensje trzech najlepiej zarabiających pracowników. Zastosuj podzapytanie*/
SELECT NAZWISKO, PLACA_POD
FROM PRACOWNICY
ORDER BY PLACA_POD DESC LIMIT 3;

/*10. Wyświetl dla każdego roku liczbę zatrudnionych w nim pracowników. Wynik uporządkuj zgodnie z liczbą zatrudnionych*/
SELECT YEAR(ZATRUDNIONY) AS ROK, COUNT(*) AS LICZBA
FROM PRACOWNICY
GROUP BY YEAR(ZATRUDNIONY)
ORDER BY LICZBA DESC;

/*11. Zmodyfikuj powyższe zapytanie w ten sposób, aby wyświetlać tylko rok, w którym przyjęto najwięcej pracowników*/
SELECT YEAR(ZATRUDNIONY) AS ROK, COUNT(*) AS LICZBA
FROM PRACOWNICY
GROUP BY YEAR(ZATRUDNIONY)
ORDER BY LICZBA DESC LIMIT 1;

/*12. Wyświetl poniższe informacje o tych pracownikach, którzy zarabiają mniej niż średnia płaca dla ich etatu*/
SELECT NAZWISKO, ETAT, PLACA_POD, NAZWA
FROM PRACOWNICY JOIN ZESPOLY ON PRACOWNICY.ID_ZESP = ZESPOLY.ID_ZESP
WHERE PLACA_POD < (SELECT AVG(PLACA_POD) FROM PRACOWNICY p WHERE PRACOWNICY.ETAT = p.ETAT);

/*13. Zmodyfikuj powyższe zapytanie w ten sposób, aby zamiast nazwy zespołu wyświetlać średnią płacę dla danego etatu*/
SELECT NAZWISKO, ETAT, PLACA_POD, (SELECT AVG(PLACA_POD) FROM PRACOWNICY s WHERE PRACOWNICY.ETAT = s.ETAT) AS 'AVG(X.PLACA_POD)'
FROM PRACOWNICY 
WHERE PLACA_POD < (SELECT AVG(PLACA_POD) FROM PRACOWNICY p WHERE PRACOWNICY.ETAT = p.ETAT)
ORDER BY ETAT;

/*14. Wyświetl nazwiska profesorów i liczbę ich podwładnych. Wyświetl tylko profesorów zatrudnionych na Piotrowie*/
SELECT s.NAZWISKO, COUNT(*) AS LICZBA
FROM PRACOWNICY p
    JOIN PRACOWNICY s 
        ON p.ID_SZEFA = s.ID_PRAC
    JOIN ZESPOLY 
        ON s.ID_ZESP = ZESPOLY.ID_ZESP
WHERE ADRES LIKE '%PIOTROWO%' AND s.ETAT = 'PROFESOR'
GROUP BY s.NAZWISKO;

/*15. Dla każdego profesora wyświetl jego nazwisko, średnią płacą w jego zespole i największą płacę w Instytucie. 
Zastosuj podzapytanie w klauzuli SELECT*/
SELECT NAZWISKO,
      (SELECT AVG(PLACA_POD) FROM PRACOWNICY p WHERE p.ID_ZESP = s.ID_ZESP) AS SREDNIA, 
      (SELECT MAX(PLACA_POD) FROM PRACOWNICY) AS MAKSYMALNA
FROM PRACOWNICY s
WHERE s.ETAT = 'PROFESOR';

/*16. Dla każdego pracownika wyświetl jego nazwisko oraz nazwę zespołu w którym pracuje dany pracownik.
Posłuż się podzapytaniem w klauzuli SELECT*/
SELECT p.NAZWISKO, 
       (SELECT NAZWA FROM ZESPOLY z WHERE p.ID_ZESP = z.ID_ZESP) AS ZESPOL
FROM PRACOWNICY p;


