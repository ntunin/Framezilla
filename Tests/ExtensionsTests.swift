//
//  Copyright © 2019 Rosberry. All rights reserved.
//

import XCTest

final class ExtensionsTests: BaseTest {

    private struct TestOptionSet: OptionSet, CustomStringConvertible {
        let rawValue: Int
        
        static let option1: TestOptionSet = .init(rawValue: 1 << 0)
        static let option2: TestOptionSet = .init(rawValue: 1 << 1)
        static let option3: TestOptionSet = .init(rawValue: 1 << 2)
        
        static let combinedOption: TestOptionSet = [.option1, .option3]
        
        static let all: TestOptionSet = [.combinedOption, .option2]
        
        init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        public var description: String {
            switch self {
            case .option1:
                return "option1"
            case .option2:
                return "option2"
            case .option3:
                return "option3"
            case .combinedOption:
                return "combinedOption"
            case .all:
                return "all"
            default:
                return "default"
            }
        }
    }
    
    func testOptionSetForEach() {
        let optionSets: [TestOptionSet] = [.all, .option1, .combinedOption]
        let allOptionsCount = 3
        let combinedOptionsCount = 2
        optionSets.forEach { options in
            var iterationsCount = 0
            options.forEach({ option in
                iterationsCount += 1
                XCTAssert(options.contains(option))
            })
            switch options {
            case .all:
                XCTAssertEqual(iterationsCount, allOptionsCount, "There's more iterations than needed")
            case .option1:
                XCTAssertEqual(iterationsCount, 1, "There's more iterations than needed")
            case .combinedOption:
                XCTAssertEqual(iterationsCount, combinedOptionsCount, "There's more iterations than needed")
            default:
                XCTAssertNil(nil, "Option not exist or not handled")
            }
        }
    }

    func testMinHorizontalRelationSearch() {
        testingView.frame = .zero
        testingView.configureFrame { maker in
            let minLeftRelation = maker.min(nestedView1.nui_left, nestedView2.nui_left)
            maker.left(to: minLeftRelation)
        }
        let convertedRect1 = mainView.convert(nestedView1.frame, from: nestedView1.superview)
        let convertedRect2 = mainView.convert(nestedView2.frame, from: nestedView2.superview)

        let minX = min(convertedRect1.origin.x, convertedRect2.origin.x)
        XCTAssertEqual(testingView.frame.origin.x,
                       minX,
                       "Left inset of testing view should be equal to minimal X between nested views")
    }
}
