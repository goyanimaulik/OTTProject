//
//  SearchViewController.swift
//  OTTProject
//
//  Created by iMac on 28/05/23.
//

import UIKit

class SearchViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var searchCV: UICollectionView!
    
    // No Data
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var noDataTitle: UILabel!
    
    //MARK: - Variables
    private let searchViewModel = SearchViewModel()
    private let movieViewModel = MovieViewModel()
    var mostPopularArray: [PosterModel.Content] = []
    var movieArray: [PosterModel.Content] = [] //first section (1,2 page)
    var movieArray2: [PosterModel.Content] = [] //2nd section (3rd page)

    // Filtered arrays to hold search results
    var filteredMovieArray: [PosterModel.Content] = []
    var filteredMovieArray2: [PosterModel.Content] = []
    
    //Cell Setting
    private let smallCellHeight:CGFloat = 200 // 3 in one row
    private let bigCellHeight:CGFloat = 300 // 2 in one row
    private let sideMargin:CGFloat = 15

    //MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()

        searchView.layer.masksToBounds = true
        searchView.layer.cornerRadius = 5
        setCollectionViews()
        
        searchTF.delegate = self
        searchTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        searchViewModel.fetchMostPopularMovie { data in
            self.mostPopularArray = data.page?.contentItems?.content ?? []
        }
        
        // as we don't have api for search. i generate data locally before search.
        if movieArray2.count == 0 {
            movieViewModel.fetchData(pageNo: 3) { data in
                self.movieArray2 = data.page?.contentItems?.content ?? []
            }
        }
    }
    
    //MARK: - Actions
    @IBAction func onBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    //MARK: - CollectionView Setup
    private func setCollectionViews() {
        registerHeader()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 30

        let noOfCell = 3
        let space = sideMargin * CGFloat(noOfCell + 1)
        let width = CGFloat(self.searchCV.frame.width - CGFloat(space)) / CGFloat(noOfCell)
        layout.itemSize = CGSize(width: width, height: smallCellHeight.dp)

        searchCV.collectionViewLayout = layout
        searchCV.contentInset = UIEdgeInsets(top: 70, left: sideMargin, bottom: 10, right: sideMargin)
        searchCV.delegate = self
        searchCV.dataSource = self
        
        
    }
    
    private func registerHeader() {
        searchCV.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SearchHeaderView")
    }

    func filterMovies(with searchText: String) {
        filteredMovieArray = movieArray.filter { movie in
            if let movieName = movie.name {
                return movieName.localizedCaseInsensitiveContains(searchText)
            }
            return false
        }
        
        filteredMovieArray2 = movieArray2.filter { movie in
            if let movieName = movie.name {
                return movieName.localizedCaseInsensitiveContains(searchText)
            }
            return false
        }
        handleNoData()
        searchCV.reloadData()
    }
    
    func shouldShowPopular() -> Bool {
        if filteredMovieArray.count == 0 && filteredMovieArray2.count == 0 && searchTF.text == "" {
            return true
        } else {
            return false
        }
    }
    
    func handleNoData() {
        if filteredMovieArray.count == 0 && filteredMovieArray2.count == 0 && searchTF.text != "" {
            noDataView.isHidden = false
            noDataTitle.text = "Couldn't found '\(searchTF.text ?? "")'"
        } else {
            noDataView.isHidden = true
        }

    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if let searchText = textField.text {
            filterMovies(with: searchText)
        }
    }


}

extension SearchViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}


extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            if shouldShowPopular() {
                return mostPopularArray.count
            }
            return 0
        }
        return (section == 1) ? filteredMovieArray.count : filteredMovieArray2.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(MovieCollectionViewCell.self)", for: indexPath) as! MovieCollectionViewCell
        var dataArray: [PosterModel.Content] = []
        if indexPath.section == 0 {
            dataArray = mostPopularArray
        } else {
            dataArray = (indexPath.section == 1) ? filteredMovieArray : filteredMovieArray2
        }

        if indexPath.row < dataArray.count {
            let item = dataArray[indexPath.row]
            cell.setupCell(data: item)
        }
        return cell
        
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCell = (indexPath.section == 2) ? 2 : 3
        let height = (indexPath.section == 2) ? bigCellHeight.dp.max(700) : smallCellHeight.dp
        
        let space = sideMargin * CGFloat(noOfCell + 1)
        let width = (collectionView.frame.width - space) / CGFloat(noOfCell)
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
                
        if section == 0 {
            if shouldShowPopular()  {
                return CGSize(width: collectionView.bounds.width, height: 40)
            }
            // No header needed for section 0
            return CGSize.zero
        } else {
            // Header with height 50 and transparent background for section 1
            return CGSize(width: collectionView.bounds.width, height: 30)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SearchHeaderView", for: indexPath)
            // Remove any existing subviews from the header view
            for subview in headerView.subviews {
                subview.removeFromSuperview()
            }
            
            if indexPath.section == 0 && shouldShowPopular() {
                // Create and configure a label for the header text
                let label = UILabel(frame: headerView.bounds)
                label.textColor = .white
                label.font = UIFont(name:"TitilliumWeb-SemiBold",size:16)
                label.text = "Popular search"
                
                // Add the label to the header view
                headerView.addSubview(label)
            }
            return headerView
        } else {
            return UICollectionReusableView()
        }
    }
}
