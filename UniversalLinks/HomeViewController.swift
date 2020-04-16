//
//  ViewController.swift
//  UniversalLinks
//
//  Created by Thaliees on 4/15/20.
//  Copyright © 2020 Thaliees. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var list = [Product]()
    @IBOutlet weak var tableItems: UITableView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getProducts()
    }

    // MARK: - Request API
    private func getProducts() {
        DispatchQueue.main.async {
            APIManager.sharedInstance.getProducts(page: 1, onSuccess: { (products) in
                DispatchQueue.main.async {
                    self.list = products.products
                    self.tableItems.reloadData()
                    self.loading.stopAnimating()
                }
            }) { (error) in
                DispatchQueue.main.async { print(error) }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemTableViewCell
        
        // Configure the cell...
        cell.lblName.text = list[indexPath.row].name
        
      return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "detailsSegue", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is DetailsViewController {
            let position = sender as! Int
            let details = segue.destination as? DetailsViewController
            details?.idItem = list[position].id
        }
    }
}

