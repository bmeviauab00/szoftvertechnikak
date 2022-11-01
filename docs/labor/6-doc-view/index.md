# 6. Document-View architektúra

Utolsó módosítás ideje: 2022.11.31  
Kidolgozta: Benedek Zoltán

## A gyakorlat célja

A gyakorlat céljai:

- UML alapú tervezés és néhány tervezési minta alkalmazása
- A Document-View architektúra alkalmazása a gyakorlatban
- UserControl szerepének bemutatása Window Forms alkalmazásokban, Document-View architektúra esetén
- A grafikus megjelenítés elveinek gyakorlása Window Forms alkalmazásokban (Paint esemény, Invalidate, Graphics használata)

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

- A feladat/célok rövid ismertetése: egy interaktív fonteditor (betűtípus-szerkesztő) megtervezése.
- A kész alkalmazást futtatva a feladat (a kész alkalmazás működésének) ismertetése
- Az alkalmazás architektúrájának megtervezése (osztálydiagram elkészítése)
- A kész alkalmazás forráskódjának alapján néhány fontosabb forgatókönyv megvalósításának áttekintése

!!! note "Megjegyzés gyakorlatvezetők számára"
    A gyakorlat elején töltsük le a kész alkalmazást. A hallgatók ekkor még ne töltsék le, ne ezt kattintgassák, majd csak a gyakorlat második részében. A gyakorlatvezetőknek viszont szüksége lesz rá, mert ennek segítségével történik az feladat bemutatása.

## 1. Feladat - A feladat ismertetése

Interaktív FontEditor készítése, amelyben lehet szerkeszteni a karaktereket, és a karakterekből álló fontokból tetszőleges példaszöveg jeleníthető meg. Az alkalmazás felhasználói felülete futás közben:

![A FontEditor alkalmazás felülete](images/fonteditor-app-intro.png)

A következő funkciókat kell támogatnia:

- Több betűtípus egyidejű szerkesztése. Ez egyes betűtípusok külön tab oldalakon szerkeszthetők (MDI – Multiple Document Interface).
- Új betűtípus a *File/New* menüelem kiválasztásával hozható létre (meg kell adni a nevét).
- Ez egyes betűtípusok elmenthetők (*File/Save*), betölthetők (*File/Open*), és az aktuális dokumentum bezárható (*File/Close*). Ezek helye megvan az alkalmazásban, de nincsenek részleteiben implementálva (a függvények törzse nincs kitöltve – opcionális HF).
- A felhasználói felület felépítése
    - Az oldalak tetején egy mintaszöveg adható meg, melyet az aktuális betűtípussal az alkalmazás megjelenít.
    - Az oldalak közepén egy karaktersáv található. Egy adott karakteren duplán kattintva alatta megjelenik egy az adott karakterhez tartozó szerkesztőnézet.
    - Az oldal alján egymás mellett az eddig szerkesztésre megnyitott karakterek szerkesztőnézetei láthatók. Egy karakter többször is megnyitható szerkesztésre, ez esetben több szerkesztőnézet jön létre hozzá. Ennek az az értelme, hogy ugyanazt a karaktert különböző nagyítással is láthatjuk/szerkeszthetjük.
- A szerkesztőnézetek felépítése
    - Nagy része (eltekintve a felső sáv) a szerkesztőfelület, ahol fekete háttéren sárgával jelennek meg az aktív pixelek. Egy adott pixelen az egérrel kattintva a pixel invertálódik.
    - Bal felső sarokban a megjelenített karakter látható
    - ’c’ gomb: Clear, minden aktív pixelt töröl
    - ’+’ gomb: nagyítás
    - ’-’ gomb: kicsinyítés

Futtassuk az alkalmazást, és ismertessük működését a fentieknek megfelelően. Azt mindenképpen mutassuk meg, hogy ha egy karakter szerepel a mintaszövegben, valamint többször megnyitjuk szerkesztésre, akkor az egyik nézetben változtatva (egy pixelt invertálva) valamennyi nézete frissül.

 Az alkalmazás a kódmennyiség minimális értéken tartása érdekében minimalisztikus, pl. a hibakezelés nincs általánosságában kidolgozva, hiányoznak ellenőrzések. Ugyanakkor viszonylag jól kommentezett, ami segíti a kód utólagos megértését.

## 2. Feladat - Az alkalmazás megtervezése

COMING SOON

## 3. Feladat - A kész alkalmazás áttekintése

Az alábbiakra min. 15 perc kell maradjon, abba szűken bele lehet férni.

Idő hiányában nem valósítjuk meg az alkalmazást, hanem a kész megoldást nézzük át, annak is csak néhány lényeges használati esetét (forgatókönyv).

Most már a hallgatók is töltsék le a kész megoldást, nyissák meg a kész solution-t, futtassák/próbálják ki az alkalmazást.

### Nézetek megvalósítása

Nyissuk meg a `FontEditorView`-t, először a kódot nézzük. A `FontEditorView` egyrészt implementálja az IV`i`ew interfészt, de másrészt a `UserControl`-ból származik. Mégpedig azért, mert így a tervezőben (designer) tudjuk kialakítani a felhasználói felületét, pont úgy, mint egy űrlapnak. Nyissuk most meg tervezői nézetben, és mondjuk el, hogy a címkét és gombokat a Toolboxról tettük rá. Rendezzük is át egy kicsit őket, majd futtassuk az alkalmazást (elég, ha mi megtesszük, a hallgatók nem kell kövessék), hogy érezhető legyen, miről van szó.

A `SampleTextView` is így van megvalósítva, bár annak egyszerű a felülete, lehetett volna közönséges Control leszármazott is.

Vonjuk le a tanulságot: **Windows Forms környezetben a nézeteket tipikusan `UserControl`-ként (esetleg `Control`-ként) célszerű megvalósítani.**

### Egy oldal (tab) elrendezése

Futtassuk az alkalmazást. Valahogy ki kell alakítsuk egy adott oldal (tabpage) elrendezését. Lehetőleg tervezői nézetben, és nem futás közben, kódból pozícionálva az elemeket (legalábbis ahol nem muszáj). A `UserControl`-ok alkalmazása jelenti számunkra a megoldást. Nyissuk meg a `FontDocumentControl`-t tervezői nézetben. Ez egy olyan control, amely egy taboldalra kerül fel, azt tölti ki teljesen. Az oldalt a már ismert layout technikákkal alakítottuk ki (`Label`, `TextBox`, `Panel`-ek Dock-kolva). Ha van időnk, akkor nézzük meg a *Document Outline* ablakban. Az igazi „poén” pedig az, hogy a `SampleTextView`-t is a Toolbox-ról drag&drop-pal tettük fel. Annyit nézzünk meg, hogy valóban ott van a Toolbox tetején.

### Forgatókönyv 1 – egy pixel invertálása, nézetek szinkronizálása

Önálló feladat a hallgatóknak. Keressék meg azt a függvényt, ahol az egész folyamat elindul. A `FontEditorView.FontEditorView_MouseClick`-be kellene eljutni. Itt egy sor a lényeg:

```cs hl_lines="8"
private void FontEditorView_MouseClick(object sender, MouseEventArgs e)
{
    int x = e.X/zoom;
    int y = (e.Y - offsetY)/zoom;
    if (x >= CharDef.FontSize.Width)
        return;

    document.InvertCharDefPixel(editedChar, x, y);
}
```

Nézzük meg a `FontEditorDocument.InvertCharDefPixel`-t. Invertálja a megfelelő CharDef pixelét, de a lényeg az utolsó sor:

```cs hl_lines="5"
public void InvertCharDefPixel(char c, int x, int y)
{
    CharDef fd = GetCharDef(c);
    fd.Pixels[x, y] = !fd.Pixels[x, y];
    UpdateAllViews();
}
```

A `FontEditorDocument`-ben vethetünk még egy pillantást a `CharDef`-ek szótárára:

```cs
Dictionary<char, CharDef> charDefs = new Dictionary<char, CharDef>();
```

Az `UpdateAllViews` a `Document` ősben van, `Update`-et hív minden nézetre. Ami érdekes, hogy az `Update` hogy van megírva az egyes nézetekben. Nézzük meg pl. a `FontEditView`-t:

```cs hl_lines="6"
/// <summary>
/// Az IView interfész Update műveletánek implementációja.
/// </summary>
public void Update()
{
    Invalidate();
}
```

Az `Update` hatására a nézetek újra kell rajzolják magukat az aktuális dokumentum állapot alapján. De az `Update`-ben nem tudunk rajzolni, csak a „Paint”-ben. Így itt az `Invalidate` hívással kiváltjuk a Paint eseményt. Ez megint egy tanulság: Windows Forms alkalmazásokban az `Update` függvényben tipikusan `Invalidate` hívás szokott lenni.

Zárásképpen nézzük meg a FontEditView.Paint megvalósítását. Egyetlen  lényeges dolog van itt: a megjelenítéshez le kell kérni a dokumentumtól az aktuális `CharDef`-et (mert a nézet a D-V architektúrának megfelelően nem tárolja).

```cs hl_lines="8"
/// <summary>
/// A UserControl.Paint felüldefiniálása, ebben rajzolunk.
/// </summary>
protected override void OnPaint(PaintEventArgs e)
{
    base.OnPaint(e);

    CharDef editedCharDef = document.GetCharDef(editedChar);

    for (int y = 0; y < CharDef.FontSize.Height; y++)
    {
        for (int x = 0; x < CharDef.FontSize.Width; x++)
        {
            e.Graphics.FillRectangle(
                editedCharDef.Pixels[x,y] ? Brushes.Yellow: Brushes.Black,
                zoom * x, offsetY + zoom * y, zoom, zoom);
        }
    }
}

```

### Forgatókönyv 2 – Új dokumentum létrehozása

Erre a feladatra valószínűleg nem marad már idő.

Azt nézzük meg, hogyan történik egy új dokumentum létrehozása, vagyis mi történik a *File/New* menüelem kiválasztásakor.

Nyissuk meg a MainForm-ot tervezői nézetben, válaszuk a *File/New* menüelemet, hogy ugorjunk el a Click eseménykezelőhöz. Arra látunk példát, hogy az App osztály, mint Singleton, hogy érhető el:

```cs
App.Instance.NewDocument();
```

Az összes többi menüelem eseménykezelője hasonló, nincs semmi logika a GUI-ban, csak egyszerű továbbhívás az `App`-ba.

Tekintsük át az az `App.NewDocument` törzsét, és egy-egy mondatban tekintsük át (a gyakorlat során szóban ismertessük) a fontosabb lépéseket. Azt, hogy a `TabControl`-lal mit ügyeskedünk, nem kell elmondani, nem kell tudni.

```cs
/// <summary>
/// Létrehoz egy új dokumentumot.
/// </summary>
public void NewDocument()
{
    // Bekérdezzük az új font típus (dokumentum) nevét a 
    // felhasználótól egy modális dialógs ablakban.
    NewDocForm form = new NewDocForm();
    if (form.ShowDialog() != DialogResult.OK)
        return;

    // Új dokumentum objektum létrehozása és felvétele a 
    // dokumentum listába.
    Document doc = new FontEditorDocument(form.FontName);
    documents.Add(doc);
    // Az első paraméter egy kulcs, a második a tab felirata

    // Egy új tabra felteszi a dokumentumhoz tartozó felületelemeket.
    // Ezeket egy UserControl, a FontDocumentControl fogja össze.
    // Így csak ebből kell egy példányt az új tabpage-re feltenni.
    mainForm.TabControl.TabPages.Add(form.FontName, form.FontName);
    FontDocumentControl documentControl = new FontDocumentControl();
    TabPage tp = mainForm.TabControl.TabPages[form.FontName];
    tp.Controls.Add(documentControl);
    documentControl.Dock = DockStyle.Fill;

    // SampleTextView beregisztrálása a documentnál, hogy
    // értesüljön majd a dokumentum változásairól.
    documentControl.SampleTextView.AttachToDoc(doc);

    // Az új tab legyen a kiválasztott. 
    mainForm.TabControl.SelectTab(tp);

    // Az új tab lesz az aktív, az activeDocument
    // tagváltozót erre kell állítani.
    UpdateActiveDocument();
}
```

Az `App.OpenDocument` nincs kitöltve, de a lépések be vannak írva, remek gyakorlási lehetőség a hallgatóknak otthon megírni.
