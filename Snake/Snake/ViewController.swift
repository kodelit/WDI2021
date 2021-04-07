//
//  ViewController.swift
//  Snake
//
//  Created by Grzegorz Maciak on 20/03/2021.
//

import UIKit

// TODO: Przed analizą tego kodu warto mieć podstawową wiedzę na temat języka swift, którą możesz znaleźć [tutaj](https://docs.swift.org/swift-book/LanguageGuide/TheBasics.html)

// ViewController jest obiektem typu `UIViewController`, czyli klasy, której głównym zadaniem jest zarządzanie jednym z głównych widoków w aplikacji jakim może być np. widok całego ekranu, oraz często też pomniejszymi podwidokami tego ekranu.
// Na wstępie warto też zapamiętać dwie rzeczy:
// - Jeśli przytrzymując wciśnięty przycisk `Option` na klawiaturze, będący odpowiednikiem przycisku `Alt` na klawiaturze Windowsowej, najedziesz na nazwę metody, właściwości (ang. `property`), bądź typu jak np. nasz `UIViewController` i klikniesz myszką, wówczas możesz zobaczyć jego dokumentację, jeśli tak owa istnieje. Możesz w niej przeczytać opis tego czego dokumentacja dotyczy, jak to działa, do czego służy, itd.

// - Jeśli zamiast przycisku `Option` przytrzymasz wciśnięty przycisk `Command` na klawiaturze, po kliknięciu na taką nazwę wyświetli się menu, z którego możesz wybrać `Jump to Definition` (czyli "Skocz do definicji"). Wówczas zobaczysz definicję danego elementu, możesz np. podejrzeć definicję naszej klasy `UIViewController`, gdzie możesz zobaczyć listę jej metod i właściwości, których możesz użyć. Znajdziesz tu np. właściwość `view` przechowującą odwołanie do widoku głównego, jak również metody, których kod jest uruchamiany w różnych momentach życia owego widoku.
// Jedną z takich metod obok `viewDidLoad()`, którą znajdziesz poniżej jest `viewDidAppear(_:)`, którą dopiszę a dokładnie nadpiszę poniżej metody `viewDidLoad()`.
// Metoda `viewDidAppear(_:)` jest istotna z punktu widzenia naszej aplikacji z tego względu, że jak można przeczytać w jej dokumentacji jest wykonywana w momencie, gdy widok `view` jest już dodany do hierarchii widoków, co oznacza tyle, że jego rozmiar odzwierciedla rzeczywisty rozmiar ekranu urządzenia.
// Nasza aplikacja natomiast będzie określała położenie i wymiary elementów na ekranie w odniesieniu do wielkości tego ekranu, więc ważnym jest, żeby znać jego rzeczywisty rozmiar na urządzeniu/symulatorze, na którym uruchomimy tą aplikację.

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // W związku z powyższym, podobnie jak w przypadku powyższej metody `viewDidLoad()` nadpiszę sobie (ang. `override`) też metodę `viewDidAppear(_:)`, żeby nasz kod uruchomić właśnie w tej metodzie.

    // MARK: Krok 1: Nadpisanie metody, w której załadujemy grę

    override func viewDidAppear(_ animated: Bool) {
        // Nadpisując metodę z klasy bazowej, dobrą praktyką a często nawet wymogiem jest wywołanie w kodzie nadpisującym kodu metody bazowej. Dzieje się tak dlatego, że nie chcemy zmienić kodu bazowego, a jedynie dopisać do niego swój własny, po lub rzadziej przed wykonaniem kodu bazowego.
        super.viewDidAppear(animated)

        // Warto też wspomnieć, że w języku Swift można używać polskich znaków w nazwach, dopuszczalne są nawet emoji więc jeśli piszesz program dla zabawy, dla siebie, bądź nie znasz jeszcze angielskiego możesz śmiało pisać wszystko po polsku
        // Dobrym nawykiem jest jednak od początku przyzwyczajać się do języka angielskiego. W warunkach zawodowych o ile z komentarzem po polsku można się czasem spotkać, to nazwy powinny być w języku angielskim inaczej jest obciach :)
        // Jako przykład jednak główną metodę uruchamiającą nasz kod nazwiemy po polsku i będzie się ona nazywała `ładujWęża()`

        // MARK: Krok 3: Wywołanie metody ładującej grę

        // Gdy zdefiniowaliśmy sobie nasza pierwszą metodę poniżej uruchomimy ją sobie właśnie w tym miejscu:
        ładujWęża()

        // Dzielenie kodu na metody/funkcje pozwala podzielić go na logiczne podzadania oraz użyć ich wielokrotnie wywołując je w różnych miejscach.
        // Czy i czym się różni metoda od funkcji? Dowiedz się samodzielnie. To pierwsze zadanie dla Ciebie.

        // Od tego miejsca ograniczymy również do minimum rozważania na tematy podstawowe jak powyżej i skupimy się na pisaniu naszego kodu, pomijając również rozważania na temat składni i szczegółów języka, ponieważ można by o tym bardzo długo opowiadać a my mamy aplikację do napisania.

        // Jeśli pojawią się jakieś pytania i wątpliwości zachęcam cię w pierwszej kolejności do samodzielnego dowiedzenia się, dlaczego coś zostało napisane w ten sposób i czy da się to zrobić inaczej.
        // To jest właśnie metoda zdobywania wiedzy, do której cię zachęcam, ponieważ najszybciej uczymy rozwiązując problemy samodzielnie szukając odpowiedzi na własną rękę. Musimy tylko mieć cel, dla którego chcemy to zrobić.
    }

    // Zanim przejdziemy do implementacji przypomnijmy sobie jeszcze jak ma działać nasza aplikacja:
    /*
     - Zaczniemy od wyświetlenia na ekranie podwidoku, który będzie naszą planszą po której będzie poruszal się wąż;
     - Wąż będzie składał się z jednakowych kwadracików a planszę podzielimy na takie kwadraciki tworząc siatkę;
     - Mając siatkę będziemy mogli określić, gdzie na tej siatce znajduje się kwadracik poprzez określenie kolumny i wiersza;
     - Co jakiś czas plansza będzie się odświeżała, co będzie skutkowało przesunięciem węża o 1 kwadracik w wyznaczonym kierunku;
     - Żeby wąż wygladał jak by pełzał będziemy przenosić ostatni kwadracik z jego ogona na początek węża tak, żeby znalazł się on na przeciwko, po jej lewej albo prawej stronie kwadracika bedącego poprzednią głową, w zależności czy użytkownik zmienil kierunek poruszania się czy nie;
     - Na planszy zawsze będzie tez 1 kwadracik w losowym, niezajętym miejscu planszy;
     - Celem gry będzie to, żeby wąż dotarł do tego kwadracika i niejako go zjadł, nie natrafiajac przy tym na krawędź planszy bądź na swój ogon;
     - Gdy wąż połknie owy kwadracik, na ekranie powinien pojawić się kolejny, a wąż powinien się wydłużyć, gdy "jedzenie przejdzie przez całe jego działo aż do ogona";
     - Wąż będzie stawał się coraz dłuższy, przez co gra będzie coraz trudniejsza;
     - Gra kończy się, gdy wąż ugryzie sam siebie w ogon, albo wykona ruch poza planszę bo użytkownik nie zdąży skręcić na czas.
     */

    // Poniżej też możemy zobaczyć w jaki sposób (używając komentarza rozpoczętego trzema ukośnikami `///`) dodaje się najprostszy opis do dokumentacji metody lub właściwości, który potem będzie dostępny w sposób opisany powyżej czyli po kliknięciu na nazwę z przytrzymanym przyciskiem `Option`.

    // MARK: Krok 2: Definicja metody ładującej grę

    /// Metoda, która ładuje kod gry.
    func ładujWęża() {

        // MARK: Krok 16: Ładowanie planszy
        loadBoard()

        // MARK: Krok 25: Ładowanie przycisków sterujących
        loadButtons()

        // MARK: Krok 49: Ładowanie elementów gry
        loadGameElements()

        // MARK: Krok 63 (ostatni): Uruchamianie gry przy starcie aplikacji
        start()
    }

    // MARK: - Generowanie planszy

    // Dla uproszczenia nazwijmy sobie komórką (ang. `cell`) każdą pojedynczą część węża jak również obiekt pojawiający się na planszy, który ma być przez niego "zjedzony".
    // Komórki niech będą kwadratowe.
    // Komórki te ułożone obok siebie stworzą siatkę, która będzie naszą planszą, po której będzie poruszał się wąż.

    // Będziemy mieli dwa układy współrzędnych:
    // - pierwszy to układ współrzędnych widoku `view`, w którym będziemy układali każdy element (komórki węża i losowa komórka na planszy do "zjedzenia")
    //  Punkt we współrzędnych widoku będzie typu `CGPoint`
    //  Posiada on współrzędne rzeczywiste (w programowaniu nazywamy je zmiennoprzecinkowymi, ang. `floating point`, w skrócie `float`. Ponieważ operujemy w obrębie biblioteki UIKit, która jest jedną z bibliotek do tworzenia tzw. UI, czyli interfejsu użytkownika (ang. `User Interface`) w przypadku współrzędnych czy rozmiaru ramki widoku mamy zawsze przedrostek `CG`, czyli np. `CGPoint`, `CGRect`, `CGFloat`. Jest tak, ponieważ właśnie takich typów używa UIKit, mimo że w Swift jest oczywiście typ `Float`. To jest jeden z niuansów platformy. Nie będziemy teraz wnikać, dlaczego tak jest.
    // - drugi to układ współrzędnych na siatce planszy, po której będzie poruszał się wąż, jeden punkt na siatce to jedna komórka (1 element węża)

    // MARK: Krok 4: Definicja typu wartości przechowującej współrzędne na siatce

    /// Punkt na siatce planszy.
    ///
    /// Posiada współrzędne całkowite (w programowaniu nazywamy je z angielskiego `Integer`, w skrócie `Int`).
    struct GridPoint {
        var column: Int = 0
        var row: Int = 0
    }

    // MARK: Krok 5: Zmienne pomocnicze - wymiary widoku

    // W aplikacjach iOS ekrany składają się z widoków, widok to element, który ma określone położenie i wymiar, oraz może zawierać w sobie inne widoki. Widoki zagnieżdża się po to, żeby łatwiej było określić ich położenie względem siebie, np. w naszym przypadku łatwiej nam będzie określić położenie węża w widoku planszy, którą nazwiemy sobie `boardView`, gdzie będą tylko elementy związane z wężem, niż w widoku głównym `view`, gdzie będą też przyciski, które musielibyśmy wziąć pod uwagę w obliczeniach, pamiętając, że musi na nie być miejsce. Widoki mają dużo więcej innych funkcji i możliwości, ale w tej chwili nie będę się na nich skupiać. Ty możesz.
    // Tak jak wspomnieliśmy głównym widokiem, czyli tym, w którym umieścimy planszę, oraz przyciski sterujące, będzie główny widok `view` kontrolera (czyli de facto naszego ekranu)
    // Zdefiniuje sobie dwie zmienne pomocnicze, tzw. `computed`, czyli obliczane, zwracające już istniejącą bądź obliczoną w jej ciele wartość.

    /// Szerokość widoku głównego.
    var viewWidth: CGFloat { return view.bounds.size.width }
    /// Wysokość widoku głównego
    var viewHeight: CGFloat { view.bounds.size.height }

    // MARK: Krok 6: Ustalenie liczby kolumn

    // Następnym krokiem będzie określenie siatki, po której będzie poruszał się wąż i w której będzie pojawiała się losowa kropka.
    // Jako punkt odniesienia przyjmijmy sobie, że chcemy uzyskać siatkę o szerokości 20 częściowego węża. To pozwoli określić nam wielkość takiej 1 komórki węża (zamiennie będziemy nazywali ją kropką) w odniesieniu do szerokości ekranu, którym dysponujemy, czyli `viewWidth`.

    /// Liczba kolumn.
    ///
    /// Określa jak długi wąż zmieści się w naszej siatce, jeśli będzie leżał poziomo. Ta wartość pozwoli nam też określić jakiej wielkości powinna być jedna komórka siatki tak, żeby zmieścić się w głównym widoku `view`
    let numberOfColumns: Int = 20

    // MARK: Krok 7: Ustalenie/obliczenie wymiarów siatki

    /// Szerokość kolumny.
    ///
    /// Wartość przechowujemy w postaci liczby całkowitej `Int` (ang. `Integer`), ponieważ będzie ona szerokością komórki naszej siatki.
    /// Dlatego, żeby móc łatwo określić, w której komórce leży dany widok i uniknąć błędów zaokrąglenia wartości rzeczywistych `float` (w naszym przypadku `CGFloat`) potrzebujemy by wymiar kolumny miał wartość bez części ułamkowej.
    var columnWidth: Int { Int(viewWidth / CGFloat(numberOfColumns)) }

    // Chcemy, żeby wąż składał sie z kwadratów więc wysokość wiersza powinna być taka sama jak szerokość kolumny

    /// Wysokość wiersza
    ///
    /// Wysokość wiersza jest taka sama jak jego szerokość, ponieważ chcemy by elementy jak wąż i siatka składały się z kwadratów.
    var rowHeight: Int { columnWidth }

    // MARK: Krok 8: Określenie marginesów przestrzeni roboczej

    // Żeby obliczyć liczbę wierszy musimy wiedzieć jaką część ekranu chcemy przeznaczyć na planszę, następnie obliczymy, ile wierszy zmieści się w tej przestrzeni.
    // Na iOS niektóre urządzenia mają u góry ekranu wcięcie (ang. `notch`), a na dole jest pole do otwierania menagera aplikacji więc damy sobie u góry i u dołu pewien margines, żeby uniknąć przypadku, że na np. iPhone 11 część ekranu będzie niewidoczna bądź niedostępna.

    /// Margines górny.
    let topMargin: CGFloat = 40
    /// Margines dolny
    let bottomMargin: CGFloat = 30

    // MARK: Krok 9: Określenie wymiarów przycisków sterujących

    // Poza marginesami na dole pod planszą potrzebujemy miejsca na przyciski do sterowania. Niech każdy z nich ma wysokość 100, żeby było łatwo nimi sterować

    /// Wysokość przycisku sterowania
    let buttonHeight: CGFloat = 100

    /// Szerokość przycisku sterowania
    ///
    /// Szerokość przycisku sterującego jest taka sama jak jego wysokość, ponieważ chcemy by były one kwadratowe.
    var buttonWidth: CGFloat { buttonHeight }

    // MARK: Krok 10: Obliczenie liczby wierszy
    // Teraz możemy określić jak będziemy obliczali liczbę wierszy

    /// Liczba wierszy.
    ///
    /// Jest to obliczona ilość całkowitych wierszy mieszczących się w dostępnej na planszę przestrzeni ekranu
    var numberOfRows: Int {
        /// Maksymalna wysokość planszy, czyli po odjęciu od wysokości ekranu: marginesu górnego, wysokości przycisków i marginesu dolnego.
        let maxBoardHeight = viewHeight - topMargin - buttonHeight - bottomMargin
        /// Ilość wierszy jest określona jako maksymalna dostępna wysokość podzielona przez określoną wcześniej wysokość wiersza
        let maxNumberOfRows = maxBoardHeight / CGFloat(rowHeight)
        // faktyczna liczba wierszy powinna być całkowita, dlatego utniemy część ułamkową, jeśli taka występuje pozostawiając tylko wartość całkowitą
        return Int(maxNumberOfRows)
    }

    // MARK: Krok 11: Zdefiniowanie zmiennej przechowującej odwołanie do widoku planszy

    // Referencja (odwołanie) do widoku najczęściej jest słaba (ang. `weak`), gdyż jego istnienie jest najczęściej uzasadnione od tego czy jest dodany do innego widoku, czyli czy jest dodany do hierarchii widoków. Jeśli zostanie z niej usunięty najczęściej nie ma sensu trzymać go w pamięci, w takiej sytuacji słaba referencja zostanie ustawiona na wartość zerową `nil` i nie będzie więcej wskazywała na ten widok. Żeby jednak referencja mogła być słaba i ustawiona na wartość `nil` musi być opcjonalna, co jest oznaczone przez znak `?`.
    // Zadaniem dla Ciebie jest dowiedzieć się więcej na temat referencji, obiektów i typu obiektowego, czyli klasy, jeśli jeszcze tego nie wiesz.

    /// Zmienna przechowująca referencję na widok planszy (siatki).
    weak var boardView: UIView?

    // MARK: Krok 12: Definicja metody ładującej planszę

    /// Metoda ładująca/tworząca widok planszy/siatki, po której będzie poruszał się wąż
    func loadBoard() {

        // MARK: Krok 13: Obliczenie wymiarów widoku planszy

        /// Szerokość planszy.
        let boardWidth = CGFloat(columnWidth * numberOfColumns)
        /// Wysokość planszy.
        let boardHeight = CGFloat(rowHeight * numberOfRows)

        // MARK: Krok 14: Określenie pozycji planszy w poziomie

        // Ustaw pozycję x planszy na pozycji 0 (przy lewej krawędzi ekranu) lub oblicz ją tak, żeby plansza znalazła się na środku ekranu, czyli na środku widoku głównego `view`.

        /// Pozycja planszy na osi X
        let boardXPosition: CGFloat = (viewWidth - boardWidth)/2

        // MARK: Krok demo A2: Obserwacja zmiany położenia planszy na podglądzie
        // TODO: Zmieniając wartość `boardXPosition` powyżej lub przełączając ją w późniejszym etapie (gdy "Krok demo A1" jest wykonany) możesz zaobserwować na podglądzie jak zmienia się pozycja planszy.

        // MARK: Krok 15: Stworzenie widoku planszy i umieszczenie jej na ekranie

        // Widoki są zawsze prostokątne więc mają swoje:
        // - położenie (tutaj nazywa się ono `origin`) w układzie współrzędnych widoku nadrzędnego (np. ekranu) liczonych od lewego górnego rogu widoku/ekranu, gdzie znajduje się punkt (0,0)
        // - Rozmiar (ang. `size`) czyli szerokość (ang. `width`) i wysokość (ang. `height`)

        /// Widok planszy, po której porusza się wąż
        let boardView = UIView(frame: CGRect(x: boardXPosition, y: topMargin, width: boardWidth, height: boardHeight))
        // Dodanie ramki/obwódki planszy o standardowym kolorze (czarnym) i szerokości `1.0` punkt.
        boardView.layer.borderWidth = 1;
        // Dodanie planszy od ekranu głównego.
        view.addSubview(boardView)
        // zapisanie referencji, będzie potrzebna do dodawania i usuwania elementów na planszy.
        self.boardView = boardView

        // MARK: Krok demo A3 (opcjonalny): Podgląd siatki
        // TODO: Odkomentuj poniższy kod, aby zobrazować siatkę, USUŃ/ZAKOMENTUJ KOD PO OBSERWACJI
        //for c in 0..<numberOfColumns {
        //    for r in 0..<numberOfRows {
        //        let cellPosition = CGPoint(x: columnWidth * c, y: rowHeight * r)
        //        let cell = createCell(at: cellPosition)
        //        cell.backgroundColor = .lightGray
        //        boardView.addSubview(cell)
        //    }
        //}
    }

    // MARK: Krok 17: Definicja metody tworzącej komórkę/kropkę w danym punkcie siatki

    /// Metoda tworząca nową komórkę siatki w podanym punkcie siatki bądź w punkcie zerowym (pierwsze pole siatki w lewym górnym rogu planszy).
    ///
    /// - parameter point: Punkt, w którym powinna się pojawić komórka/kropka, określony jako współrzędne w widoku, do którego zostanie dodana. Można pominąć parametr `point` co spowoduje utworzenie kropki punkcie (0,0) (lewy górny róg widoku)
    /// - returns: Widok reprezentujący komórkę siatki (część węża bądź kropkę stanowiącą jego "pożywienie").
    func createCell(at point: CGPoint = .zero) -> UIView {

        // MARK: Krok 18: Kod tworzący komórkę/kropkę w danym punkcie

        /// Widok komórki/kropki
        let cell = UIView(frame: CGRect(origin: point, size: CGSize(width: columnWidth, height: rowHeight)))
        // Ustawienie koloru tła komórki na zielony
        cell.backgroundColor = .green;
        // Dodanie ramki/obwódki komórki o standardowym kolorze (czarnym) i szerokości `1.0` punkt.
        cell.layer.borderWidth = 1

        return cell
    }

    // MARK: Krok 19: Definicja typu wartości określającej zmianę kierunku
    // TODO: Zanim wykonasz "Krok 19" dodaj na końcu pliku "Krok demo A1"

    // MARK: - Sterowanie

    // Zdefiniujemy sobie teraz typ, który pomoże nam przechować wartość określającą zmianę kierunku, w którym porusza się wąż. Będzie to tzw. typ wyliczeniowy (ang. `enum`), który charakteryzuje się tym, że ma najczęściej z góry określoną liczbę wartości jakie może przyjąć stała bądź zmienna tego typu. Te wartości nazywają się przypadkami (ang. `case`).

    /// Enum określający możliwe wartości zmiany kierunku.
    enum DirectionChange {
        case left   // lewo
        case none   // bez zmian
        case right  // prawo
    }

    // MARK: Krok 20: Deklaracja metody ładującej przyciski sterujące

    func loadButtons() {
        // MARK: Krok 21: Ustalenie wartości pomocniczych

        /// Rozmiar przycisku sterującego
        let buttonSize = CGSize(width: buttonWidth, height: buttonHeight)

        /// Odstęp od boku ekranu (lewego bądź prawego) w jakim powinien znaleźć się przycisk sterujący ze strzałką.
        let sideMargin: CGFloat = 20

        /// Współrzędna y określająca na jakiej wysokości będą znajdowały się przyciski sterujące
        let buttonYPosition = viewHeight - bottomMargin - buttonHeight

        // MARK: Krok 23: Tworzenie przycisku restartującego grę

        /// Współrzędne przycisku `restart` w układzie współrzędnych widoku głównego/ekranu
        let restartButtonPosition = CGPoint(x: (viewWidth - buttonWidth)/2, // środek ekranu
                                          y: buttonYPosition)
        /// Przycisk restart
        let restartButton = UIButton(type: .system)
        // ustawienie pozycji i wymiarów przycisku na ekranie
        restartButton.frame = CGRect(origin: restartButtonPosition, size: buttonSize)
        // ustawienie obrazka/ikony dla przycisku
        restartButton.setImage(UIImage(systemName: "restart"), for: .normal)
        // dodanie przycisku do widoku głównego
        view.addSubview(restartButton)

        // przypiszmy akcję do przycisku, która ma się wykonać w momencie jego tapnięcia, czyli dotknięcie ekranu i podniesienie palca w obrębie przycisku
        restartButton.addTarget(self, action: #selector(onRestartButton), for: .touchUpInside)

        // TODO: Odkomentuj, aby zobrazować przycisk
        //resetButton.layer.borderWidth = 1

        // MARK: Krok 24: Dodawanie przycisków nawigujących w lewo i prawo

        [DirectionChange.left, DirectionChange.right].forEach { (direction) in
            let button = UIButton(type: .system)
            let buttonXPosition: CGFloat

            if direction == .left {
                buttonXPosition = sideMargin
                button.setImage(UIImage(systemName: "arrowshape.turn.up.left"), for: .normal)
                button.addTarget(self, action: #selector(onLeftButton), for: .touchUpInside)
            } else {
                buttonXPosition = viewWidth - sideMargin - buttonWidth
                button.setImage(UIImage(systemName: "arrowshape.turn.up.right"), for: .normal)
                button.addTarget(self, action: #selector(onRightButton), for: .touchUpInside)
            }
            let buttonPosition = CGPoint(x: buttonXPosition, y: buttonYPosition)
            button.frame = CGRect(origin: buttonPosition, size: buttonSize)
            view.addSubview(button)

            // TODO: Odkomentuj, aby zobrazować przyciski
            //button.layer.borderWidth = 1
        }

        // MARK: Krok 51: Dodanie obsługi tapnięcia na planszy

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        boardView?.addGestureRecognizer(tapGestureRecognizer)
    }

    // MARK: Krok 22: Deklaracja metod obsługujących kliknięcia przycisków

    @objc func onRestartButton() {
        // MARK: Krok 55: Przywracanie początkowych ustawień gry
        reset()

        // MARK: Krok 62: Uruchamianie gry
        start()
    }

    @objc func onLeftButton() {
        // MARK: Krok 56: Zmiana kierunku ruchu w lewo
        directionChange = .left
    }

    @objc func onRightButton() {
        // MARK: Krok 57: Zmiana kierunku ruchu w prawo
        directionChange = .right
    }

    // MARK: Krok 26: Zdefiniowanie sposobu przechowywania elementów gry w pamięci

    // MARK: - Elementy gry

    /// Wszystkie komórki węża
    var snake: [UIView] = []

    /// Komórka, do której wąż musi dotrzeć i ją połknąć, by stać się większym.
    weak var food: UIView?

    // MARK: Krok 27: Definicja metody generującej komórkę w losowym miejscu

    /// Generuje komórkę w losowym PUSTYM miejscu na planszy.
    ///
    /// Komórka ta stanowi "pożywienie", do którego będzie zmierzał wąż.
    func generateRandomCell() -> UIView {
        // MARK: Krok 29: Szukanie wolnego miejsca na siatce

        /// Współrzędne całkowite na naszej siatce (planszy)
        var gridPosition = GridPoint()
        repeat {
            // Wygeneruj losowe wartości całkowite z przedziału od 0 do liczby wierszy pomniejszonej o 1
            gridPosition.column = Int.random(in: 0..<numberOfColumns)
            // można to też zapisać w ten sposób
            gridPosition.row = Int.random(in: 0...(numberOfRows-1))

            // następnie sprawdź czy wygenerowane wartości nie wskazują na pole siatki, które jest aktualnie zajęte, gdy (ang. `while`) tak jest powtórz (ang. `repeat`) proces, jeśli nie, przejdź dalej.
        } while !isGridPositionAvailable(gridPosition)

        // MARK: Krok 30: Tworzenie komórki o położeniu w wygenerowanym punkcie siatki

        let viewPosition = CGPoint(x: CGFloat(gridPosition.column * columnWidth), y: CGFloat(gridPosition.row * rowHeight))
        let cell = createCell(at: viewPosition)
        return cell
    }

    // MARK: Krok 28: Definicja metody sprawdzającej dostępność pola na siatce

    /// Metoda sprawdzająca czy dany punkt na siatce jest wolny i można w nim umieścić komórkę.
    func isGridPositionAvailable(_ position: GridPoint) -> Bool {
        // MARK: Krok 32: Implementacja metody sprawdzającej dostępność pola na siatce

        // weź wszystkie komórki węża
        var allCels = snake
        // dodaj komórkę jedzenia sprawdzając czy istnieje. Komórka jedzenia (losowa komórka) może nie istnieć na początku, póki jej nie dodamy.
        if let food = food {
            allCels.append(food)
        }

        // sprawdź czy choćby jedna komórka znajduje się na danej pozycji `position`
        let existingCell = allCels.first(where: { cell in
            self.isCell(cell, at: position)
        })
        return existingCell == nil
    }

    // MARK: Krok 31: Definicja metody sprawdzającej czy dana komórka (widok) znajduje się w danym polu na siatce

    /// Metoda sprawdzająca czy dana komórka (widok) znajduje się w danym punkcie na siatce.
    func isCell(_ cell: UIView, at position: GridPoint) -> Bool {
        // MARK: Krok 33: Implementacja metody sprawdzającej czy dana komórka (widok) znajduje się w danym polu na siatce

        /// Pozycja komórki w widoku planszy.
        let viewPosition: CGPoint = cell.frame.origin
        /// Pozycja komórki na siatce
        var gridPosition = GridPoint()

        // obliczamy index kolumny
        gridPosition.column = Int( viewPosition.x/CGFloat(columnWidth) )
        // obliczamy index wiersza
        gridPosition.row = Int( viewPosition.y/CGFloat(rowHeight) )

        // komórka znajduje się na podanej pozycji, jeśli obje pozycje:
        // - pozycja komórki na siatce `gridPosition` oraz
        // - pozycja `position`
        // mają takie same wartości
        return position.column == gridPosition.column && position.row == gridPosition.row
    }

    // MARK: Krok 34: Definicja typu wartości określającej kierunek poruszania

    // MARK: - Logika gry (odświeżanie)

    /// Enum określający możliwe wartości kierunku poruszania się węża.
    enum Direction: Int {
        case right, up, down, left
    }

    // MARK: Krok 35: Deklaracja mapy przemieszczenia
    // Mapa ruchu w danym kierunku jest typu Słownik (ang. `Dictionary`) czyli posiada klucz (ang. `key`), do którego jest (po dwukropku) przypisana wartość (ang. `value`). Znając klucz możemy odczytać wartość.

    /// Mapa przemieszczenia dla danego kierunku.
    ///
    /// Jest to słownik określający w jaki sposób powinno się zmieniać położenie głowy węża na siatce (o ile kolumn i wierszy) dla danego kierunku ruchu
    let directions: [Direction: GridPoint] = [
        .right:   GridPoint(column: 1, row: 0), // w prawo, wąż przeskakuje na siatce planszy o 1 kolumnę w prawo przy każdym odświeżeniu
        .left:    GridPoint(column: -1, row: 0),// w lewo, wąż przeskakuje na siatce planszy o 1 kolumnę w lewo przy każdym odświeżeniu
        .up:      GridPoint(column: 0, row: -1),// w górę, wąż przeskakuje na siatce planszy o 1 wiersz w górę przy każdym odświeżeniu
        .down:    GridPoint(column: 0, row: 1)  // w dół, wąż przeskakuje na siatce planszy o 1 wiersz w dół przy każdym odświeżeniu
    ]

    // MARK: Krok 36: Deklaracja mapy zmiany kierunku

    /// Mapa zmiany kierunku.
    ///
    /// Mapa zmiany kierunku posiada wartości dla zmiany w lewo `.left` i w prawo `.right`, ale nie dla `.none` bo to oznacza brak zmiany. Do każdej zmiany (klucza) przypisany jest kolejny słownik zawierający obecny kierunek `currentDirectory` jako klucz, a wartością jest następny kierunek, w którym powinien poruszać się wąż po zmianie kierunku.
    let directionChangeMap: [DirectionChange: [Direction: Direction]] =
        [.left: // gdy zmieniamy ruch w lewo
            [
                // gdy obecny kierunek ruchu jest w prawo, po zmianie wąż będzie poruszał się w górę ekranu
                .right: .up,
                // gdy obecny kierunek ruchu jest w górę, po zmianie wąż będzie poruszał się w lewą stronę ekranu, itd.
                .up: .left,
                .down: .right,
                .left: .down
            ],
         .right: [.right: .down,
                  .up: .right,
                  .down: .left,
                  .left: .up]]

    // MARK: Krok 37: Deklaracja zmiennych przechowujących stan gry

    /// Zmiana kierunku.
    ///
    /// Zmienna określająca zmianę kierunku. Jeśli użytkownik przyciśnie jedną ze strzałek na ekranie zmienna ta zmieni wartość na `.left` (lewo) lub `.right` (prawo), a po kolejnym odświeżeniu ekranu gry zostanie przywrócona wartość `.none`
    var directionChange: DirectionChange = .none

    /// Obecny kierunek ruchu węża.
    var currentDirection = Direction.down

    /// Położenie głowy węża na siatce.
    var currentHeadPosition = GridPoint(column: 0, row: 0)

    // MARK: Krok 38: Deklaracja metody odświeżającej stan gry

    /// Przemieszcza węża w następne położenie.
    ///
    /// - Jeśli użytkownik wcisnął przycisk zmiany kierunku, metoda zmienia obecny kierunek poruszania się węża.
    /// - Następnie sprawdza, gdzie powinna znaleźć się jego głowa po przemieszczeniu.
    ///     - Jeśli po przemieszczeniu wąż nie ugryzie sam siebie bądź nie wyjdzie za planszę, wąż zostanie przemieszczony.
    ///     - W przeciwnym wypadku gra zostanie przerwana.
    /// - Jeśli głowa przemieści się na pole z jedzeniem
    ///     - stanie się ono częścią węża, ale na ekranie będzie to widoczne dopiero, gdy przejdzie przez niego aż do ogona,
    ///     - na ekranie zostanie dodana kolejna losowa komórka reprezentująca jedzenie
    func moveSnake() -> Bool {
        // Wyznaczmy nowy kierunek poruszania się węża.
        // Jeśli zmiana kierunku `directionChange` posiada wartość inną niż `.none` (żadna) wówczas w mapie zmiany kierunku `directionChangeMap` dla wartości `directionChange` znajdziemy drugą mapę. Ta druga mapa pozwala nam określić jaki jest następny kierunek poruszania, jeśli obecnie poruszamy się w kierunku `currentDirection`. Tą wartość przypisujemy do `currentDirection`, bo będzie to nasz nowy kierunek.

        // Sprawdzenie czy dla obecnej zmiany kierunku jest zdefiniowany nowy kierunek poruszania się węża
        if let newDirection = directionChangeMap[directionChange]?[currentDirection] {
            currentDirection = newDirection

            // użyliśmy już informacji o zmianie kierunku do określenia nowego kierunku, więc przywracamy ją do wartości neutralnej
            directionChange = .none
        } else {
            // Jeśli natomiast zmiana kierunku nie nastąpiła (użytkownik nie wcisnął żadnej strzałki) zmiana kierunku `directionChange` będzie wynosiła `.none` co oznacza brak zmiany a w słowniku `directionChangeMap` nie ma wartości dla klucza `.none`. Wobec tego nie będzie wartości `newDirection`, a `currentDirection` pozostanie bez zmian, wąż porusza się w tym samym kierunku co poprzednio.
            // Tu nie musimy robić nic.
        }

        // MARK: Krok 39: Pobranie wartości przemieszczenia

        // Teraz określmy w którym miejscu (w której komórce obok obecnej głowy) powinna znaleźć się głowa węża po wykonaniu przez niego ruchu
        if let move = directions[currentDirection] {

            // MARK: Krok 40: Ustawienie nowej pozycji głowy węża

            // Ustaw nową pozycję głowy węża
            currentHeadPosition.column = currentHeadPosition.column + move.column;
            currentHeadPosition.row = currentHeadPosition.row + move.row;

            // MARK: Krok 41: Sprawdzenie czy ruch jest możliwy

            // sprawdzamy czy wąż nie wyszedł poza planszę
            if currentHeadPosition.column >= 0, currentHeadPosition.column < numberOfColumns,
               currentHeadPosition.row >= 0, currentHeadPosition.row < numberOfRows,
               // sprawdzamy czy wąż nie próbuje ugryźć sam siebie, czyli czy następne położenie głowy węża nie jest w miejscu, gdzie znajduje się już jakaś część węża
               !willSnakeBiteHimself(at: currentHeadPosition) {
                // wąż może iść dalej

                // MARK: Krok 43: Przemieszczenie głowy na nową pozycję

                // bierzemy więc ostatni element węża i przenosimy go w nowe miejsce na głowę
                if let newHead = snake.popLast() {

                    // Określmy rzeczywiste położenie widoku głowy w widoku planszy
                    let headPosition = CGPoint(x: currentHeadPosition.column * columnWidth, y: currentHeadPosition.row * rowHeight)
                    // przemieśćmy nową głowę węża w nowe położenie
                    newHead.frame.origin = headPosition
                    // umieśćmy głowę na początku węża
                    snake.insert(newHead, at: 0)

                    // MARK: Krok 44: Sprawdzenie czy wąż coś zjadł
                    // Teraz musimy wziąć pod uwagę, że jeśli wąż poruszy się do przodu, a na pozycji `currentGridPosition` znajduje się jedzenie (losowa komórka) wąż powinien ją zjeść. Zjadanie będzie polegało na tym, że dodamy zjedzoną komórkę na początek węża, jednak nie zmienimy jej pozycji na planszy. Dzięki temu komórka ta będzie w tym samy miejscu (przykryta przez ciało węża) do momentu, gdy stanie się ona jego ostatnią częścią. Wtedy zostanie odsłonięta na planszy, a w następnym ruchu stanie się głową (zostanie przeniesiona na początek jako najdalsza część ogona)

                    // Teraz sprawdźmy, czy przypadkiem jedzenie nie znajduje się w miejscu, gdzie ma pojawić się głowa węża
                    if let food = food, isCell(food, at: currentHeadPosition) {
                        // MARK: Krok 45: Implementacja konsumpcji

                        // Dodajemy komórkę jedzenia na początek węża, ale nie zmieniamy jej położenia na planszy, będzie ona się przesuwała pod wężem aż na jego koniec
                        snake.insert(food, at: 0)
                        // jako że wąż zjadł obecne jedzenie należy wygenerować nowe, żeby wąż miał gdzie zmierzać
                        let newFood = generateRandomCell()
                        // następnie umieśćmy nową komórkę z jedzeniem na planszy
                        boardView?.insertSubview(newFood, at: 0)
                        // musimy też przypisać ją do zmiennej, bo będziemy jej potrzebować w następnym ruchu
                        self.food = newFood
                    }

                    // Zwróć `true` informując, że ruch został zakończony pomyślnie
                    return true
                } else {
                    // nie powinien wystąpić przypadek, że wąż nie ma ogona, bo już na początku gry ma on 3 komórki
                    fatalError("Snake has no tail, which mean that there is no snake at all. 😮")
                }
            } else {
                // zmieniamy tło planszy na czarne w celu zasygnalizowania końca gry
                boardView?.backgroundColor = .black

                // Zwróć `false` informując, że ruch się nie powiódł co oznacza koniec gry
                return false
            }
        }
        return false
    }

    // MARK: Krok 42: Deklaracja metody sprawdzającej czy wąż nie ugryzł sam siebie

    /// Sprawdza, czy wąż ugryzie sam siebie, jeśli jego głowa znajdzie się na danej pozycji.
    ///
    /// - parameter position: Pozycja docelowa głowy węża.
    func willSnakeBiteHimself(at position: GridPoint) -> Bool {
        // TODO: Sprawdź co się stanie, jeśli ta metoda zawsze będzie zwracała wartość `false`.

        // MARK: Krok 46: Implementacja metody sprawdzającej czy wąż nie ugryzł sam siebie

        /// Wąż bez ostatniej komórki
        ///
        /// Bez ostatniej a nie pierwszej, ponieważ to ostatnia komórka staję się głową węża po wykonaniu ruchu.
        let snakeWithoutHead = snake.dropLast()

        // Bierzemy więc węża, ale bez ostatniego elementu ogona, ponieważ będzie on za moment stanowił głowę, jednak nie wiemy jeszcze, gdzie i czy możemy tą głowę umieścić w nowym miejscu, co właśnie sprawdzimy. Głowa może zostać również umieszczona tam, gdzie dopiero co był koniec ogona, dlatego właśnie ten koniec ogona usuniemy przed sprawdzeniem.

        // sprawdź czy choćby jedna komórka znajduje się na danej pozycji `position`
        let existingCell = snakeWithoutHead.first(where: { cell in
            self.isCell(cell, at: position)
        })
        // Wąż nie ugryzie sam siebie, jeśli na danej pozycji nie ma żadnej jego komórki.
        return existingCell != nil
    }

    // MARK: Krok 47: Deklaracja metody ładującej elementy gry

    /// Umieszcza na planszy 3 pierwsze komórki węża i jedzenie.
    func loadGameElements() {
        // MARK: Krok 48: Implementacja metody ładującej elementy gry

        // Stwórzmy 3 początkowe komórki węża i wrzućmy je na pierwsze pole w siatce (lewy górny róg, punkt (0,0))
        for _ in 1...3 {
            // stwórzmy komórkę
            let cell = createCell(at: .zero)
            // dodamy ją do listy komórek węża
            snake.insert(cell, at: 0)
            // dodajmy ją do podwidoków planszy, czyli umieśćmy na planszy
            boardView?.addSubview(cell)
        }

        // Stwórzmy też komórkę w losowym pustym miejscu na planszy za pomocą metody, którą przygotowaliśmy wcześniej, komórka ta będzie nazywana "jedzeniem" (ang. `food`).
        let firstFood = generateRandomCell()
        // umieśćmy ją na planszy
        boardView?.insertSubview(firstFood, at: 0)
        // przypiszmy jej wartość do zmiennej lokalnej, żeby móc się do niej odnieść później
        self.food = firstFood
    }

    // MARK: Krok 50: Deklaracja metody reagującej na tapnięcie na planszy

    @objc func handleTap(sender: UITapGestureRecognizer) {

        // MARK: Krok 52: Implementacja metod reagującej na tapnięcie na planszy

        // wykonaj pojedynczy ruch
        _ = moveSnake()
    }

    // MARK: Krok 53: Deklaracja metody przywracającej początkowe ustawienia gry

    /// Przywraca początkowe ustawienia gry.
    func reset() {
        // MARK: Krok 54: Implementacja metody przywracającej początkowe ustawienia gry

        currentDirection = .down
        // Ustawiamy zmianę kierunku na 0, czyli brak zmiany
        directionChange = .none
        // ustaw obecną pozycję na lewy górny róg siatki
        currentHeadPosition = GridPoint(column: 0, row: 0)

        // przywróć kolor tła pola
        boardView?.backgroundColor = .white

        // usuń poprzednie elementy gry (węża, losową kropkę, pogląd siatki, jeśli był załadowany, generalnie wszystkie podwidoki planszy)
        boardView?.subviews.forEach { subview in
            subview.removeFromSuperview()
        }

        // Usuń tablicę przechowującą komórki węża nadpisując ją pustą
        snake = []

        // Załaduj na nowo elementy gry
        loadGameElements()
    }

    // MARK: Krok 58: Deklaracja metody uruchamiającej grę

    // MARK: - Uruchamianie gry

    func start() {
        // MARK: Krok 60: Uruchamianie automatycznego odświeżania gry

        // Przed uruchomieniem nowego timera należy zatrzymać poprzedni
        // TODO: Sprawdź co się stanie, jeśli tego nie zrobisz.
        timer?.invalidate()

        /// Odstęp w sekundach pomiędzy kolejnymi odświeżeniami
        ///
        /// W takich odstępach czasu gra będzie się odświeżała automatycznie
        let updateInterval: TimeInterval = 0.3
        // Tworzenie i uruchamianie timera, który będzie uruchamiał ponownie daną metodę (`selektor`), póki nie zostanie zatrzymany
        timer = Timer.scheduledTimer(timeInterval: updateInterval, target: self, selector: #selector(onRefresh(_:)), userInfo: nil, repeats: true)
    }

    // MARK: Krok 59: Obsługa automatycznego odświeżania gry

    weak var timer: Timer?

    @objc func onRefresh(_ timer: Timer) {
        // MARK: Krok 61: Implementacja automatycznego odświeżania gry

        let isSuccess = moveSnake()
        if !isSuccess {
            // Jeśli ruch się nie powiódł oznacza to koniec gry
            // wąż albo wyszedł za planszę, albo ugryzł sam siebie, kończymy grę poprzez zatrzymanie zegara
            timer.invalidate()
        }
    }
}

// MARK: - Krok demo A1: Pomocniczy kod pozwalający wyświetlić podgląd ekranu w xcode
// TODO: Wróć do kroku "Krok demo A2" zdefiniowanego wcześniej i poeksperymentuj z wartością `boardXPosition` bądź innymi.
// TODO: Dodaj "Krok demo A3" w oznaczonym miejscu i wykonaj polecenie TODO z tego kroku

// !!!: Jeśli podgląd się nie wyświetla użyj przycisku "Resume" albo "Try again", experymentuj.
// !!!: Poniższy kod odpowiada tylko za podgląd działania kodu w czasie rzeczywistym dzięki automatycznemu podglądowi w Xcode.
// Metoda ta przy prostych aplikacjach jest wygodniejsza niż ciągle uruchamianie aplikacji na symulatorze bądź fizycznym urządzeniu w celu podejrzenia efektu pracy.

// MARK: - Xcode Preview
// Works from Xcode 11 and macOS 10.15

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, tvOS 13.0, *)
struct ViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = ViewController

    func makeUIViewController(context: Context) -> UIViewControllerType {
        return ViewController(nibName: nil, bundle: nil)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

@available(iOS 13.0, tvOS 13.0, *)
struct UIKitViewControllerProvider: PreviewProvider {
    static var previews: ViewControllerRepresentable { ViewControllerRepresentable() }
}

#endif
