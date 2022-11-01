# 3. A felhasználói felület kialakítása

Utolsó módosítás ideje: 2022.10.31  
Kidolgozta: Rajacsics Tamás, Benedek Zoltán

## A gyakorlat célja

A gyakorlat célja egy látványos, gyors alkalmazásfejlesztés bemutatása, mely egyben megteremti a lehetőséget a Windows Forms fejlesztés alapjainak elsajátítására. Érintett témakörök (többek között):

- Windows Forms alkalmazásfejlesztés alapok
- Menük
- Dokkolás és horgonyzás
- SplitView
- TreeView
- ListView  

Kapcsolódó előadások: 3-4. előadás – Vastagkliens alkalmazások fejlesztése.

## Előfeltételek

A gyakorlat elvégzéséhez szükséges eszközök:

- Visual Studio 2022
- Windows 10 vagy Windows 11 operációs rendszer (Linux és macOS nem alkalmas)

## Bevezető

A Rapid Application Development (RAD) elve a fejlesztési idő lerövidítését célozza meg azáltal, hogy a fejlesztés során kész komponensekkel dolgozik, integrált fejlesztő környezetet (pl. Visual Studio) és sok automatizmust alkalmaz. Fontos ugyanakkor, hogy az automatizmusok ne szűkítsék be túlzottan a fejlesztő lehetőségeit és kellő rugalmasságot adjanak neki a rendszerek testre szabásában. A következő példákban látni fogjuk, miként alkalmas mindezekre a Windows Forms környezet.

A Window Forms alkalmazások legfontosabb koncepcióit a tárgy 3.-4. előadása ismerteti. Egy Windows Forms alkalmazásban az alkalmazásunk minden ablakának egy saját osztályt kell létrehozni, mely a beépített Form osztályból származik. Erre – tipikusan a Visual Studio designerével - vezérlőket helyezünk fel, melyek a Form osztályunk tagváltozói lesznek.

Tipp: a következő példákban számos generált (és emiatt hosszú) elnevezéssel fogunk találkozni. Programjaink megvalósításakor használjuk ki az automatikus kódkiegészítés (intellisense) nyújtotta lehetőségeket és ne kézzel gépeljük be az egyes elnevezéseket.

## ************ COMING SOON ***************