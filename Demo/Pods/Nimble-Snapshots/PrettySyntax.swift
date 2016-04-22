import Nimble

// MARK: - Nicer syntax using == operator

public struct Snapshot {
    let name: String?
    let record: Bool

    init(name: String?, record: Bool) {
        self.name = name
        self.record = record
    }
}

public func snapshot(name: String? = nil) -> Snapshot {
    return Snapshot(name: name, record: false)
}

public func recordSnapshot(name: String? = nil) -> Snapshot {
    return Snapshot(name: name, record: true)
}

public func ==(lhs: Expectation<Snapshotable>, rhs: Snapshot) {
    if let name = rhs.name {
        if rhs.record {
            lhs.to(recordSnapshot(named: name))
        } else {
            lhs.to(haveValidSnapshot(named: name))
        }

    } else {
        if rhs.record {
            lhs.to(recordSnapshot())
        } else {
            lhs.to(haveValidSnapshot())
        }
    }
}

// MARK: - Nicer syntax using emoji

public func 📷(snapshottable: Snapshotable, file: FileString = #file, line: UInt = #line) {
    expect(snapshottable, file: file, line: line).to(recordSnapshot())
}

public func 📷(snapshottable: Snapshotable, named name: String, file: FileString = #file, line: UInt = #line) {
    expect(snapshottable, file: file, line: line).to(recordSnapshot(named: name))
}
