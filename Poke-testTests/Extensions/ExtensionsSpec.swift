//
//  ExtensionsSpec.swift
//  Poke-testTests
//
//  Created by Jokin Egia on 31/5/22.
//

import Nimble
import Quick
@testable import Poke_test
import UIKit
import class RealmSwift.Object
import class RealmSwift.List

class ExtensionsSpec: QuickSpec {
    override func spec() {
        var searchBar: UISearchBar!
        var array: [String]!
        var results: [Results]!
        var color: UIColor!
        var image1: UIImage!
        var image2: UIImage!
        var cell: UINib!
        beforeEach {
            searchBar = UISearchBar()
            array = ["Test 1", "Test 2", "Test 1"]
            results = [
                Results(name: "bulbasaur"),
                Results(name: "charmander"),
                Results(name: "squirtle")
            ]
            color = UIColor(named: "grayColor")
            image1 = UIImage(named: "listSelected")
            image2 = UIImage(named: "collectionNotSelected")
            cell = .customCell1
        }
        describe("Testing Extensions") {
            context("search bar") {
                it("should return search bar placeholder") {
                    expect(searchBar.toolbarPlaceholder).to(beNil())
                    searchBar.addDoneButtonOnKeyboard()
                    expect(searchBar.toolbarPlaceholder).to(equal(ExtensionConstants.toolbarTitle))
                }
            }
            context("array") {
                it("should remove the duplicates") {
                    expect(array.count).to(equal(3))
                    array.removeDuplicates()
                    expect(array.count).to(equal(2))
                }
                it("should transform array into list") {
                    expect(results[0].name).to(equal(results.transformArrayToList()[0].name))
                }
            }
            context("color") {
                it("should return the customized background color") {
                    expect(color).to(equal(.customButtonBackgroundColor))
                }
            }
            context("image") {
                it("should return the customized images") {
                    expect(image1).to(equal(.customTabBarImageSelected1))
                    expect(image2).to(equal(.customTabBarImage3))
                }
            }
            context("nib") {
                it("should return the customized cell") {
                    expect(cell).notTo(beNil())
                }
            }
            context("application") {
                it("should return the value wether is the first launch or not") {
                    expect(UIApplication.isFirstLaunch()).to(equal(false))
                }
            }
        }
    }
}
