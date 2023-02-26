---
authors: bzolka
---
# 6. Document-View architektúra

## A gyakorlat célja

A gyakorlat céljai:

- UML alapú tervezés és néhány tervezési minta alkalmazása
- A Document-View architektúra alkalmazása a gyakorlatban
- UserControl szerepének bemutatása Window Forms alkalmazásokban, Document-View architektúra esetén
- A grafikus megjelenítés elveinek gyakorlása Window Forms alkalmazásokban (`Paint` esemény, `Invalidate`, `Graphics` használata)

A kapcsolódó előadások és korábbi gyakorlatok anyaga:

- UML alapú modellezés (1. gyakorlat)
- Windows Forms alkalmazásfejlesztés
- Szoftverarchitektúrák (Document-View architektúra)

## Előfeltételek

A gyakorlat elvégzéséhez szükséges eszközök:

- Visual Studio 2022
- Windows 10 vagy Windows 11 operációs rendszer (Linux és macOS nem alkalmas)

## A gyakorlat menete

Az alábbiak szerint fogunk dolgozni:

- A feladat/célok rövid ismertetése: egy interaktív fonteditor (betűtípus-szerkesztő) megtervezése
- A kész alkalmazást futtatva a feladat (a kész alkalmazás működésének) ismertetése
- Az alkalmazás architektúrájának megtervezése (osztálydiagram elkészítése)
- A kész alkalmazás forráskódjának alapján néhány fontosabb forgatókönyv megvalósításának áttekintése

??? note "Megjegyzés gyakorlatvezetők számára"
    A gyakorlat elején töltsük le a kész alkalmazást. A hallgatók ekkor még ne töltsék le, ne ezt kattintgassák, majd csak a gyakorlat második részében. A gyakorlatvezetőknek viszont szüksége lesz rá, mert ennek segítségével történik a feladat bemutatása.

## 1. Feladat - A feladat ismertetése

Interaktív FontEditor (betűtípus szerkesztő) készítése, amelyben lehet szerkeszteni a karaktereket, és az aktuális betűkészlet alapján tetszőleges példaszöveg megjeleníthető. Az alkalmazás felhasználói felülete futás közben:

![A FontEditor alkalmazás felülete](images/fonteditor-app-intro.png)

A következő funkciókat kell támogatnia:

- Több betűtípus egyidejű szerkesztése. Ez egyes betűtípusok külön tab oldalakon szerkeszthetők (MDI – Multiple Document Interface).
- Új betűtípus a _File/New_ menüelem kiválasztásával hozható létre (meg kell adni a nevét).
- Ez egyes betűtípusok elmenthetők (_File/Save_), betölthetők (_File/Open_), és az aktuális dokumentum bezárható (_File/Close_). Ezek helye megvan az alkalmazásban, de nincsenek részleteiben implementálva (a függvények törzse nincs kitöltve – opcionális HF).
- A felhasználói felület felépítése
    - Az oldal tetején (Sample text) egy mintaszöveg adható meg, melyet az aktuális betűtípussal az alkalmazás megjelenít.
    - Az oldalak közepén egy karaktersáv található. Egy adott karakteren duplán kattintva alatta megjelenik egy, az adott karakterhez tartozó szerkesztőnézet.
    - Az oldal alján egymás mellett az eddig szerkesztésre megnyitott karakterek szerkesztőnézetei láthatók. Egy karakter többször is megnyitható szerkesztésre, ez esetben több szerkesztőnézet jön létre hozzá. Ennek az az értelme, hogy ugyanazt a karaktert különböző nagyítással is láthatjuk/szerkeszthetjük.
- A szerkesztőnézetek felépítése
    - Nagy része (eltekintve a felső sáv) a szerkesztőfelület, ahol fekete háttéren sárgával jelennek meg az aktív pixelek. Egy adott pixelen az egérrel kattintva a pixel invertálódik.
    - Bal felső sarokban a megjelenített karakter látható
    - ’c’ gomb: Clear, minden aktív pixelt töröl
    - ’+’ gomb: nagyítás
    - ’-’ gomb: kicsinyítés

Futtassuk az alkalmazást, és vizsgáljuk meg a működését a fentieknek megfelelően. Azt mindenképpen nézzük meg, hogy ha egy karakter szerepel a mintaszövegben, valamint többször megnyitjuk szerkesztésre, akkor **az egyik nézetben változtatva (egy pixelt invertálva) valamennyi nézete frissül**.

Az alkalmazás a kódmennyiség minimális értéken tartása érdekében minimalisztikus, pl. a hibakezelés nincs általánosságában kidolgozva, hiányoznak ellenőrzések. Ugyanakkor kódmegjegyzésekkel el van látva, mely segíti a kód utólagos megértését.

## 2. Feladat - Az alkalmazás megtervezése

A cél az, hogy lássuk, milyen folyamatot követve, milyen lépésekben dolgozunk, mikor milyen tervezői lépéseket kell meghoznunk. Törekedjünk oktatói és hallgatói részről is az interaktivitásra, közösen hozzuk meg a döntéseket.

Hozzunk létre egy új C# nyelvű „Window Form App” projektet (.NET 6-osat), legyen a neve FontEditor. Vegyünk fel egy osztálydiagramot: projekten jobb katt, _Add / New Item_, majd a megjelenő ablakban _Class Diagram_ kiválasztása, a neve maradhat az alapértelmezett. Állítsuk be, hogy a diagram mutassa majd a műveletek szignatúráit is (pl. jobb katt a háttéren, _Change Members Format / Display Full Signature_). A gyakorlat nagy részében ezt a diagramot fogjuk szerkeszteni.

A kész osztálydiagram a következő, eddig fogunk fokozatosan eljutni:

![ClassDiagram](images/ClassDiagram.png)

### Document-View architektúra

Az első tervezői döntés: architektúrát kell választani. A Document-View esetünkben egyértelmű választás: dokumentumokkal dolgozunk, és több nézettel, melyeket szinkronban kell tartani. Az alábbi ábra ismerteti a működést. A nézetek az **observerek**, a document pedig a **subject**, melynek változásaira az egyes nézetek fel vannak iratkozva.

![DocView](images/DocView.png)

A D-V architektúrából adódóan szükségünk lesz dokumentum osztályra, amely a dokumentum adatait tárolja (tagváltozókban), mint pl. a név, elérési út, pixelmátrix. Tegyük fel, hogy a későbbiekben több dokumentum típust is támogatni kell majd: pl. megnyithatunk egy olyan tabfület, melyen a BKK járművekhez tudjuk rendelni a betűtípusokat (elektronikus kijelző). Vannak olyan dokumentum adatok, melyek minden dokumentum típusban megjelennek (pl. név, elérési út). **Az egyes dokumentum típusoknak a közös tulajdonságait/műveleteit célszerű egy `Document` ősosztályba kiszervezni**, hogy ne legyenek duplikálva az egyes dokumentum típusokat reprezentáló dokumentum osztályokban.

- Vegyük fel a `Document` osztályt (ez az absztrakt ős).
- Vegyünk fel bele egy `string Name` property-t (ez jelenik meg a tabfüleken).

A Document-View architektúrából adódóan szükség van egy **nézet interfészre** (egy `Update` művelettel a nézet értesítéséhez), valamint a dokumentumoknak nyilván kell tartaniuk egy listában a nézeteiket:

- Vegyük fel az `IView` interfészt.
- Vegyünk fel bele egy `Update` műveletet.
- A `Document` osztályba vegyünk fel egy `List<IView> views` mezőt (a Fields-nél). Jobb gombbal kattintsunk a mező nevén a diagramon, és a menüből _Show as collection association_ kiválasztása.
- A `Document` osztályba vegyünk fel a `void AttachView(IView view)` műveletet, mellyel új nézetet lehet beregisztrálni.
- Végül vegyünk fel egy `void DetachView(IView view)`-t, mert nézetet bezárni is lehet.

Támogatnunk kell az egyes **dokumentumok tartalmának perzisztálását** (mentés/betöltés). Ezekhez vegyünk fel a `Document` ősbe a megfelelő műveleteket:

- `Document`-be `LoadDocument(string path)` felvétele.
- `Document`-be `SaveDocument(string path)` felvétele.
- Mindkettő legyen absztrakt, hiszen csak az egyes dokumentum leszármazottakban tudunk implementációt megadni: szelektáljuk ki a két műveletet, és a _Properties_ ablakban az _Inheritence modifier_ legyen _Abstract_.

Az egyes **dokumentumoknak támogatniuk kell a nézeteik frissítését**, ez minden dokumentum típusra közös:

- A `Document`-be vegyük fel az `UpdateAllViews()`-t (ez felel meg az Observer minta Notify műveletének).

### Konkrét dokumentum és adatai

Szükség van egy **olyan dokumentum típusra, ami a betűtípusok szerkesztéséhez tartozik**, amely a tagváltozóiban nyilvántartja a szükséges adatokat: legyen a neve `FontEditorDocument`.

- Vegyük fel a `FontEditorDocument` osztályt.
- Származtassuk a `Document`-ből (Toolbox – Inheritence kapcsolat).
- Ekkor a `LoadDocument` és `SaveDocument` műveletekre automatikusan megszületik az override-oló művelet. Ha mégsem lenne így
    - Jelöljük ki az ősben a két műveletet.
    - Copy
    - Jelöljük ki a `FontEditorDocument` osztályt.
    - Paste
    - Jelöljük itt ki a két műveletet, és a _Properties_ ablakban a _Instance Modifier_ legyen `override`.

**A dokumentumunk tagváltozókban tárolja az adatokat.** Gondoljuk át, hogy ezt hogyan célszerű megvalósítani. Lehetne egy háromdimenziós tömb (karakter – x – y), de inkább emeljük ki egy **külön osztályba az egy adott karakter pixeleinek tárolását/menedzselését**: vezessük be a `CharDef` osztályt.

!!! note "Pixel tömb helyett"
    Azért nem a pixeltömböt használjuk közvetlenül, mert csak egy új osztály bevezetésével van lehetőségünk kifejezetten ide tartozó műveletek bevezetésére, vagyis az egységbezárás korrekt megvalósítására.

- Vegyük fel a `CharDef` osztályt.
- `CharDef`-be `bool[,] Pixels` tulajdonság felvétele.
  
    !!! tip "többdimenzoós tömbök C#-ban"
        A fenti példában egy többdimenziós tömböt használtunk `bool[,]` és nem tömbök tömbjét `bool[][]`, mivel ezt nyelvi szinten is támogatja a C# és jobb teljesítményt nyújt, mint a tömbök tömbje, mert egy objektumként törolódik a heapen.

- `CharDef`-be `char Character` felvétele: az egyes `CharDef` osztályok tárolják magukról, hogy mely karakter pixeleit reprezentálják.

A dokumentumnak lesz egy gyűjteménye `CharDef` objektumokból: minden karakterhez pontosan egy darab. Gondoljuk át, hogy a legcélszerűbb ezt megvalósítani. Az egyes karakterdefiníciókat a karakterkódjukkal akarjuk címezni, így a `Dictionary<char, CharDef>` ideális választás: a karakterkód a kulcs, az hozzá tartozó `CharDef` pedig az érték.

- `FontEditorDocument`-be: `Dictionary<char, CharDef> charDefs` mező felvétele. Jobb katt, _Show as collection association_.

### Dokumentumok menedzselése - App Singleton osztály

Az alkalmazásban nyilván kell tartani a megnyitott dokumentumok listáját. Mely osztály felelőssége legyen? Vezessünk be rá egy **alkalmazásszintű osztályt**: legyen a neve `App` (Windows Forms alatt már van `Application`, nem célszerű ezt a nevet választani). Ez lesz az alkalmazásunk „gyökérosztálya”.

- Vegyük fel az `App` osztályt.
- `App`-ba `List<FontEditorDocument> documents` mező felvétele, majd _Show as collection association_.

Gondoljuk végig, hogyan történik majd egy **új dokumentum létrehozása** (mi történik a *File/New* menüelem kiválasztásakor): be kell kérni a felhasználótól a dokumentum nevét, létre kell hozni egy `FontEditorDocument` objektumot, fel kell venni a megnyitott dokumentumok listájába stb. Ezt a logikát ne tegyük a GUI-ba (menüelem click eseménykezelő): tegyük abba az osztályba, melynek a felelőssége a megnyitott dokumentumok menedzselése, amely tárolja a szükséges adatokat hozzá (dokumentum lista). Így legyen ez az `App` osztályunk feladata, benne vegyük fel a szükséges műveleteket:

- `App`-ba `NewDocument` és `OpenDocument` műveletek felvétele.

Most a **dokumentum mentést** gondoljuk végig: a *File/Save* mindig az aktív dokumentumra vonatkozik. Valakinek **nyilván kell tartani, melyik az aktív dokumentum**: legyen ez az `App`, hiszen ő tárolja a dokumentumok listáját is.

- A Toolbox-on válasszuk ki az Association kapcsolatot. Az `App`-ból húzzunk egy nyilat a `FontEditorDocument`-be. Válasszuk ki az újonnan létrehozott kapcsolatot, és nevezzük át `ActiveDocument`-re.
- `App`-ba `void SaveActiveDocument()` felvétele.
- `App`-ba `void CloseActiveDocumentá()` felvétele.

!!! tip "Konkrét dokumentumra vagy absztrakt ősre hivatkozzunk?"
    Mivel az `App` osztályunk alkalmazás specifikus funkciókat lát el, nyugodtan hivatkozhat a konkrét dokumentum típusra, és felesleges az absztrakt őstől függenünk, mert az csak nem kívánt castolásokhoz vezetne.

Az `App` objektumból **értelemszerűen csak egyet kell/szabad létrehozni**, amely a futó alkalmazást reprezentálja. Van még egy problémánk: a *File/Save* stb. menüelem click eseménykezelőben el kell érjük ezt az egy objektumot. Illetve, majd több más helyen is. Jó lenne, ha nem kellene minden osztályban külön elérhetővé tenni (tagváltozó vagy függvényparaméter formájában), hanem **bárhonnan egyszerűen** elérhető lenne. Erre nyújt megoldást a **Singleton tervezési minta**. Egy osztályból csak egy objektumot enged létrehozni, és ahhoz globális hozzáférést biztosít, mégpedig az osztály nevén és egy statikus `Instance` property-n keresztül, pl. így:
`App.Instance.SaveDocument`, stb. Nem valósítjuk meg teljes értékűen, de tegyük meg az alábbiakat:

- `App`-ba `App Instance` property felvétele. Properties ablakban _static: true_.
- `App`-ba privát konstruktor felvétele.

Az `App`-osztállyal végeztünk.

### Nézetek

A nézetekkel eddig nem foglalkoztunk, ez a következő lépés. Futtassuk a kész alkalmazást, és nézzük meg, hogy **hány típusú nézetre van szükség**, melyikből hány **példány** lesz:

- Két **típusú** nézetre van szükség: az egyik a mintaszöveget jeleníti meg, a másik egy adott karakter szerkesztését teszi lehetővé.
- Legyen az előző neve `SampleTextView`, az utóbbié `FontEditorView`.
- `SampleTextView`-ból mindig egy van (egy adott dokumentumra vonatkozóan), a `FontEditorView` objektumok igény szerint jönnek létre, 0..n példány létezhet.
- Vegyük fel a két osztályt.
- Implementáltassuk velük az `IView` interfészt (_Toolbox / Inheritence_ kapcsolat). Az `Update` művelet automatikusan implementálva lesz.

## 3. Feladat - A kész alkalmazás áttekintése

Idő hiányában nem valósítjuk meg az alkalmazást, hanem a kész megoldást nézzük át (laboron kb. 15 percben), annak is csak néhány lényeges használati esetét.

Töltsük le  a kész [megoldást](https://github.com/bmeviauab00/lab-docview-megoldas). Ehhez parancssorban navigáljunk a c:\work\<sajátnev> mappába (ha a laborban dolgozunk), és adjuk ki a következő parancsot:

```git clone https://github.com/bmeviauab00/lab-docview-megoldas```

Nyissuk meg a kész solution-t, futtassuk és próbáljuk ki az alkalmazás alapfunkcióit.

### Nézetek megvalósítása

Nyissuk meg a `FontEditorView`-t, először a kódot nézzük. A `FontEditorView` egyrészt implementálja az `IView` interfészt, másrészt a `UserControl`-ból származik. Mégpedig azért, mert így a tervezőben (designer) tudjuk kialakítani a felhasználói felületét, pont úgy, mint egy űrlapnak. A Visual Studio designer felületén akár bele is módosíthatnánk a layoutba és a vezérlők tulajdonságaiba. Ha kíváncsiak vagyunk, ki is próbálhatjuk ezt (pl. a nagyítás és a kicsinyítés gombok helyének megváltoztatásával).

A `SampleTextView` is `UserControl` leszármazott, bár annak egyszerű a felülete (nincsenek rajta más vezérlők), így lehetett volna közönséges `Control` leszármazott is.

:exclamation: Vonjuk le a tanulságot: **Windows Forms környezetben a nézeteket tipikusan `UserControl`-ként (esetleg `Control`-ként) célszerű megvalósítani.**

### Egy oldal (tab) elrendezése

Futtassuk az alkalmazást. Valahogy ki kell alakítsuk egy adott oldal (tabpage) elrendezését. Lehetőleg tervezői nézetben, és nem futás közben, kódból pozícionálva az elemeket (legalábbis ahol nem muszáj). A `UserControl`-ok alkalmazása jelenti számunkra a megoldást. Nyissuk meg a `FontDocumentControl`-t tervezői nézetben. Ez egy olyan vezérlő, amely egy taboldalra kerül fel, azt tölti ki teljesen. Az oldalt a már ismert layout technikákkal alakítottuk ki (`Label`, `TextBox`, `Panel`-ek Dock-kolva). Ha van időnk, akkor nézzük meg a _Document Outline_ ablakban. Az igazi érdekesség pedig az, hogy a `SampleTextView`-t is a _Toolbox_-ról _drag&drop_-pal került felhelyezésre (pont úgy, mintha egy beépített vezérlő lenne). Annyit nézzünk meg, hogy a `SampleTextView` valóban ott van a _Toolbox_ tetején.

### Forgatókönyv 1 – Egy pixel invertálása, nézetek szinkronizálása

:exclamation: Ez egy kiemelt jelentőségű forgatókönyv, mert ezt illusztrálja a D-V architektúra alapmechanizmusát, a nézetek frissítését és konzisztensen tartását.
Keressük meg azt a függvényt, ahol az egész pixel invertálás folyamat elindul. A `FontEditorView.FontEditorView_MouseClick` a kiindulópont. Itt az alább kiemelt sor a lényeg:

```csharp hl_lines="8"
private void FontEditorView_MouseClick(object sender, MouseEventArgs e)
{
    int x = e.X / zoom;
    int y = (e.Y - offsetY) / zoom;
    if (x >= CharDef.FontSize.Width)
        return;

    document.InvertCharDefPixel(editedChar, x, y);
}
```

Nézzük meg a `FontEditorDocument.InvertCharDefPixel`-t. Az invertálja a megfelelő `CharDef` pixelét, de a lényeg az utolsó sor:

```csharp hl_lines="9"
public void InvertCharDefPixel(char c, int x, int y)
{
    var charDef = GetCharDefCore(c);
    if (charDef == null)
        return;

    charDef.Pixels[x, y] = !charDef.Pixels[x, y];

    UpdateAllViews();
}
```

Az `UpdateAllViews` a `Document` ősben van, `Update`-et hív minden nézetre. Ami érdekes, hogy az `Update` hogyan van megírva az egyes nézetekben. Nézzük meg pl. a `FontEditView`-t:

```csharp hl_lines="3"
public void Update()
{
    Invalidate();
}
```

Az `Update` hatására a nézetek újra kell rajzolják magukat az aktuális dokumentum állapot alapján. De az `Update`-ben nem tudunk rajzolni, csak az `OnPaint`-ben. Így itt az `Invalidate` hívással kiváltjuk a `Paint` eseményt. Ez megint egy tanulság: **Windows Forms alkalmazásokban a nézetek `Update` függvényében tipikusan egy `Invalidate` hívás szokott lenni.**

Zárásképpen nézzük meg a `FontEditView.OnPaint` megvalósítását. Egyetlen lényeges dolog van itt: a megjelenítéshez le kell kérni a dokumentumtól az aktuális `CharDef`-et (mert a nézet a D-V architektúra alapelveinek megfelelően nem tárolja), majd ki kell azt rajzolni.

```csharp hl_lines="5 7"
protected override void OnPaint(PaintEventArgs e)
{
    base.OnPaint(e);

    var editedCharDef = document.GetCharDef(editedChar);

    CharDefViewModel.DrawFont(e.Graphics, editedCharDef, 0, offsetY, zoom);
}
```

!!! tip "Kirajzolás logikája"
    Mivel a kirajzolás logikája a `FontEditorView`-ban és a `SampleTextView`-ban is azonosan működik a `Graphics` osztály használatával, kiszerveztük ezt egy `CharDefViewModel` segédosztályba az újrafelhasználhatóság kedvéért.

    A `CharDef`-be nem célszerű rakni ezt a logikát, mivel az egy nézet független adatreprezentáció, és sokkal inkább a dokumentumhoz tartozik, mint a nézethez.

### Forgatókönyv 2 – Új dokumentum létrehozása (opcionális)

Azt nézzük meg, hogyan történik egy új dokumentum létrehozása, vagyis mi történik a _File/New_ menüelem kiválasztásakor.

Nyissuk meg a `MainForm`-ot tervezői nézetben, válaszuk a _File/New_ menüelemet, majd ugorjunk el a `Click` eseménykezelőhöz. Arra látunk példát, hogy az `App` osztály, mint Singleton, hogy érhető el:

```csharp
App.Instance.NewDocument();
```

Az összes többi menüelem eseménykezelője hasonló, nincs semmi logika a GUI-ban, csak egyszerű továbbhívás az `App`-ba.

Tekintsük át az `App.NewDocument` törzsét, és egy-egy mondatban fussuk át a fontosabb lépéseket.

1. `NewDocForm` nézet megnyitása és várakozás a válaszra.
2. Sikeres válasz esetén új `FontEditorDocument` létrehozása és felvétele a dokumentumok közé, valamint aktívvá tétele.
3. Új tab létrehozása a nézetekkel.

```csharp
public void NewDocument()
{
    // Bekérjükk az új font típus (dokumentum) nevét a
    // felhasználótól egy modális dialógs ablakban.
    var form = new NewDocForm(GetDocumentNames());
    if (form.ShowDialog() != DialogResult.OK)
        return;

    // Új dokumentum objektum létrehozása és felvétele a dokumentum listába.
    var doc = new FontEditorDocument(form.FontName);
    documents.Add(doc);

    // Az új tab lesz az aktív, az activeDocument tagváltozót erre kell állítani.
    UpdateActiveDocument(doc.Name);

    CreateTabForNewDocument(doc);
}
```

!!! tip "App osztály felelősségi köre"
    Az egyszerűség érdekében az `App` osztály most több felelősséggel is rendelkezik, de ideális esetben szét lenne szedve pl. a következő osztályokra a felelősségi köröknek megfelelően:

      - `DocumentManager`: a megjelenítéstől függetlenül a dokumentumokat tárolná.
      - `ViewManager`: feladata a nézetek menedzselése, tabcontrolokhoz hozzáadása stb. lenne.

Az `App.OpenDocument` művelet törzse nincs implementálva, de a lépések kódmegjegyzések formájában adottak, remek otthoni gyakorlási lehetőség a művelet tényleges megvalósítása.
