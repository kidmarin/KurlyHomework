# KurlyHomework 개발 규칙

## 커뮤니케이션
- 반말로 대답한다.

---

## 코드 스타일

### 정의 첫 줄 공백
Class, Actor, Struct, Extension, Enum, Protocol 정의 `{` 아래에 한 줄 공백을 둔다.
```swift
final class Foo: UIViewController {

    var bar: String
}
```

### 빈 구현
구현이 없는 빈 클래스, 메소드, extension 등은 한 줄로 작성한다.
```swift
protocol FooListener: AnyObject { }
extension Foo: BarDelegate { }
func didDiscardSceneSessions(...) { }
```

### Lifecycle Extension
`viewDidLoad` 등 UIViewController lifecycle 메소드는 별도 extension으로 분리하고 `// MARK: - Lifecycle`로 명명한다.
```swift
// MARK: - Lifecycle
extension FooViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
```

### Extension 순서
클래스/구조체 본문 이후 extension은 아래 순서를 지킨다.
```
클래스/구조체 본문
// MARK: - Lifecycle  ← viewDidLoad 등
// MARK: - [Protocol 준수 extensions]
// MARK: - Private
// MARK: - Const      ← 항상 가장 아래
```

### MARK 주석
MARK 주석과 extension 사이에 공백을 두지 않는다.
```swift
// MARK: - Private
extension Foo {
    ...
}
```

### Extension 분리 원칙
기능별로 extension을 분리하고 MARK 주석을 붙인다.
- Routing 메서드 → `// MARK: - [RIBName]Routing`
- ViewControllable 메서드 → `// MARK: - [RIBName]ViewControllable`
- Protocol 준수 → 각각 별도 extension

### 상수 관리
`identifier`, `key`, `limit` 등 모든 상수는 가장 아래 `enum Const` extension으로 관리한다.
```swift
// MARK: - Const
extension Foo {
    enum Const {
        static let identifier = "Foo"
        static let key = "some_key"
    }
}
```

### 이벤트 전달 방식
Closure 대신 Delegate Protocol 방식을 사용한다.
```swift
protocol FooDelegate: AnyObject {
    func fooDidTapDelete(_ foo: Foo)
}
```

---

## RIBs 아키텍처

### Lifecycle
Viewable RIB은 `didBecomeActive` 대신 `viewDidLoad`를 사용한다.

### 역할 분리
- Snapshot 생성은 Interactor의 역할이다. ViewController는 `applySnapshot(_:)` 호출만 한다.
- 각 RIB의 비즈니스 로직은 해당 RIB에서만 관리한다.

### Listener 네이밍
여러 RIB이 ViewController를 공유하는 경우 listener를 명확히 구분한다.
```swift
weak var searchListener: SearchPresentableListener?
weak var searchResultListener: SearchResultPresentableListener?
```

### Repository
- `actor` 기반으로 thread-safe하게 구현한다.
- 상수는 `enum Const` extension으로 분리한다.

---

## 폴더 구조

- 여러 RIB에서 공용으로 사용하는 컴포넌트는 `Common` 폴더에 위치한다.
