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

import XCTest

class SearchHitTests: XCTestCase, JSONDataLoader {
    override func setUp() {
        super.setUp()
        
        Logging.sharedInstance.delegate = TestLogger.sharedInstance
    }
    
    func testMovieSearchResultParse() {
        let data = loadFromFile("movie_search_result") as! [String: AnyObject]
        let hits = SearchHit.loadResults(data)
        XCTAssertEqual(5, hits.count)
        
        guard let topHit = hits.first else {
            XCTAssertTrue(false)
            return
        }
        
        XCTAssertEqual("The Dark Knight", topHit.trackName)
        XCTAssertEqual(764632601, topHit.trackId)
        XCTAssertEqual("http://is1.mzstatic.com/image/thumb/Video2/v4/97/c0/49/97c04909-4ee7-40aa-c9e1-c67e501fcf6c/source/30x30bb.jpg", topHit.artworkUrl30.absoluteString)
        XCTAssertEqual("http://is1.mzstatic.com/image/thumb/Video2/v4/97/c0/49/97c04909-4ee7-40aa-c9e1-c67e501fcf6c/source/60x60bb.jpg", topHit.artworkUrl60.absoluteString)
        XCTAssertEqual("http://is1.mzstatic.com/image/thumb/Video2/v4/97/c0/49/97c04909-4ee7-40aa-c9e1-c67e501fcf6c/source/100x100bb.jpg", topHit.artworkUrl100.absoluteString)
    }
}
