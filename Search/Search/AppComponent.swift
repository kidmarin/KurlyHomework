import RIBs

final nonisolated class AppComponent: Component<EmptyDependency>, SearchDependency {
    init() {
        super.init(dependency: EmptyComponent())
    }
}
