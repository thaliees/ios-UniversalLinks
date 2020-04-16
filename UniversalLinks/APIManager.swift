//
//  APIManager.swift
//  UniversalLinks
//
//  Created by Thaliees on 4/15/20.
//  Copyright © 2020 Thaliees. All rights reserved.
//

import Foundation

class APIManager: NSObject {
    static let sharedInstance = APIManager()
    private let baseURL = "https://apimobilpos.herokuapp.com/api"
    private let authorization = "authorization"
    private var tokenDefault = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVlM2UwMjJkMmY0MGNhMDAwNGEzMTRlYiIsImlhdCI6MTU4Njk3NzU2NSwiZXhwIjoxNTg2OTc3NjUxfQ.xKqikI9WM5oV80-bJoLjYE9e1WqBW8KLdv9tV-3i_o4"
    /// User
    private let pathUser = "/user/token"
    /// Product
    private let pathProducts = "/products"
    private var search = "?typeStore=vineyards&filterByUserConfig=false&page=Value1&limit=10"
    
    private var urlSession:URLSession = {
        let config:URLSessionConfiguration = .default
        config.waitsForConnectivity = false
        config.allowsCellularAccess = true
        config.timeoutIntervalForRequest = 20
        return URLSession(configuration: config)
    }()
    
    // MARK: -Function with Authorization
    func refreshToken(onSuccess: @escaping (ErrorModel) -> Void) {
        let refresh = RefreshTokenModel(token: tokenDefault)
        let url = baseURL + pathUser
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            try request.httpBody = JSONEncoder().encode(refresh)
        } catch let error {
            onSuccess(ErrorModel(code: -1, message: error.localizedDescription))
        }
        
        let task = urlSession.dataTask(with: request as URLRequest, completionHandler: { data, response, error -> Void in
            if error != nil {
                onSuccess(ErrorModel(code: -1, message: error!.localizedDescription))
            }
            else {
                let statusResponse = response as! HTTPURLResponse
                
                do {
                    if statusResponse.statusCode == 200 {
                        let result = try JSONDecoder().decode(RefreshTokenModel.self, from: data!)
                        self.tokenDefault = result.token
                        onSuccess(ErrorModel(code: 0, message: result.token))
                    }
                    else {
                        let result = try JSONDecoder().decode(ErrorModel.self, from: data!)
                        onSuccess(result)
                    }
                } catch let error {
                    onSuccess(ErrorModel(code: -1, message: error.localizedDescription))
                }
            }
        })
        
        task.resume()
    }
    
    // MARK: -PRODUCTS SECTION
    func getProducts(page: Int, onSuccess: @escaping (ItemModel) -> Void, onFailure: @escaping (String) -> Void) {
        let url = baseURL + pathProducts + search.replacingOccurrences(of: "Value1", with: String(page))
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(tokenDefault, forHTTPHeaderField: authorization)
        
        let task = urlSession.dataTask(with: request as URLRequest, completionHandler: { data, response, error -> Void in
            if error != nil {
                onFailure(error!.localizedDescription)
            }
            else {
                let statusResponse = response as! HTTPURLResponse
                
                do {
                    if statusResponse.statusCode == 200 {
                        let result = try JSONDecoder().decode(ItemModel.self, from: data!)
                        onSuccess(result)
                    }
                    else {
                        let result = try JSONDecoder().decode(ErrorModel.self, from: data!)
                        
                        if result.code == 1005 {
                            self.refreshToken() { (result) in
                                if result.code == 0 {
                                    self.getProducts(page: page, onSuccess: { (products) in
                                        onSuccess(products)
                                    }) { (error) in
                                        onFailure(error)
                                    }
                                }
                                else { onFailure(result.message)}
                            }
                        }
                        else { onFailure(result.message) }
                    }
                } catch let error {
                    onFailure(error.localizedDescription)
                }
            }
        })
        
        task.resume()
    }
    
    func getProductDetails(idWine: String, onSuccess: @escaping (Product) -> Void, onFailure: @escaping (String) -> Void) {
        let url = baseURL + pathProducts + "/\(idWine)"
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(tokenDefault, forHTTPHeaderField: authorization)
        
        let task = urlSession.dataTask(with: request as URLRequest, completionHandler: { data, response, error -> Void in
            if error != nil {
                onFailure(error!.localizedDescription)
            }
            else {
                let statusResponse = response as! HTTPURLResponse
                
                do {
                    if statusResponse.statusCode == 200 {
                        let result = try JSONDecoder().decode(Product.self, from: data!)
                        onSuccess(result)
                    }
                    else {
                        let result = try JSONDecoder().decode(ErrorModel.self, from: data!)
                        
                        if result.code == 1005 {
                            self.refreshToken() { (result) in
                                if result.code == 0 {
                                    self.getProductDetails(idWine: idWine, onSuccess: { (details) in
                                        onSuccess(details)
                                    }) { (error) in
                                        onFailure(error)
                                    }
                                }
                                else { onFailure(result.message)}
                            }
                        }
                        else { onFailure(result.message) }
                    }
                } catch let error {
                    onFailure(error.localizedDescription)
                }
            }
        })
        
        task.resume()
    }
    
}
