# Interfész és absztrakt (ős)osztály

Utolsó módosítás ideje: 2022.10.15  
Kidolgozta: Benedek Zoltán

A fejezet nem tartalmaz feladatot, a hallgatók számára ismerteti a kapcsoló elméletet.

## Absztrakt osztály

A fogalmak korábbi tárgyak keretében már ismertetésre kerültek, így most csak a legfontosabbakat foglaljuk össze, illetve a C# vonatkozására térünk ki.
Absztrakt osztály
Olyan osztály, mely nem példányosítható. C# nyelven az osztálydefinícióban az abstract kulcsszót kell kiírni, pl.:

```csharp
abstract class Shape { … }
```

Absztrakt osztályoknak lehetnek absztrakt metódusaik, melyeknek nem adjuk meg a törzsét, ezeknél is az abstract kulcsszót kell használni:

```csharp
…
abstract void Draw();
…
```

Absztrakt osztályok használatának két célja lehet:

- Egy osztályhierarchiában a leszármazottakra közös kódot fel tudjuk vinni egy absztrakt közös ősbe, így elkerüljük a kódduplikációt.
- Egységesen tudjuk absztrakt ősként hivatkozva a leszármazottakat kezelni (pl. heterogén kollekciók).

.NET környezetben, csakúgy, mint Java nyelven, egy osztálynak csak egy ősosztálya lehet.

## Interfész

Az interfész nem más, mint egy művelethalmaz. Tulajdonképpen egy olyan absztrakt osztálynak felel meg, melynek minden művelete absztrakt.

C# nyelven az `interface` kulcsszóval tudunk interfészt definiálni:

```csharp
public interface ISerializable 
{
   void WriteToStream(Stream s);
   void LoadFromStream(Stream s);
}

public interface IComparable 
{
   int CompareTo(Object obj);
}
```

Míg egy osztálynak csak egy őse lehet, akárhány interfészt implementálhat:

```csharp
public class Rect : Shape, ISerializable, IComparable
{
    …
}
```

Ebben a példában Rect osztály a Shape osztályból származik, valamint az `ISerializable` és `IComparable` interfészeket implementálja (kötelezően az ősosztályt kell először megadni). Az interfészt implementáló osztályban annak valamennyi műveletét meg kell valósítani, vagyis meg kell írni a törzsét (kivéve azt a ritka esetet, amikor absztrakt művelettel valósítjuk meg).
Interfészek használatának egy fő célja van. Interfészként hivatkozva egységesen tudjuk az interfészt implementáló valamennyi osztályt kezelni (pl. heterogén kollekció). Ennek egy következménye: **az interfészek lehetővé teszik széles körben használható osztályok és függvények megírását**. Pl. tudunk írni egy univerzális Sort sorrendező függvényt, mely bármilyen osztállyal használható, mely implementálja az IComparable interfészt.

Az interfész alkalmazásának előnyei még:

- A kliensnek elég a kiszolgáló objektum interfészét ismernie, így egyszerűen tudja a kiszolgálót használni.
- **Ha a kliens csak az interfészen keresztül használja a kiszolgálót, így a kiszolgáló belső implementációja megváltozhat, a klienst nem kell módosítani (újra sem kell fordítani)**. Ennek megfelelően az interfész egy szerződés is a kiszolgáló és a kliens között: amíg a kiszolgáló garantálja az interfész támogatását, a klienst nem kell változtatni.

## Absztrakt ős és interfész összehasonlítása

Az absztrakt ős előnye az interfésszel szemben, hogy adhatunk meg a műveletekre vonatkozóan alapértelmezett implementációt, illetve vehetünk fel tagváltozókat.

Az interfészek előnye az absztrakt őssel szemben, hogy egy osztály akárhány interfészt implementálhat, míg őse maximum egy lehet.

Az interfészek használatának van még egy következménye, ami bizonyos esetben kellemetlenségeket okozhat. **Amikor az interfészbe új műveletet veszünk fel, akkor valamennyi implementáló osztályt szintén bővíteni kell, különben a kód nem fordul. Absztrakt ős bővítése esetén ez nincs így: amennyiben új műveletet veszünk fel, lehetőségünk van azt virtuális függvényként felvenni, és így az ősben alapértelmezett implementációt adni rá**. Ez esetben az leszármazottak igény szerint tudják ezt felüldefiniálni, erre nincsenek rákényszerítve. Az interfészek ezen tulajdonsága különösen osztálykönyvtárak/keretrendszerek esetén lehet kellemetlen. Tegyük fel, hogy a .NET új verziójának kiadáskor a keretrendszer egyik interfészébe új műveletet vesznek fel. Ekkor valamennyi alkalmazásban valamennyi implementáló osztályt módosítani kell, különben nem fordul a kód. Ezt kétféleképpen lehet elkerülni. Vagy ősosztály használatával, vagy ha mégis interfészt kellene bővíteni, akkor inkább új interfészt bevezetésével, amely már az új műveletet is tartalmazza. Bár itt az első megközelítés (ősosztály alkalmazása) tűnik első érzésre vonzóbbnak, ennek is van hátránya: ha az alkalmazás fejlesztésekor egy keretrendszerbeli ősből származtatunk, akkor osztályunknak már nem lehet más őse, és ez bizony sok esetben fájdalmas megkötést jelent.

Érdemes tudni, hogy C# 8-tól (illetve .NET vagy .NET Core runtime is kell hozzá, .NET Framework alatt nem támogatott) kezdve **interfész műveleteknek is lehet alapértelmezett implementációt adni (default interface methods), így a fenti probléma megoldásához nincs szükség absztrakt osztályra, de interfésznek továbbiakban sem lehet tagváltozója**. Bővebben információ itt:  [default interface methods](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/proposals/csharp-8.0/default-interface-methods).

Mivel mind az interfészek, mind az absztrakt ősosztályok alkalmazása járhat negatív következményekkel is, számos esetben a kettő együttes használatával tudjuk kihozni megoldásunkból a maximumot (vagyis lesz a kódunk könnyen bővíthető úgy, hogy nem, vagy csak minimális mértékben tartalmaz kódduplikációt).
