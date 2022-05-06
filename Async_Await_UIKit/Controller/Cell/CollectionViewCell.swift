//
//  CollectionViewCell.swift
//  Async_Await_UIKit
//
//  Created by Dorra Ben Abdelwahed on 5/5/2022.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet var photo: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        photo.layer.cornerRadius = 10
        
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photo.image = nil
    }
    
   
    
    func configure(with urlString: String) async throws -> Void {
        
        guard let url = URL(string: urlString) else { return }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let image = UIImage(data: data)
        DispatchQueue.main.async {

        self.photo.image = image
            
        }
    }
}
