# 클로드 코드와 함께 한 KurlyHomework

안녕하세요. 지원자 강성민입니다.
이 프로젝트는 클로드 코드를 활용하여 개발하였으며, 사소한 수정 외에 대부분 AI에 의해 생성된 코드입니다.
제 스타일로 작성된 것과 같은 코드가 될 때 까지 반복 수정하여 작업했습니다.
이하에는 세션별 요약이 있습니다.
전문 혹은 기록/메타데이터는 별도의 파일로 안내드리곘습니다.

---

## 세션 1. 메인 기능 개발
AI의 요약입니다. 
대화 전문은 ** ../Claude Sessions/클로드 세션 1 전문.txt **에 있습니다.
세션 데이터는 ** ../Claude Sessions/클로드 세션 1 - 메인 기능 개발.zip **에 있습니다.

### 앱 개요
**GitHub 저장소 검색 앱** — RIBs 아키텍처, UIKit, SnapKit, Alamofire 기반

---

### 구현한 기능

**1. 앱 기본 구조**
- RIBs 아키텍처로 Root → Search → SearchResult RIB 계층 구성
- UINavigationController 기반 네비게이션 구조

**2. 최근 검색어**
- `RecentKeywordRepository` — Swift `actor` 기반 thread-safe 저장소, UserDefaults 사용
- 최근 검색어 목록 표시 / 개별 삭제 / 전체 삭제
- 검색 시 자동 저장, 중복 제거, 최대 10개 유지

**3. GitHub 저장소 검색**
- Alamofire로 `https://api.github.com/search/repositories` 호출
- `SearchResultRepository` — `actor` 기반, `withCheckedThrowingContinuation`으로 async/await 연동
- 검색 결과 셀 (원형 아바타 이미지 + 저장소명 + 소유자)

**4. 웹뷰 연동**
- 검색 결과 셀 탭 시 WKWebView로 저장소 페이지 전체화면 표시
- `WebViewController` — Common 폴더에 공용 컴포넌트로 관리

---

### 아키텍처 설계 포인트

- **ViewController 공유** — `SearchViewController`가 Search / SearchResult RIB 양쪽의 Presentable/ViewControllable을 모두 채택
- **Snapshot 생성은 Interactor** — ViewController는 `applySnapshot(_:)` 호출만 담당
- **SearchResult RIB은 앱 시작 시부터 attach** — 검색 키워드는 `searchResultListener`로 전달
- **이벤트 전달은 Delegate Protocol** — Closure 사용 지양

---

### 코드 규칙 정비

- 정의 `{` 아래 빈 줄 추가
- `// MARK` 아래 공백 제거
- 빈 구현은 한 줄로 (`{ }`)
- UIViewController lifecycle 메소드는 `// MARK: - Lifecycle` extension으로 분리
- Extension 순서: 본문 → Lifecycle → Protocol 준수 → Private → Const
- 위 규칙들을 `CLAUDE.md`로 문서화, PostToolUse 훅으로 자동 업데이트

---

## 세션 2. 추가 기능 개발
AI의 요약입니다. 
대화 전문은 ** ../Claude Sessions/클로드 세션 2 전문.txt **에 있습니다.
세션 데이터는 ** ../Claude Sessions/클로드 세션 2 - 추가 기능 개발.zip **에 있습니다.

### 1. 로딩 인디케이터 (`5e99064`)
- 검색 API 호출 시 테이블뷰 영역만 덮는 반투명 오버레이 + `UIActivityIndicatorView` 추가
- `SearchResultPresentable`에 `showLoading()` / `hideLoading()` 추가, Interactor에서 호출

### 2. 코드 스타일 정비
- 프로젝트 전체 `protocol` / `extension` / `class` 등 `{` 아래 빈 줄 일괄 추가

### 3. 최근검색어 자동완성 (`3df33c6`)
- `FilteredRecentKeywordCell` 신규 생성 — 좌측 키워드, 우측 날짜 (`MM. dd.`)
- TextField `.editingChanged` 이벤트로 `filterRecentKeywords(with:)` 호출
- `SearchInteractor`에서 대소문자 무시 포함 필터링 후 스냅샷 적용
- 셀 탭 시 텍스트 필드 업데이트 + 검색 실행

### 4. 스크롤 및 입력 반응 (`d6a2b7a`)
- 스크롤 다운 시 네비게이션 바 숨김 (`scrollViewDidScroll`)
- 텍스트 필드 포커스 시 숨김, 포커스 해제 및 최상단 복귀 시 복원
- 검색 실행, 최근검색어·자동완성 셀 탭 시 포커스 해제

### 5. 페이징 기능 (`bad26b6`)
- `SearchResultRepository`에 페이징 상태 (`keyword`, `page`, `totalCount`, `accumulatedItems`) 통합
- 새 요청 시 이전 `DataRequest` 취소 (`currentRequest?.cancel()`)
- 마지막 5번째 셀 노출 시 다음 페이지 자동 로드, 푸터 로딩 인디케이터
- 동일 키워드 재검색 무시 (`await searchResultRepository.keyword` 비교)
- `page`는 마지막 성공 페이지 저장, 요청 파라미터는 `page + 1` 사용

### 6. 최근검색어 대소문자 무시 (`cc87b41`)
- `RecentKeywordRepository.save`에서 중복 제거 시 `caseInsensitiveCompare` 적용
