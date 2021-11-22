//
//  ApplicationSpec.swift
//  NimbleMediumUITests
//
//  Created by Minh Pham on 18/11/2021.
//

import Foundation
import Nimble
import Quick

final class ApplicationSpec: QuickSpec {

    override func spec() {

        var app: XCUIApplication!

        describe("a NimbleMedium app") {

            beforeEach {
                app = XCUIApplication()
                app.launch()
            }

            afterEach {
                app.terminate()
            }

            context("when opens") {

                it("empty tests") {
                    expect(true) == true
                }
            }
        }
    }
}
