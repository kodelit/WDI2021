//
//  ViewController.swift
//  Snake
//
//  Created by Grzegorz Maciak on 20/03/2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // MARK: Krok 1: Nadpisanie metody, w której załadujemy grę
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // MARK: Krok 3: Wywołanie metody ładującej grę
        ładujWęża()
    }

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

    // MARK: Krok 4: Definicja typu wartości przechowującej współrzędne na siatce

    /// Punkt na siatce planszy.
    ///
    /// Posiada współrzędne całkowite (w programowaniu nazywamy je z angielskiego `Integer`, w skrócie `Int`).
    struct GridPoint {
        var column: Int = 0
        var row: Int = 0
    }

    // MARK: Krok 5: Zmienne pomocnicze - wymiary widoku

    /// Szerokość widoku głównego.
    var viewWidth: CGFloat { return view.bounds.size.width }
    /// Wysokość widoku głównego
    var viewHeight: CGFloat { view.bounds.size.height }

    // MARK: Krok 6: Ustalenie liczby kolumn

    /// Liczba kolumn.
    ///
    /// Określa jak długi wąż zmieści się w naszej siatce, jeśli będzie leżał poziomo. Ta wartość pozwoli nam też określić jakiej wielkości powinna być jedna komórka siatki tak żeby zmieścić się w głównym widoku `view`
    let numberOfColumns: Int = 20

    // MARK: Krok 7: Ustalenie/obliczenie wymiarów siatki

    /// Szerokość kolumny.
    ///
    /// Wartość przechowujemy w postaci liczby całkowitej `Int` (ang. Integer), ponieważ będzie ona szerokością komórki naszej siatki.
    /// Dlatego, żeby móc łatwo określić, w której komórce leży dany widok i uniknąć błędów zaokrąglenia wartości rzeczywistych `float` (w naszym przypadku `CGFloat`) potrzebujemy by wymiar kolumny miał wartość bez części ułamkowej.
    var columnWidth: Int { Int(viewWidth / CGFloat(numberOfColumns)) }

    /// Wysokość wiersza
    ///
    /// Wysokość wiersza jest taka sama jak jego szerokość, ponieważ chcemy by elementy jak wąż i siatka składały się z kwadratów.
    var rowHeight: Int { columnWidth }

    // MARK: Krok 8: Określenie marginesów przestrzeni roboczej

    /// Margines górny.
    let topMargin: CGFloat = 40
    /// Margines dolny
    let bottomMargin: CGFloat = 30

    // MARK: Krok 9: Określenie wymiarów przycisków sterujących

    /// Wysokość przycisku sterowania
    let buttonHeight: CGFloat = 100

    /// Szerokość przycisku sterowania
    ///
    /// Szerokość przycisku sterującego jest taka sama jak jego wysokość, ponieważ chcemy by były one kwadratowe.
    var buttonWidth: CGFloat { buttonHeight }

    // MARK: Krok 10: Obliczenie liczby wierszy

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

        /// Pozycja planszy na osi X
        let boardXPosition: CGFloat = (viewWidth - boardWidth)/2

        // MARK: Krok demo A2: Obserwacja zmiany położenia planszy na podglądzie
        // TODO: Zmieniając wartość `boardXPosition` powyżej lub przełączając ją w późniejszym etapie (gdy "Krok demo A1" jest wykonany) możesz zaobserwować na podglądzie jak zmienia się pozycja planszy.

        // MARK: Krok 15: Stworzenie widoku planszy i umieszczenie jej na ekranie

        /// Widok planszy, po której porusza się wąż
        let boardView = UIView(frame: CGRect(x: boardXPosition, y: topMargin, width: boardWidth, height: boardHeight))
        // Dodanie ramki/obwódki planszy o standardowym kolorze (czarnym) i szerokości `1.0` punkt.
        boardView.layer.borderWidth = 1;
        // Dodanie planszy od ekranu głównego.
        view.addSubview(boardView)
        // zapisanie referencji, będzie potrzebna do dodawania i usuwania elementów na planszy.
        self.boardView = boardView

        // MARK: Krok demo A3 (opcjonalny): Podgląd siatki
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

    /// Enum określający możliwe wartości zmiany kierunku.
    enum DirectionChange {
        case left   // lewo
        case none   // bez zmian
        case right  // prawo
    }

    // MARK: Krok 20: Definicja metody ładującej przyciski sterujące

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

    /// Mapa przemieszczenia dla danego kierunku.
    ///
    /// Jest to słownik określający w jaki sposób powinno się zmieniać położenie głowy węża na siatce (o ile kolumn i wierszy) dla danego kierunku ruchu
    let directions: [Direction: GridPoint] = [.right:   GridPoint(column: 1, row: 0),
                                              .left:    GridPoint(column: -1, row: 0),
                                              .up:      GridPoint(column: 0, row: -1),
                                              .down:    GridPoint(column: 0, row: 1)]

    // MARK: Krok 36: Deklaracja mapy zmiany kierunku

    /// Mapa zmiany kierunku.
    ///
    /// Nasza mapa zmiany kierunku posiada wartości dla zmiany w lewo `.left` i w prawo `.right`, ale nie dla `.none` bo to oznacza brak zmiany. Do każdej zmiany (klucza) przypisany jest kolejny słownik zawierający obecny kierunek `currentDirectory` jako klucz, a wartością jest następny kierunek, w którym powinien poruszać się wąż po zmianie kierunku.
    let directionChangeMap: [DirectionChange: [Direction: Direction]] =
        [.left: [ .right: .up,
                  .up: .left,
                  .down: .right,
                  .left: .down ],
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
    ///     - stanie się ono częścią węża, ale na ekranie będzie to widoczne dopiero gdy przejdzie przez niego aż do ogona,
    ///     - na ekranie zostanie dodana kolejna losowa komórka reprezentująca jedzenie
    func moveSnake() -> Bool {
        // Sprawdzenie czy dla obecnej zmiany kierunku jest zdefiniowany nowy kierunek poruszania się węża
        if let newDirection = directionChangeMap[directionChange]?[currentDirection] {
            currentDirection = newDirection

            // użyliśmy już informacji o zmianie kierunku do określenia nowego kierunku, więc przywracamy ją do wartości neutralnej
            directionChange = .none
        }

        // MARK: Krok 39: Pobranie wartości przemieszczenia

        // Teraz określmy w którym miejscu (w której komórce obok obecnej głowy) powinna znaleźć się głowa węża po wykonaniu przez niego ruchu
        if let move = directions[currentDirection] {

            // MARK: Krok 40: Ustawienie nowej pozycji głowy węża

            // Ustaw nową pozycję głowy węża
            currentHeadPosition.column = currentHeadPosition.column + move.column;
            currentHeadPosition.row = currentHeadPosition.row + move.row;

            // MARK: Krok 41: Sprawdzenie czy ruch jest możliwy

            if currentHeadPosition.column >= 0, currentHeadPosition.column < numberOfColumns,
               currentHeadPosition.row >= 0, currentHeadPosition.row < numberOfRows,
               !willSnakeBiteHimself(at: currentHeadPosition) {

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
    // TODO: Sprawdź co się stanie, jeśli nie poniższa metoda zawsze będzie zwracała wartość `true`.

    func willSnakeBiteHimself(at position: GridPoint) -> Bool {

        // MARK: Krok 46: Implementacja metody sprawdzającej czy wąż nie ugryzł sam siebie

        /// Wąż bez ostatniej komórki
        ///
        /// Bez ostatniej a nie pierwszej, ponieważ to ostatnia komórka staję się głową węża po wykonaniu ruchu.
        let snakeWithoutHead = snake.dropLast()

        // sprawdź czy choćby jedna komórka znajduje się na danej pozycji `position`
        let existingCell = snakeWithoutHead.first(where: { cell in
            self.isCell(cell, at: position)
        })
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
