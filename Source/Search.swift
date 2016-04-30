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

public typealias SearchResultClosure = ([SearchHit], NSError?) -> ()

public class Search {
    private let fetch: NetworkFetch
    
    public init(networkFetch: NetworkFetch) {
        fetch = networkFetch
    }
    
    public func search(media: Media = .Movie, term: String, completion: SearchResultClosure) {
        let request = SearchRequest(fetch: fetch, params: ["term": term, "media": media.rawValue])
        request.resultHandler = {
            result, error in
            
            if let result = result as? [SearchHit] {
                completion(result, error)
            } else {
                completion([], error)
            }
        }
        request.execute()
    }
}