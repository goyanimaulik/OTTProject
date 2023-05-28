//
//  MovieListViewController.swift
//  OTTProject
//
//  Created by iMac on 27/05/23.
//

import UIKit
import UIScrollView_InfiniteScroll

class MovieListViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var movieCV: UICollectionView!

    //MARK: - Variables
    private let movieViewModel = MovieViewModel()
    var movieArray: [MovieModel.Content] = [] //first section (1,2 page)
    var movieArray2: [MovieModel.Content] = [] //2nd section (3rd page)
    
    var pageNo = 0
    var totalItems = 1
    var itemPerPage = 1
    
    //Cell Setting
    private let smallCellHeight:CGFloat = 200 // 3 in one row
    private let bigCellHeight:CGFloat = 300 // 2 in one row
    private let sideMargin:CGFloat = 15
    
    //MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollectionViews()
        infiniteCollctionViewSetup()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            self.fetchMovieData()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.movieCV.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }
    
    //MARK: - Actions
    @IBAction func onBackBtn(_ sender: Any) {
    }
    @IBAction func onSearchBtn(_ sender: Any) {
        let searchVC = SearchViewController.instantiate(.main)
        searchVC.movieArray = movieArray
        searchVC.movieArray2 = movieArray2
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    //MARK: - API Calling
    func fetchMovieData() {
        pageNo += 1
        movieViewModel.fetchData(pageNo: pageNo) { [weak self] data in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.titleLbl.text = data.page?.title ?? "Home"
                self.totalItems = Int(data.page?.totalContentItems ?? "0") ?? 0
                self.itemPerPage = Int(data.page?.pageSize ?? "0") ?? 0
                self.setDataInCollectionView(data: data.page?.contentItems?.content)
            }
        }
    }

    
    //MARK: - CollectionView Setup
    func setCollectionViews() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 30
        
        let noOfCell = 3
        let space = sideMargin * CGFloat(noOfCell + 1)
        let width = CGFloat(self.movieCV.frame.width - CGFloat(space)) / CGFloat(noOfCell)
        layout.itemSize = CGSize(width: width, height: smallCellHeight.dp)
        
        movieCV.collectionViewLayout = layout
        movieCV.contentInset = UIEdgeInsets(top: 70, left: sideMargin, bottom: 10, right: sideMargin)
        movieCV.delegate = self
        movieCV.dataSource = self
    }
    
    func infiniteCollctionViewSetup() {
        
        // Set custom indicator
        let indicatorRect = CGRect(x: 0, y: 0, width: 24, height: 24)
        movieCV?.infiniteScrollIndicatorView = CustomInfiniteIndicator(frame: indicatorRect)
        
        // Set custom indicator margin
        movieCV?.infiniteScrollIndicatorMargin = 40
        
        // Add infinite scroll handler
        movieCV?.addInfiniteScroll { [unowned self] scrollView in
            self.fetchMovieData()
        }
        
        movieCV.setShouldShowInfiniteScrollHandler { _ -> Bool in
            return self.movieArray.count + self.movieArray2.count < self.totalItems
        }
    }

    func setDataInCollectionView(data: [MovieModel.Content]?) {
        guard let data = data else { return }
        let newItems = data
        
        // Determine section index
        let section = (pageNo >= 3) ? 1 : 0
        
        // Calculate start and end indices
        let newDataCount = (section == 0) ? movieArray.count : movieArray2.count
        let start = newDataCount
        let end = newDataCount + newItems.count
        
        // Create new index paths
        let indexPaths = (start ..< end).map { IndexPath(row: $0, section: section) }
        
        // Update data source
        if section == 0 {
            movieArray.append(contentsOf: newItems)
        } else {
            movieArray2.append(contentsOf: newItems)
        }
        
        // Update collection view
        if let collectionView = self.movieCV {
            collectionView.performBatchUpdates({
                collectionView.insertItems(at: indexPaths)
            }, completion: { _ in
                collectionView.finishInfiniteScroll()
            })
        }
    }
}


extension MovieListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (section == 0) ? movieArray.count : movieArray2.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(MovieCollectionViewCell.self)", for: indexPath) as! MovieCollectionViewCell
        let dataArray = (indexPath.section == 0) ? movieArray : movieArray2
        if indexPath.row < dataArray.count {
            let item = dataArray[indexPath.row]
            cell.setupCell(data: item)
        }
        return cell
        
    }
}

extension MovieListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCell = (indexPath.section == 1) ? 2 : 3
        let height = (indexPath.section == 1) ? bigCellHeight.dp.max(700) : smallCellHeight.dp
        
        let space = sideMargin * CGFloat(noOfCell + 1)
        let width = (collectionView.frame.width - space) / CGFloat(noOfCell)
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            // No header needed for section 0
            return CGSize.zero
        } else {
            // Header with height 50 and transparent background for section 1
            return CGSize(width: collectionView.bounds.width, height: 30)
        }
    }
}

