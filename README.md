
[Tablice tak wiem, za w ch*j duże (sam do siebie) TY CHORY POJ*BIE!]

Witam

Mam przyjemnośc przedstawić Panśtwu projekt Diamond Truck, który został edytowany wiele razy.
Na początku chciałbym podziękować dla:
- Sulfur'a > Design panelu
- oraz w części dla Cruzzer'a > Wklejka kilku skryptów z internetu (;_;)

Jest to edycja pwTRUCK [*], wiadomości zostały nieco zmienione wizualnie przez Cruzzer'a.
Wachałem się czy wstawiać 12 tysięcy linijek kodu do internetu, lecz zdecydowałem, że tak będzie najlepiej.
Ten gamemode wędruje niestety po kilku osobach i nie wiem do czego są one w stanie zrobić, najbardziej obawiam się
zmiany autora lub go zatuszowanie co w jednym przypadku tak niestety się chyba stało.

Gamemode oraz panel pisałem samodzielnie, ze stażem 1,5 roku w PAWN. Jest to mój pierwszy OBSZERNY projekt.
Proszę, powstrzymaj się od wszelakich komentarzych typu "Ale ścierwo" tylko powiedz co Cię natchnęło na ten negatywny komentarz i co proponujesz
zrobić w związku z tym. Od razu wiem, optymalizacja do bani :v Lecz działa :)
Co jakiś czas będę może aktualizował gamemode (poprawki itd).
Prosiłbym o zachowanie praw autorskich... Proszę, bądź człowiekiem. Włożyłem w ten projekt wiele godzin, niemal całe wakacje, byś teraz mógł
korzystać z tego systemu w miarę łatwo.

Zamieszczam na dole wszelakie instrukcje:

ZALECAM ZACZĄĆ OD PODPIĘCIA PANELU

>> Podpinanie panelu
1. Wrzuć pliki na serwer WWW.
2. Zainportuj do bazy danych (przez phpmyadmin) plik diamondpawno.sql
3. Znajdź w plikach panelu config.php
4. Skonfiguruj go do bazy danych. (hasło ip itd)

>> Włączenie serwera
Jeżeli pominałeś krok z panelem, wróć do niego... Potrzebne Ci będą tabele z bazy danych
1. Wrzuć do folderu z plikami serwerowymi folder plugins
1a Skonfiguruj server.cfg (gamemode ustaw na diamond)
1b W dolonym miejscu (server.cfg) dopisz linijkę plugins oraz...
Jeżeli masz system operacyjny Linux - plugins sscanf.so mysql.so streamer.so (dodaj dodatkowo plik libmysql do glownego katalogu!!!!)
Jeżeli masz system operacyjny Windows - plugins sscanf mysql 
Jeżeli masz inny system operacyjny - zgaś monitor, schowaj się pod biurko i policz do ~
2. Konfigurujemy w gamemode polaczenie (#define HOST itd)
3. Wchodzimy na serwer, rejestrujemy się i możemy zacząć grać :)

>> Nadawanie uprawnień H@
1. Wejdź do bazy danych (phpmyadmin)
2. Wejdz do tabeli `users`
3. Znajdź swój nickname, edytuj i wpisz w polę leveladmin liczbę 6 (Właściciel)

>> Dodawanie siebie do firmy/frakcji
1. Utwórz nową firmę/frakcję w tabeli `company`
2. Wejdz w tabelę `employess`
3. Dodaj nowy rekord edytując tam dane (id pomiń)
3a UID >> Unikalny Indyfikator Danych, przypisany do każdego konta (odpowiada kolumnie id w `users`)
3b company >> podaj id firmy/frakcji z tabeli `company`
3c range >> ranga (0 stażysta 1 - pracownik 2 - Zawodowy Kierowca 3 - Kierownik 4 - Prezes)
3d earned >> zarobione pieniądze na firmę/frakcję (NIE ZMIENIAĆ, USTAWIĆ 0 !!!!) [Automatyczne]
4. Zedytuj swoje konto w tabeli `users` i wpisz w `team` id firmy/frakcji do której się dodałeś!

Licencja #diamondtruck:
The MIT License (MIT)

Copyright (c) 2015 kapiziak

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
