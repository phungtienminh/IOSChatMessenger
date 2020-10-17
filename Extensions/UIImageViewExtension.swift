//
//  UIImageViewExtension.swift
//  ChatApplication
//
//  Created by Swiftaholic on 4/20/20.
//  Copyright © 2020 Macbook. All rights reserved.
//

import Foundation
import Kingfisher

extension UIImageView {
    func loadCustomPoster(posterPath: String) {
        let urlPoster = URL(string: posterPath)
        kf.indicatorType = .activity
        kf.setImage(
            with: urlPoster,
            options: [.transition(.fade(0.2))]
        )
    }
}
