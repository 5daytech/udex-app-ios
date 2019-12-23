protocol IAdapter: class {
    func start()
    func stop()
    func refresh()

    var debugInfo: String { get }
}
