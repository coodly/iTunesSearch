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
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

private let APIServer = "https://itunes.apple.com"

private enum Method: String {
    case POST
    case GET
}

internal class NetworkRequest: FetchConsumer {
    var fetch: NetworkFetch!
    
    var apiKey: String!
    var resultHandler: ((Any?, Error?) -> ())!
    
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
        
        fetch.fetch(request as URLRequest) {
            data, response, error in
            
            if let error = error {
                Logging.log("Fetch error \(error)")
                self.handle(error: error)
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                decoder.dateDecodingStrategy = .formatted(formatter)

                do {
                    let result = try decoder.decode(SearchResults.self, from: data)
                    self.handle(success: result.results)
                } catch let error as NSError {
                    if let tunesError = try? decoder.decode(TunesError.self, from: data) {
                        self.handle(error: tunesError)
                    } else {
                        self.handle(error: error)
                    }
                }
            } else {
                self.handle(error: error)
            }
        }
    }
    
    func handle(success hits: [SearchHit]) {
        Logging.log("handleSuccessResponse")
    }
    
    func handle(error: Error?) {
        Logging.log("handleErrorResponse")
        resultHandler(nil, error)
    }
}
