import Foundation
import FBSnapshotTestCase
import UIKit
import Nimble
import QuartzCore
import Quick

@objc public protocol Snapshotable {
    var snapshotObject: UIView? { get }
}

extension UIViewController : Snapshotable {
    public var snapshotObject: UIView? {
        self.beginAppearanceTransition(true, animated: false)
        self.endAppearanceTransition()
        return view
    }
}

extension UIView : Snapshotable {
    public var snapshotObject: UIView? {
        return self
    }
}

@objc class FBSnapshotTest : NSObject {

    var currentExampleMetadata: ExampleMetadata?

    var referenceImagesDirectory: String?
    class var sharedInstance : FBSnapshotTest {
        struct Instance {
            static let instance: FBSnapshotTest = FBSnapshotTest()
        }
        return Instance.instance
    }

    class func setReferenceImagesDirectory(directory: String?) {
        sharedInstance.referenceImagesDirectory = directory
    }

    class func compareSnapshot(instance: Snapshotable, isDeviceAgnostic: Bool=false, snapshot: String, record: Bool, referenceDirectory: String) -> Bool {
        let snapshotController: FBSnapshotTestController = FBSnapshotTestController(testName: _testFileName())
        snapshotController.deviceAgnostic = isDeviceAgnostic
        snapshotController.recordMode = record
        snapshotController.referenceImagesDirectory = referenceDirectory

        assert(snapshotController.referenceImagesDirectory != nil, "Missing value for referenceImagesDirectory - Call FBSnapshotTest.setReferenceImagesDirectory(FB_REFERENCE_IMAGE_DIR)")

        // Need to force a draw before we call down to the underlying snapshots library.
        let view = instance.snapshotObject
        view?.drawViewHierarchyInRect(view!.bounds, afterScreenUpdates: true)

        do {
            try snapshotController.compareSnapshotOfView(view, selector: Selector(snapshot), identifier: nil)
        }
        catch {
            return false;
        }
        return true;
    }
}

// Note that these must be lower case.
var testFolderSuffixes = ["tests", "specs"]

public func setNimbleTestFolder(testFolder: String) {
    testFolderSuffixes = [testFolder.lowercaseString]
}

func _getDefaultReferenceDirectory(sourceFileName: String) -> String {
    if let globalReference = FBSnapshotTest.sharedInstance.referenceImagesDirectory {
        return globalReference
    }

    // Search the test file's path to find the first folder with a test suffix,
    // then append "/ReferenceImages" and use that.

    // Grab the file's path
    let pathComponents: NSArray = (sourceFileName as NSString).pathComponents

    // Find the directory in the path that ends with a test suffix.
    let testPath = pathComponents.filter { component -> Bool in
        return testFolderSuffixes.filter { component.lowercaseString.hasSuffix($0) }.count > 0
        }.first

    guard let testDirectory = testPath else {
        fatalError("Could not infer reference image folder – You should provide a reference dir using FBSnapshotTest.setReferenceImagesDirectory(FB_REFERENCE_IMAGE_DIR)")
    }

    // Recombine the path components and append our own image directory.
    let currentIndex = pathComponents.indexOfObject(testDirectory) + 1
    let folderPathComponents: NSArray = pathComponents.subarrayWithRange(NSMakeRange(0, currentIndex))
    let folderPath = folderPathComponents.componentsJoinedByString("/")

    return folderPath + "/ReferenceImages"
}

func _testFileName() -> String {
    let name = FBSnapshotTest.sharedInstance.currentExampleMetadata!.example.callsite.file as NSString
    let type = ".\(name.pathExtension)"
    let sanitizedName = name.lastPathComponent.stringByReplacingOccurrencesOfString(type, withString: "")

    return sanitizedName
}

func _sanitizedTestName(name: String?) -> String {
    let quickExample = FBSnapshotTest.sharedInstance.currentExampleMetadata
    var filename = name ?? quickExample!.example.name
    filename = filename.stringByReplacingOccurrencesOfString("root example group, ", withString: "")
    let characterSet = NSCharacterSet(charactersInString: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_")
    let components: NSArray = filename.componentsSeparatedByCharactersInSet(characterSet.invertedSet)

    return components.componentsJoinedByString("_")
}

func _clearFailureMessage(failureMessage: FailureMessage) {
    failureMessage.actualValue = ""
    failureMessage.expected = ""
    failureMessage.postfixMessage = ""
    failureMessage.to = ""
}

func _performSnapshotTest(name: String?, isDeviceAgnostic: Bool=false, actualExpression: Expression<Snapshotable>, failureMessage: FailureMessage) -> Bool {
    let instance = try! actualExpression.evaluate()!
    let testFileLocation = actualExpression.location.file
    let referenceImageDirectory = _getDefaultReferenceDirectory(testFileLocation)
    let snapshotName = _sanitizedTestName(name)

    let result = FBSnapshotTest.compareSnapshot(instance, isDeviceAgnostic: isDeviceAgnostic, snapshot: snapshotName, record: false, referenceDirectory: referenceImageDirectory)

    if !result {
        _clearFailureMessage(failureMessage)
        if let name = name {
            failureMessage.actualValue = "expected a matching snapshot in \(name)"
        }
        else {
            failureMessage.actualValue = "expected a matching snapshot"
        }
    }

    return result

}

func _recordSnapshot(name: String?, isDeviceAgnostic: Bool=false, actualExpression: Expression<Snapshotable>, failureMessage: FailureMessage) -> Bool {
    let instance = try! actualExpression.evaluate()!
    let testFileLocation = actualExpression.location.file
    let referenceImageDirectory = _getDefaultReferenceDirectory(testFileLocation)
    let snapshotName = _sanitizedTestName(name)

    _clearFailureMessage(failureMessage)

    if FBSnapshotTest.compareSnapshot(instance, isDeviceAgnostic: isDeviceAgnostic, snapshot: snapshotName, record: true, referenceDirectory: referenceImageDirectory) {
        failureMessage.actualValue = "snapshot \(name) successfully recorded, replace recordSnapshot with a check"
    } else {
        failureMessage.actualValue = "expected to record a snapshot in \(name)"
    }

    return false
}

internal var switchChecksWithRecords = false

public func haveValidSnapshot(named name: String? = nil) -> MatcherFunc<Snapshotable> {
    return MatcherFunc { actualExpression, failureMessage in
        if (switchChecksWithRecords) {
            return _recordSnapshot(name, actualExpression: actualExpression, failureMessage: failureMessage)
        }

        return _performSnapshotTest(name, actualExpression: actualExpression, failureMessage: failureMessage)
    }
}

public func haveValidDeviceAgnosticSnapshot(named name: String?=nil) -> MatcherFunc<Snapshotable> {
    return MatcherFunc { actualExpression, failureMessage in
        if (switchChecksWithRecords) {
            return _recordSnapshot(name, isDeviceAgnostic: true, actualExpression: actualExpression, failureMessage: failureMessage)
        }

        return _performSnapshotTest(name, isDeviceAgnostic: true, actualExpression: actualExpression, failureMessage: failureMessage)
    }
}

public func recordSnapshot(named name: String? = nil) -> MatcherFunc<Snapshotable> {
    return MatcherFunc { actualExpression, failureMessage in
        return _recordSnapshot(name, actualExpression: actualExpression, failureMessage: failureMessage)
    }
}

public func recordDeviceAgnosticSnapshot(named name: String?=nil) -> MatcherFunc<Snapshotable> {
    return MatcherFunc { actualExpression, failureMessage in
        return _recordSnapshot(name, isDeviceAgnostic: true, actualExpression: actualExpression, failureMessage: failureMessage)
    }
}
