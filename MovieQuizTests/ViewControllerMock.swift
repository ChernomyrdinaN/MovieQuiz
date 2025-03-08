//
//  ViewControllerMock.swift
//  MovieQuizTests
//
//  Created by Наталья Черномырдина on 08.03.2025.
//

import Foundation

private var viewControllerMock: Data { """
          {
          "image" : "https://m.media-amazon.com/images/M/MV5BMDBlMDYxMDktOTUxMS00MjcxLWE2YjQtNjNhMjNmN2Y3ZDA1XkEyXkFqcGdeQXVyMTM1MTE1NDMx._V1_Ratio0.6716_AL_.jpg",
          "text" : "Question Text",
          "correctAnswer" : true
          }
          """.data(using: .utf8) ?? Data()
}
