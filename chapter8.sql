/*Rozdzia� 8 - J�zyk manipulacji danymi DML


INSERT ALL
    
INTO PRACOWNICY VALUES(260, 'ADAMSKI', 'ASYSTENT', NULL, to_date('2014-09-10','yyyy-mm-dd'), 1500, NULL, 10)

INTO PRACOWNICY VALUES(270, 'NOWAK', 'ADIUNKT', NULL, to_date('1990-05-01','yyyy-mm-dd'), 2050, 540,20)

SELECT 1 FROM DUAL;



SELECT * FROM PRACOWNICY WHERE ID_PRAC IN (250, 260, 270);

---------------------------------------------------------------


UPDATE PRACOWNICY

SET 
PLACA_POD = PLACA_POD + PLACA_POD * 0.10,
 
    PLACA_DOD =  COALESCE(PLACA_DOD, PLACA_DOD + PLACA_DOD * 0.20, 100)



WHERE ID_PRAC IN (250,260, 270);



SELECT * FROM PRACOWNICY WHERE ID_PRAC IN (250, 260, 270);

------------------------------------------------------------------

INSERT INTO ZESPOLY VALUES (60, 'BAZY DANYCH', 'PIOTROWO 2');

SELECT * FROM ZESPOLY WHERE ID_ZESP = 60;



UPDATE PRACOWNICY
 
SET
 ID_ZESP = (SELECT ID_ZESP FROM ZESPOLY WHERE NAZWA = 'BAZY DANYCH')

WHERE ID_PRAC IN (250, 260, 270);


SELECT * FROM PRACOWNICY WHERE ID_ZESP = 60;


UPDATE PRACOWNICY
    
SET
 ID_SZEFA = (SELECT ID_PRAC FROM PRACOWNICY WHERE NAZWISKO LIKE 'MORZY')

WHERE ID_ZESP = 60;


SELECT * FROM PRACOWNICY WHERE ID_SZEFA = (SELECT ID_PRAC FROM PRACOWNICY WHERE NAZWISKO LIKE 'MORZY');



DELETE FROM PRACOWNICY  
WHERE ID_ZESP = 60;


DELETE FROM ZESPOLY WHERE ID_ZESP = 60;



WITH 
    
SREDNIA AS (SELECT AVG(PLACA_POD) AS s, ID_ZESP FROM PRACOWNICY GROUP BY ID_ZESP)

SELECT NAZWISKO, PLACA_POD, s * 0.10 AS PODWYZKA

FROM PRACOWNICY JOIN SREDNIA ON PRACOWNICY.ID_ZESP = SREDNIA.ID_ZESP

ORDER BY NAZWISKO;



UPDATE PRACOWNICY
    
SET 
PLACA_POD = PLACA_POD + (SELECT AVG(PLACA_POD) FROM PRACOWNICY p JOIN ZESPOLY z ON p.ID_ZESP = z.ID_ZESP);