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

public enum Media: String {
    case Movie = "movie"
    case Podcast = "podcast"
    case Music = "music"
    case MusicVideo = "musicVideo"
    case Audiobook = "audiobook"
    case ShortFilm = "shortFilm"
    case TVShow = "tvShow"
    case Software = "software"
    case Ebook = "ebook"
    case All = "all"
}

public typealias SearchResultClosure = ([SearchHit], Error?) -> ()

public class Search: InjectionHandler {
    public init(networkFetch: NetworkFetch) {
        Injector.sharedInstance.fetch = networkFetch
    }
    
    public func search(_ media: Media = .Movie, term: String, country: String = "US", limit: Int = 50, completion: @escaping SearchResultClosure) {
        let searchParams = ["term": term as AnyObject, "media": media.rawValue as AnyObject, "country": country as AnyObject, "limit": "\(limit)" as AnyObject]
        let request = SearchRequest(params: searchParams)
        request.resultHandler = {
            result, error in
            
            if let result = result as? [SearchHit] {
                completion(result, error)
            } else {
                completion([], error)
            }
        }
        inject(into: request)
        request.execute()
    }
    
    public func lookup(of id: Int, in country: String, completion: @escaping SearchResultClosure) {
        Logging.log("Perform lookup for \(id)")
        let request = LookupRequest(id: id, country: country)
        request.resultHandler = {
            result, error in
            
            if let result = result as? [SearchHit] {
                completion(result, error)
            } else {
                completion([], error)
            }
        }
        inject(into: request)
        request.execute()
    }
}
