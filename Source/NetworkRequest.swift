/*
 * Copyright 2016 Coodly LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation

private let APIServer = "https://itunes.apple.com"

private enum Method: String {
    case POST
    case GET
}

class NetworkRequest {
    let fetch: NetworkFetch
    var apiKey: String!
    var resultHandler: ((Any?, NSError?) -> ())!
    
    init(fetch: NetworkFetch) {
        self.fetch = fetch
    }
    
    func execute() {
        fatalError("Override \(#function)")
    }
    
    func GET(_ path: String, parameters: [String: AnyObject]? = nil) {
        executeMethod(.GET, path: path, parameters: parameters)
    }
    
    func POST(_ path: String, parameters: [String: AnyObject]? = nil) {
        executeMethod(.POST, path: path, parameters: parameters)
    }
    
    private func executeMethod(_ method: Method, path: String, parameters: [String: AnyObject]?) {
        var components = URLComponents(url: URL(string: APIServer)!, resolvingAgainstBaseURL: true)!
        components.path = components.path + path
        
        if let parameters = parameters {
            var queryItems = [URLQueryItem]()
            
            for (name, value) in parameters {
                queryItems.append(URLQueryItem(name: name, value: value as? String))
            }
            
            components.queryItems = queryItems
        }
        
        let requestURL = components.url!
        let request = NSMutableURLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        
        fetch.fetchRequest(request as URLRequest) {
            data, response, error in
            
            if let error = error {
                Logging.log("Fetch error \(error)")
                self.handleErrorResponse(error)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    self.handleSuccessResponse(json as! [String: AnyObject])
                } catch let error as NSError {
                    self.handleErrorResponse(error)
                }
            } else {
                self.handleErrorResponse(error)
            }
        }
    }
    
    func handleSuccessResponse(_ data: [String: AnyObject]) {
        Logging.log("handleSuccessResponse")
    }
    
    func handleErrorResponse(_ error: NSError?) {
        Logging.log("handleErrorResponse")
        resultHandler(nil, error)
    }
}
