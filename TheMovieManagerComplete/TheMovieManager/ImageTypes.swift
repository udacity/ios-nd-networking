//
//  ImageTypes.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 10/10/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

// MARK: - ImageType

enum ImageType {
    case backdrop(BackdropImage)
    case logo(LogoImage)
    case poster(PosterImage)
    case profile(ProfileImage)
    case still(StillImage)
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
