//
//  DetailsViewController.swift
//  UniversalLinks
//
//  Created by Thaliees on 4/15/20.
//  Copyright © 2020 Thaliees. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    var idItem: String = ""
    
    @IBOutlet weak var imageItem: UIImageView!
    @IBOutlet weak var nameItem: UILabel!
    @IBOutlet weak var descripItem: UILabel!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getDetails()
    }
    
    // MARK: - Request API
    private func getDetails() {
        DispatchQueue.main.async {
            APIManager.sharedInstance.getProductDetails(idWine: self.idItem, onSuccess: { (details) in
                DispatchQueue.main.async { self.fillData(details: details) }
            }) { (error) in
                DispatchQueue.main.async { print(error) }
            }
        }
    }
    
    private func fillData(details: Product) {
        self.title = details.name.capitalized
        if details.image != "" { imageItem.load(url: URL(string: details.image)!) }
        nameItem.text = details.name.capitalized + "\n" + details.characteristics.characteristicsDescription.capitalized
        
        descripItem.text = details.characteristics.color.capitalized + "\n" + details.characteristics.volAlch + " alcohol"
        
        loading.stopAnimating()
    }
}

extension UIImageView {
    func load(url: URL) {
        getData(from: url) { (data, response, error) in
            guard let data = data, error == nil else {
               return
            }
            DispatchQueue.main.async() {
                self.contentMode = .scaleAspectFill
                self.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
