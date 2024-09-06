//
//  ExperimentalAgareeTests.swift
//  ExperimentalAgareeTests
//
//  Created by 황원상 on 8/27/24.
//

import XCTest

final class ExperimentalAgareeTests: XCTestCase {
    
    var timer: Timer?
    
    override func setUp() {
    
        DispatchQueue.global(qos: .default).async {
            self.timer = Timer(timeInterval: 0.2, repeats: true) { timer in
                let a = timer.timeInterval
                print(a)
            }
            RunLoop.current.add(self.timer!, forMode: .common)
            RunLoop.current.run()
        }
    }

    override func tearDownWithError() throws {
        timer?.invalidate()
        timer = nil
    }

    func testExample() throws {
        self.timer?.fire()
        }
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
