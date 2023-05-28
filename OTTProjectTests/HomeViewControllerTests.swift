//
//  MovieListViewControllerTests.swift
//  OTTProjectTests
//
//  Created by iMac on 27/05/23.
//

import XCTest
@testable import OTTProject

class MovieListViewControllerTests: XCTestCase {

    var sut: OTTProject.MovieListViewController!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "\(MovieListViewController.self)") as? OTTProject.MovieListViewController
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - viewDidLoad

    func testViewDidLoad_SetsCollectionViewDelegates() {
        XCTAssertTrue(sut.movieCV.delegate === sut)
        XCTAssertTrue(sut.movieCV.dataSource === sut)
    }

    func testViewDidLoad_SetsCollectionViewLayout() {
        let layout = sut.movieCV.collectionViewLayout as? UICollectionViewFlowLayout
        XCTAssertNotNil(layout)
        XCTAssertEqual(layout?.scrollDirection, .vertical)
        XCTAssertEqual(layout?.minimumLineSpacing, 30)
    }

    // MARK: - fetchMovieData

    func testFetchNewData_IncrementsPageNo() {
        sut.fetchMovieData()
        XCTAssertEqual(sut.pageNo, 2)
    }

    // MARK: - setDataInCollectionView
//
//    func testSetDataInCollectionView_AppendsDataToCorrectArray() {
//        var data = [OTTProject.MovieModel.Content]()
//        let content = OTTProject.MovieModel.Content(name: "Test", posterImage: "test_image")
//        data.append(content)
//        sut.pageNo = 3
//
//        sut.setDataInCollectionView(data: data)
//
//        XCTAssertEqual(sut.posterArray2.count, 1)
//        XCTAssertEqual(sut.posterArray.count, 0)
//        XCTAssertEqual(sut.posterArray2.first?.name, "Test")
//    }

    // MARK: - UICollectionViewDataSource

    func testNumberOfSections_ReturnsCorrectValue() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        XCTAssertEqual(sut.numberOfSections(in: collectionView), 2)
    }

    func testCollectionView_NumberOfItemsInSection_ReturnsCorrectValue() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        sut.movieArray = [OTTProject.MovieModel.Content(name: "Item 1", posterImage: "image1")]
        sut.movieArray2 = [OTTProject.MovieModel.Content(name: "Item 2", posterImage: "image2")]

        XCTAssertEqual(sut.collectionView(collectionView, numberOfItemsInSection: 0), 1)
        XCTAssertEqual(sut.collectionView(collectionView, numberOfItemsInSection: 1), 1)
    }

//    func testCollectionView_CellForItemAt_ReturnsCorrectCell() {
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
//        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "\(MovieCollectionViewCell.self)")
//
//        sut.posterArray = [OTTProject.MovieModel.Content(name: "Item 1", posterImage: "image1")]
//        let indexPath = IndexPath(item: 0, section: 0)
//        let cell = sut.collectionView(collectionView, cellForItemAt: indexPath) as? OTTProject.MovieCollectionViewCell
//
//        XCTAssertNotNil(cell)
//        XCTAssertEqual(cell?.posterNameLbl.text, "Item 1")
//    }


    func testCollectionView_LayoutReferenceSizeForHeaderInSection_ReturnsCorrectSize() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

        let sizeSection0 = sut.collectionView(collectionView, layout: UICollectionViewFlowLayout(), referenceSizeForHeaderInSection: 0)
        let sizeSection1 = sut.collectionView(collectionView, layout: UICollectionViewFlowLayout(), referenceSizeForHeaderInSection: 1)

        XCTAssertEqual(sizeSection0, .zero)
        XCTAssertEqual(sizeSection1.height, 30)
    }
}
