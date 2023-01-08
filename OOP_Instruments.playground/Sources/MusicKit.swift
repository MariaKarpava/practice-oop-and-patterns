// 1
final public class Music {
  // 2
  public let notes: [String]

  public init(notes: [String]) {
    self.notes = notes
  }

  public func prepared() -> String {
    return notes.joined(separator: " ")
  }
}

// 3
open class Instrument {
  public let brand: String

  public init(brand: String) {
    self.brand = brand
  }

  // 4
  open func tune() -> String {
    fatalError("Implement this method for \(brand)")
  }

  open func play(_ music: Music) -> String {
    return music.prepared()
  }

  // 5
  final public func perform(_ music: Music) {
    print(tune())
    print(play(music))
  }
}

