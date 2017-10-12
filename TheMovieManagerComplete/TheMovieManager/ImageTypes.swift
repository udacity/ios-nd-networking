//
//  ImageTypes.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 10/10/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

// MARK: - ImageType

enum ImageType {
    case backdrop(size: BackdropImage)
    case logo(size: LogoImage)
    case poster(size: PosterImage)
    case profile(size: ProfileImage)
    case still(size: StillImage)
}

// MARK: - BackdropImage: Int

enum BackdropImage: Int {
    case small, medium, large, original
}

// MARK: - LogoImage: Int

enum LogoImage: Int {
    case icon, xSmall, small, medium, large, xLarge, original
}

// MARK: - PosterImage: Int

enum PosterImage: Int {
    case icon, xSmall, small, medium, large, xLarge, original
}

// MARK: - ProfileImage: Int

enum ProfileImage: Int {
    case small, medium, tall, original
}

// MARK: - StillImage: Int

enum StillImage: Int {
    case small, medium, large, original
}
