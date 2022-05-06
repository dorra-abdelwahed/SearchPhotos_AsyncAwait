//
//  ViewController.swift
//  Async_Await_UIKit
//
//  Created by Dorra Ben Abdelwahed on 4/5/2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var photos = [Photos]()
    

    
    
    override func viewDidLoad()  {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 200, height: 200)
        collectionView.collectionViewLayout = layout
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
       
        setupSearchController()
        
        
    }

  
    
    func fetchPhotos(with query: String) async throws -> Void{

        guard let url = URL(string: apiURL+"&query=\(query)") else {
            return
        }
        // using the async variant of urlSession to fetch data
        let (data, _) = try await URLSession.shared.data(from: url)


        // parsing the json data
        guard let result = try? JSONDecoder().decode(Response.self, from: data) else { return }


        self.photos = result.results
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }




        }
        
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let urlImage = photos[indexPath.row].urls.regular
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as? CollectionViewCell else {return UICollectionViewCell() }
       
       Task {
       try await cell.configure(with: urlImage)
         }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 200, height: 200)
        
    }
    
}

extension ViewController{
    
    private func setupSearchController() {

        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search photos"

        navigationItem.searchController = searchController
    }
}

extension ViewController: UISearchResultsUpdating{

    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        
        // start an async task
         Task{
             do{
               try await fetchPhotos(with: searchText)
             }catch{
                 print("request failed with \(error)")
             }
         }
        
       
    }
}

