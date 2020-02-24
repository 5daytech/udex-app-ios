protocol IAdapter: class {
  func start()
  func stop()
  func refresh()
  
  var debugInfo: String { get }
  var receiveAddress: String { get }
}
