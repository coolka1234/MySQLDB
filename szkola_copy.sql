-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Maj 21, 2024 at 01:57 PM
-- Wersja serwera: 10.4.32-MariaDB
-- Wersja PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `szkola_copy`
--

DELIMITER $$
--
-- Procedury
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `Liczba dziewcząt i chłopców w klasach` ()   SELECT Klasy.Symbol AS Klasa, 
IFNULL(SUM(Uczniowie.Plec = 'K'),0) AS `Liczba dziewcząt`, 
IFNULL(SUM(Uczniowie.Plec = 'M'),0) AS `Liczba chłopców`
FROM Klasy 
LEFT JOIN Uczniowie ON Klasy.Symbol = Uczniowie.KlasaU
GROUP BY Klasy.Symbol$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Liczba uczniów w miastach` ()   SELECT Miasta.NazwaM, COUNT(Uczniowie.IdU) AS `Liczba uczniów`
FROM Miasta
LEFT JOIN Uczniowie ON Miasta.IdM = Uczniowie.Miasto
GROUP BY Miasta.NazwaM$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Nauczyciele zatrudnieni od 1 marca 2020` ()   SELECT *
FROM Nauczyciele
WHERE DZatr >= '2020-03-01'$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Spis nauczycieli i uczniów z symbolem` ()   SELECT Nauczyciele.Nazwisko, Nauczyciele.Imie AS Imię, Nauczyciele.IdN AS Nr, Nauczyciele.DUr AS `Data urodzenia`, 'N' AS Symbol 
FROM Nauczyciele
UNION 
SELECT Uczniowie.Nazwisko, Uczniowie.Imie, Uczniowie.IdU, Uczniowie.DUr, 'U' 
FROM Uczniowie
ORDER BY `Data urodzenia` DESC, Nazwisko, Imię$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Uczniowie wg ocen malejąco` ()   SELECT Uczniowie.Nazwisko, Uczniowie.Imie, Uczniowie.IdU, Przedmioty.NazwaP, Oceny.Ocena
FROM (Uczniowie INNER JOIN Oceny ON Uczniowie.IdU = Oceny.IdU) INNER JOIN Przedmioty ON Oceny.IdP = Przedmioty.IdP
ORDER BY Oceny.Ocena DESC, Uczniowie.Nazwisko, Uczniowie.Imie$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Uczniowie z danej klasy` (IN `KlasaU` VARCHAR(6))   SELECT Uczniowie.Nazwisko, Uczniowie.Imie, Uczniowie.IdU, Uczniowie.DUr, Uczniowie.Plec, Uczniowie.KlasaU, Miasta.NazwaM
FROM Miasta INNER JOIN Uczniowie ON Miasta.IdM = Uczniowie.Miasto WHERE
uczniowie.KlasaU = KlasaU ORDER BY Uczniowie.Nazwisko, Uczniowie.Imie$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Uczniowie z klas I-III` ()   SELECT Nazwisko, Imie, IdU, KlasaU
FROM Uczniowie
WHERE KlasaU LIKE 'I_' OR KlasaU LIKE 'II_' OR KlasaU LIKE 'III_'$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Uczniowie z klas II z miast na literę C-P` ()   SELECT Uczniowie.Nazwisko, Uczniowie.Imie, Uczniowie.IdU, Uczniowie.DUr, Uczniowie.Plec, Uczniowie.KlasaU, Miasta.NazwaM FROM Miasta INNER JOIN Uczniowie ON Miasta.IdM = Uczniowie.Miasto WHERE Uczniowie.KlasaU LIKE 'II_' AND (LEFT(Miasta.NazwaM, 1) >= 'C' AND LEFT(Miasta.NazwaM, 1) <= 'P') ORDER BY Uczniowie.Nazwisko, Uczniowie.Imie$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Wychowawcy klas` ()   SELECT Klasy.Symbol, Nauczyciele.Nazwisko, Nauczyciele.Imie, Nauczyciele.IdN, Nauczyciele.DZatr, Nauczyciele.DUr, Nauczyciele.Plec, Nauczyciele.Pensja, Nauczyciele.Pensum, Nauczyciele.Telefon, Nauczyciele.Premia
FROM Klasy
LEFT JOIN Nauczyciele ON Nauczyciele.IdN = Klasy.Wych
ORDER BY Klasy.Symbol$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `klasy`
--

CREATE TABLE `klasy` (
  `Symbol` varchar(6) NOT NULL,
  `Profil` varchar(30) NOT NULL,
  `Wych` int(11) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

--
-- Dumping data for table `klasy`
--

INSERT INTO `klasy` (`Symbol`, `Profil`, `Wych`) VALUES
('Ia', 'humanistyczny', 1),
('Ib', 'biologiczno-chemiczny', 2),
('Ic', 'geograficzny', 3),
('Id', 'fizyczno-informatyczny', 4),
('IIa', 'humanistyczny', 6),
('IIb', 'przyrodniczy', 5),
('IIc', 'ogólnokształcący', 7),
('IIIa', 'przyrodniczy', 0),
('IIIb', 'przyrodniczy', 11),
('IIIc', 'matematyczno-fizyczny', 10),
('IIId', 'ogólnokształcący', 0),
('IVa', 'humanistyczny', 0);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `miasta`
--

CREATE TABLE `miasta` (
  `IdM` int(11) UNSIGNED NOT NULL,
  `NazwaM` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `miasta`
--

INSERT INTO `miasta` (`IdM`, `NazwaM`) VALUES
(1, 'Wrocław'),
(2, 'Gorzów Wielkopolski'),
(3, 'Rzeszów'),
(4, 'Sokołów Małopolski'),
(5, 'Kędzierzyn-Koźle'),
(6, 'Świdnica'),
(7, 'Opole'),
(8, 'Elbląg'),
(9, 'Warszawa'),
(10, 'Gniezno'),
(11, 'Gdańsk'),
(12, 'Przemyśl'),
(14, 'Gdynia'),
(17, 'Brzeg'),
(18, 'Oława');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `nauczyciele`
--

CREATE TABLE `nauczyciele` (
  `IdN` int(11) NOT NULL,
  `Nazwisko` varchar(30) NOT NULL,
  `Imie` varchar(30) NOT NULL,
  `DZatr` date DEFAULT NULL,
  `DUr` date DEFAULT NULL,
  `Plec` varchar(1) DEFAULT NULL,
  `Pensja` decimal(10,2) DEFAULT NULL,
  `Pensum` int(11) DEFAULT NULL,
  `Telefon` varchar(15) DEFAULT NULL,
  `Premia` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

--
-- Dumping data for table `nauczyciele`
--

INSERT INTO `nauczyciele` (`IdN`, `Nazwisko`, `Imie`, `DZatr`, `DUr`, `Plec`, `Pensja`, `Pensum`, `Telefon`, `Premia`) VALUES
(1, 'Krzasewski', 'Jeremiasz', '2009-01-01', '1975-07-16', 'M', 4206.00, 210, '600450123', 20.00),
(2, 'Astaszewski', 'Franciszek', '2017-03-02', '1978-05-05', 'M', 3528.00, 150, '', 15.00),
(3, 'Astaszewski', 'Franciszek', '2016-03-03', '1992-11-05', 'M', 3468.00, 120, '829137012', 23.00),
(4, 'Kamila', 'Katarzyna', '1990-12-17', '1964-03-04', 'K', 5222.00, 240, '209381233', 17.00),
(5, 'Marzec', 'Malwina', '2007-03-03', '1989-08-08', 'K', 2.00, 150, '', 0.00),
(6, 'Astaszewski', 'Hubert', '2003-08-05', '1985-07-16', 'M', 0.00, 0, '239010321', 61.00),
(7, 'Frankowska-Rykas', 'Agnieszka', '2006-07-17', '1974-02-13', 'K', 4652.00, 180, '121938123', 10.00),
(8, 'Jaraś', 'Marcin', '2024-03-24', '2000-01-03', 'M', 3060.00, 120, '', 0.00),
(9, 'Domarczyński', 'Jerzy', '2024-03-20', '1999-01-12', '', 12366.00, 150, '981273012', 0.00),
(10, 'Kulczycki', 'Karol', '2018-04-12', '1997-12-01', 'M', 0.00, 300, '', 0.00),
(11, 'Oćwieja', 'Maria', '1988-01-12', '1965-07-04', 'K', 7345.00, 270, '092183303', 120.00),
(12, 'Januszewski', 'Tomasz', '2001-12-12', '1974-01-01', 'M', 5541.00, 90, '', 0.00),
(13, 'Roman', 'Marcin', '0000-00-00', '1984-08-01', 'M', 896.00, 90, '', 20.00),
(14, 'Kraus', 'Mariusz', '2000-05-02', '1971-06-04', 'M', 0.00, 600, '673210992', 400.00),
(15, 'Sydor', 'Renata', '2005-01-12', '1980-04-01', 'K', 5080.00, 0, '209838383', 23.00),
(16, 'Letkowska', 'Danuta', '2005-03-03', '1972-01-01', '', 3774.00, 60, '203810238', 10.00),
(17, 'Letkowska', 'Magdalena', '2008-12-01', '0000-00-00', 'K', 4327.00, 90, '238019923', 100.00),
(18, 'Podolak-Zając', 'Jolanta', '2022-08-26', '2001-06-15', 'K', 4080.00, 120, '338109283', 51.00),
(19, 'Sergiew', 'Tomasz', '0000-00-00', '1972-01-10', 'M', 65.00, 60, '', 0.00),
(20, 'Barć', 'Bartosz', '2003-08-27', '1983-12-13', 'M', 5222.00, 150, '208338098', 320.00);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `oceny`
--

CREATE TABLE `oceny` (
  `IdU` int(11) UNSIGNED NOT NULL,
  `IdP` int(11) UNSIGNED NOT NULL,
  `Ocena` decimal(10,1) NOT NULL,
  `DataO` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

--
-- Dumping data for table `oceny`
--

INSERT INTO `oceny` (`IdU`, `IdP`, `Ocena`, `DataO`) VALUES
(1, 3, 4.0, '2020-12-13'),
(1, 4, 3.0, '2020-01-01'),
(1, 8, 4.0, '2020-03-02'),
(3, 1, 5.0, '2022-06-12'),
(3, 2, 4.0, '2022-06-13'),
(3, 3, 4.0, '2022-06-14'),
(3, 4, 2.0, '2022-06-15'),
(3, 5, 5.0, '2022-06-11'),
(3, 6, 3.0, '2023-06-22'),
(3, 7, 4.0, '0000-00-00'),
(3, 8, 5.0, '2022-06-11'),
(3, 9, 3.0, '2022-06-22'),
(3, 10, 3.0, '2022-06-21'),
(3, 11, 4.0, '2022-06-22'),
(3, 12, 3.0, '2022-06-17'),
(3, 13, 5.0, '2022-06-18'),
(4, 4, 5.0, '2023-06-07'),
(4, 5, 3.0, '2020-05-02'),
(5, 5, 2.0, '2024-06-08'),
(5, 7, 3.0, '2019-03-06'),
(6, 1, 5.0, '2024-06-07'),
(7, 1, 4.0, '2023-06-08'),
(7, 3, 4.0, '2023-04-06'),
(9, 12, 2.0, '2022-08-07'),
(20, 6, 2.0, '2023-06-15'),
(44, 7, 3.0, '2022-05-08'),
(52, 2, 5.0, '0000-00-00'),
(52, 11, 4.0, '2023-01-01'),
(52, 13, 3.0, '2023-06-03'),
(60, 7, 4.0, '0000-00-00');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `przedmioty`
--

CREATE TABLE `przedmioty` (
  `IdP` int(11) UNSIGNED NOT NULL,
  `NazwaP` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

--
-- Dumping data for table `przedmioty`
--

INSERT INTO `przedmioty` (`IdP`, `NazwaP`) VALUES
(1, 'Fizyka'),
(2, 'Informatyka'),
(3, 'Matematyka'),
(4, 'Geografia'),
(5, 'Chemia'),
(6, 'Biologia'),
(7, 'Język angielski'),
(8, 'Język polski'),
(9, 'Język niemiecki'),
(10, 'Historia'),
(11, 'Wiedza o społeczeństwie');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `uczniowie`
--

CREATE TABLE `uczniowie` (
  `IdU` int(11) NOT NULL,
  `Nazwisko` varchar(30) NOT NULL,
  `Imie` varchar(30) NOT NULL,
  `DUr` date DEFAULT NULL,
  `Plec` varchar(1) DEFAULT NULL,
  `KlasaU` varchar(6) DEFAULT NULL,
  `Miasto` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

--
-- Dumping data for table `uczniowie`
--

INSERT INTO `uczniowie` (`IdU`, `Nazwisko`, `Imie`, `DUr`, `Plec`, `KlasaU`, `Miasto`) VALUES
(1, 'Kryska', 'Oliwia', '2003-07-05', 'K', 'Ib', 2),
(2, 'Kryska', 'Oliwia', '2003-06-06', 'K', 'IIb', 6),
(3, 'Kryska', 'Janina', '2004-01-11', 'K', '', 0),
(4, 'Ożóg', 'Kajetan', '2003-05-08', '', 'Id', 2),
(5, 'Bator', 'Marcin', '2003-06-12', 'M', 'Id', 0),
(6, 'Kuliński', 'Oskar', '0000-00-00', 'M', 'IIb', 9),
(7, 'Bukowińska', 'Marta', '2002-01-01', 'K', '', 1),
(8, 'Mędrek', 'Kinga', '2002-03-17', 'K', 'IIa', 10),
(9, 'TERECH', 'Rafał', '2003-06-18', 'M', 'Ic', 10),
(10, 'Nowak', 'Miłosz', '2003-06-05', 'M', 'Ia', 3),
(11, 'CZACHOR', 'Celina', '2002-01-01', '', 'IIa', 9),
(12, 'PAZDAN', 'Jan', '2002-03-02', 'M', 'IIa', 7),
(13, 'JER', 'Katarzyna', '2003-07-15', 'K', 'Ic', 2),
(14, 'Piwowar', 'Jolanta', '2001-03-04', 'K', '', 5),
(15, 'Słowik', 'Anna', '2001-01-29', 'K', 'IIIa', 5),
(16, 'Kusy', 'Wiktoria', '2002-01-21', 'K', 'IIa', 3),
(17, 'CIARACH', 'Wiktoria', '2003-01-23', 'K', 'IIb', 17),
(18, 'WRONA', 'Nikola', '2004-01-12', 'K', 'Id', 1),
(19, 'KOCÓJ', 'Dominik', '2003-08-18', 'M', 'Id', 0),
(20, 'Adamska', 'Łucja', '2004-03-01', 'K', 'IIIa', 12),
(21, 'Frankowska', 'Maria', '2003-08-17', 'K', 'IIc', 12),
(22, 'Żukowska', 'Grażyna', '2002-07-06', 'K', '', 0),
(23, 'Korbycka', 'Halina', '2004-07-07', 'K', 'Ia', 8),
(24, 'BUKSA', 'Adam', '2003-01-01', 'M', 'IIb', 7),
(25, 'Szymański', 'Sebastian', '2002-04-03', 'M', 'IIb', 10),
(26, 'Tracik', 'Eryk', '2002-12-04', 'M', 'Ia', 3),
(27, 'Muszka', 'Przemysław', '0000-00-00', 'M', 'IIc', 5),
(28, 'Boczar', 'Patryk', '2003-05-05', '', 'IIb', 2),
(29, 'Ożóg', 'Lena', '2003-07-05', 'K', 'Ia', 12),
(30, 'Zalwski', 'Piotr', '2004-08-17', 'M', 'Ia', 8),
(31, 'MATERNA', 'Magdalena', '2003-08-19', 'K', 'Ib', 3),
(32, 'MICHALSKA', 'Paulina', '2003-09-06', 'K', 'IIa', 5),
(33, 'Matuła', 'Wiktoria', '2004-01-04', 'K', 'IIa', 5),
(34, 'Gołdyn', 'Mikołaj', '0000-00-00', '', '', 0),
(35, 'Błazej', 'Weronika', '2003-03-08', 'K', 'Ib', 3),
(36, 'Walawender', 'Jan', '2003-12-12', '', 'Id', 3),
(37, 'Paź', 'Jan', '2004-12-27', 'M', 'Id', 7),
(38, 'Kloc', 'Kamil', '2001-10-05', 'M', 'IIc', 4),
(39, 'Kazań', 'Maciej', '2003-03-12', 'M', 'IIc', 9),
(40, 'Jarosz', 'Katarzyna', '2003-04-03', 'K', 'IIc', 8),
(41, 'Traczek', 'Urszula', '2003-09-01', 'K', 'Id', 7),
(42, 'Sitek', 'Maciej', '2004-12-13', 'M', 'Ic', 0),
(43, 'Gobol', 'Tomasz', '2003-01-02', 'M', 'Ic', 10),
(44, 'Kalasz', 'Iwo', '0000-00-00', '', '', 0),
(45, 'Kowal', 'Henryk', '0000-00-00', 'M', 'IIb', 9),
(46, 'Czyż', 'Ewa', '2003-11-06', 'K', 'IIb', 7),
(47, 'Kawaś', 'Mikołaj', '2001-06-01', 'M', 'IIa', 18),
(48, 'Krysz', 'Grzegorz', '2003-02-02', 'M', 'IIIa', 4),
(49, 'Mostkowiak', 'Martyna', '2004-04-07', 'K', 'Id', 1),
(50, 'Marszczek', 'Waleria', '2004-01-09', 'K', 'IIa', 1),
(51, 'Milska', 'Faustyna', '2003-04-30', 'K', 'IVa', 5),
(52, 'Banaś', 'Jerzy', '2003-07-31', 'M', 'IIb', 6),
(53, 'Boczar', 'Patrycja', '2002-08-31', 'K', 'Id', 8),
(54, 'Kłoda', 'Marcin', '2001-06-03', 'M', 'IIIa', 0),
(55, 'ŻYCZYŃSKI', 'Maksymilian', '2001-05-14', 'M', 'IIIc', 3),
(56, 'ŻYCZYŃSKA', 'Aleksandra', '2001-05-14', 'K', 'IIIb', 3),
(57, 'Wasyl', 'Marcin', '2001-09-23', 'M', 'IIIb', 7),
(58, 'Grzezik', 'Nikodem', '2001-10-21', 'M', 'IIIc', 10),
(59, 'Mika', 'Beata', '2002-07-08', 'K', 'IIc', 0),
(60, 'Okrasa', 'Nela', '2004-04-04', 'K', 'Ia', 9),
(61, 'Kuliberda', 'Laura', '2003-08-03', 'K', 'IIb', 3);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `uczy`
--

CREATE TABLE `uczy` (
  `IdN` int(11) UNSIGNED NOT NULL,
  `IdP` int(11) UNSIGNED NOT NULL,
  `IleGodz` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

--
-- Dumping data for table `uczy`
--

INSERT INTO `uczy` (`IdN`, `IdP`, `IleGodz`) VALUES
(2, 1, 1),
(2, 2, 5),
(2, 3, 5),
(2, 4, 5),
(2, 6, 1),
(2, 8, 3),
(2, 9, 1),
(2, 10, 1),
(2, 11, 5),
(2, 12, 3),
(2, 13, 3),
(3, 4, 2),
(3, 9, 3),
(4, 5, 2),
(4, 6, 8),
(4, 7, 10),
(4, 13, 5),
(5, 4, 10),
(5, 5, 8),
(5, 7, 2),
(5, 12, 10),
(7, 1, 5),
(7, 3, 5),
(7, 8, 2),
(7, 10, 10),
(7, 11, 1),
(7, 13, 2),
(9, 8, 10),
(11, 4, 20),
(13, 11, 10),
(13, 12, 10),
(14, 1, 3),
(14, 2, 3),
(14, 3, 11),
(19, 2, 5),
(19, 3, 25);

--
-- Indeksy dla zrzutów tabel
--

--
-- Indeksy dla tabeli `klasy`
--
ALTER TABLE `klasy`
  ADD PRIMARY KEY (`Symbol`);

--
-- Indeksy dla tabeli `miasta`
--
ALTER TABLE `miasta`
  ADD PRIMARY KEY (`IdM`);

--
-- Indeksy dla tabeli `nauczyciele`
--
ALTER TABLE `nauczyciele`
  ADD PRIMARY KEY (`IdN`);

--
-- Indeksy dla tabeli `oceny`
--
ALTER TABLE `oceny`
  ADD PRIMARY KEY (`IdU`,`IdP`);

--
-- Indeksy dla tabeli `przedmioty`
--
ALTER TABLE `przedmioty`
  ADD PRIMARY KEY (`IdP`);

--
-- Indeksy dla tabeli `uczniowie`
--
ALTER TABLE `uczniowie`
  ADD PRIMARY KEY (`IdU`);

--
-- Indeksy dla tabeli `uczy`
--
ALTER TABLE `uczy`
  ADD PRIMARY KEY (`IdN`,`IdP`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `miasta`
--
ALTER TABLE `miasta`
  MODIFY `IdM` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `nauczyciele`
--
ALTER TABLE `nauczyciele`
  MODIFY `IdN` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `przedmioty`
--
ALTER TABLE `przedmioty`
  MODIFY `IdP` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `uczniowie`
--
ALTER TABLE `uczniowie`
  MODIFY `IdU` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=63;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
