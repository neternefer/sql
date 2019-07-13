--1. Wyświetl nazwiska, etaty, numery zespołów i nazwy zespołów wszystkich pracowników
SELECT NAZWISKO, ETAT, ZESPOLY.ID_ZESP, NAZWA
FROM PRACOWNICY JOIN ZESPOLY ON
    PRACOWNICY.ID_ZESP = ZESPOLY.ID_ZESP
ORDER BY NAZWISKO;

--2. Wyświetl wszystkich pracowników z ul. Piotrowo 3a. Uporządkuj wyniki według nazwisk pracowników
SELECT NAZWISKO, ETAT, ZESPOLY.ID_ZESP, ADRES
FROM PRACOWNICY JOIN ZESPOLY ON
    PRACOWNICY.ID_ZESP = ZESPOLY.ID_ZESP
WHERE ADRES LIKE '%PIOTROWO%'
ORDER BY NAZWISKO;

--3. Wyświetl nazwiska, miejsca pracy oraz nazwy zespołów tych pracowników, których miesięczna pensja
--przekracza 400. Wynik uporządkuj wg nazwisk pracowników
SELECT NAZWISKO, ADRES, NAZWA
FROM PRACOWNICY JOIN ZESPOLY ON 
    PRACOWNICY.ID_ZESP = ZESPOLY.ID_ZESP
WHERE PLACA_POD > 400
ORDER BY NAZWISKO;

--4. Dla każdego pracownika wyświetl jego nazwisko, płacę podstawową, etat, kategorię płacową i widełki
--płacowe, w jakich mieści się pensja pracownika. Wynik posortuj wg nazwisk i kategorii płacowych
--pracowników
SELECT NAZWISKO, PLACA_POD, ETATY.NAZWA AS KAT_PLAC, PLACA_MIN, PLACA_MAX
FROM PRACOWNICY 
    JOIN ETATY
        ON PLACA_POD BETWEEN PLACA_MIN AND PLACA_MAX
ORDER BY NAZWISKO;

--5. Wyświetl nazwiska i etaty pracowników, których rzeczywiste zarobki odpowiadają widełkom płacowym
--przewidzianym dla sekretarek. Wynik posortuj malejąco wg płac podstawowych pracowników
SELECT NAZWISKO, PLACA_POD, ETAT, ETATY.NAZWA AS KAT_PLAC, PLACA_MIN, PLACA_MAX
FROM PRACOWNICY 
    JOIN ETATY 
        ON PLACA_POD BETWEEN PLACA_MIN AND PLACA_MAX 
WHERE NAZWA = 'SEKRETARKA'
ORDER BY NAZWISKO;

--6. Wyświetl nazwiska, etaty, wynagrodzenia, kategorie płacowe i nazwy zespołów pracowników nie będących
--asystentami. Wyniki uszereguj zgodnie z malejącym wynagrodzeniem
SELECT NAZWISKO, PLACA_POD, ETAT, ETATY.NAZWA AS KAT_PLAC, ZESPOLY.NAZWA
FROM PRACOWNICY 
    NATURAL JOIN ZESPOLY 
    JOIN ETATY
        ON PLACA_POD BETWEEN PLACA_MIN AND PLACA_MAX
WHERE ETAT != 'ASYSTENT'
ORDER BY PLACA_POD DESC;

--7. Wyświetl poniższe informacje o tych pracownikach, którzy są asystentami lub adiunktami i których roczne
--dochody przekraczają 5500. Roczne dochody to dwunastokrotność płacy podstawowej powiększona o
--ewentualną płacę dodatkową. Ostatni atrybut to nazwa kategorii płacowej pracownika. Wynik posortuj wg
--nazwisk pracowników.
SELECT  NAZWISKO, ETAT, (PLACA_POD * 12) + COALESCE(PLACA_DOD, 0) AS ROCZNA_PLACA, ZESPOLY.NAZWA AS NAZWA, ETATY.NAZWA AS KAT_PLAC
FROM PRACOWNICY  
     RIGHT JOIN  ETATY
        ON PRACOWNICY.ETAT = ETATY.NAZWA
     JOIN ZESPOLY 
        ON PRACOWNICY.ID_ZESP = ZESPOLY.ID_ZESP
WHERE (PLACA_POD * 12) + COALESCE(PLACA_DOD, 0) > 5500 AND ETAT IN ('ASYSTENT', 'ADIUNKT')
ORDER BY NAZWISKO;

--8. Wyświetl nazwiska i numery pracowników wraz z numerami i nazwiskami ich szefów. Wynik posortuj wg
--nazwisk pracowników
SELECT p.NAZWISKO AS PRACOWNIK, p.ID_PRAC, s.NAZWISKO AS SZEF, p.ID_SZEFA
FROM PRACOWNICY p
    JOIN PRACOWNICY s
        ON p.ID_SZEFA = s.ID_PRAC
ORDER BY p.NAZWISKO;

--9. Zmodyfikuj powyższe zlecenie w ten sposób, aby było możliwe wyświetlenie pracownika WEGLARZ
--(który nie ma szefa).
SELECT p.NAZWISKO AS PRACOWNIK, p.ID_PRAC, IFNULL(s.NAZWISKO, '') AS SZEF, IFNULL(p.ID_SZEFA, '')
FROM PRACOWNICY p
    LEFT JOIN PRACOWNICY s
        ON p.ID_SZEFA = s.ID_PRAC
ORDER BY p.NAZWISKO;

--10. Dla każdego zespołu wyświetl liczbę zatrudnionych w nim pracowników i ich średnią płacę. Wynik posortuj
--wg nazw zespołów
SELECT ZESPOLY.NAZWA, COUNT(NAZWISKO) AS LICZBA, IFNULL(ROUND(AVG(PLACA_POD), 1), "") AS PLACA
FROM ZESPOLY 
    LEFT JOIN PRACOWNICY
       ON  ZESPOLY.ID_ZESP = PRACOWNICY.ID_ZESP
GROUP BY ZESPOLY.ID_ZESP
ORDER BY ZESPOLY.NAZWA;

--11. Dla każdego pracownika posiadającego podwładnych wyświetl ich liczbę. Wyniki posortuj zgodnie z
--malejącą liczbą podwładnych
SELECT s.NAZWISKO, COUNT(p.NAZWISKO) AS LICZBA
FROM PRACOWNICY p 
    JOIN PRACOWNICY s
        ON p.ID_SZEFA = s.ID_PRAC
GROUP BY s.NAZWISKO
ORDER BY LICZBA DESC;

--12. Wyświetl nazwiska i daty zatrudnienia pracowników, którzy zostali zatrudnieni nie później niż 10 lat po
--swoich przełożonych. Wynik uporządkuj wg dat zatrudnienia pracowników
SELECT p.NAZWISKO AS PRACOWNIK, p.ZATRUDNIONY, s.NAZWISKO AS SZEF, s.ZATRUDNIONY, YEAR(p.ZATRUDNIONY) - YEAR(s.ZATRUDNIONY) AS LICZBA
FROM PRACOWNICY p
    JOIN PRACOWNICY s
        ON p.ID_SZEFA = s.ID_PRAC
WHERE YEAR(p.ZATRUDNIONY) - YEAR(s.ZATRUDNIONY) <= 10
GROUP BY p.NAZWISKO
ORDER BY p.ZATRUDNIONY;
