//
//  GridLayoutPlugin.swift
//  PluginLayout
//
//  Created by Stefano Mondino on 30/06/2019.
//  Copyright © 2019 Stefano Mondino. All rights reserved.
//

import Foundation
import UIKit

public protocol GridLayoutDelegate: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout: PluginLayout, itemsPerLineAt indexPath: IndexPath) -> Int
    func collectionView(_ collectionView: UICollectionView, layout: PluginLayout, aspectRatioAt indexPath: IndexPath) -> CGFloat
}

open class GridLayoutPlugin: FlowLayoutPlugin {
    public init(delegate: GridLayoutDelegate ) {
        super.init(delegate: delegate)
        
    }
    open override func itemSize(at indexPath: IndexPath, collectionView: UICollectionView, layout: PluginLayout) -> CGSize {
        let n = (delegate as? GridLayoutDelegate)?.collectionView(collectionView, layout: layout, itemsPerLineAt: indexPath) ?? 1
        let ratio = (delegate as? GridLayoutDelegate)?.collectionView(collectionView, layout: layout, aspectRatioAt: indexPath) ?? 1
        let itemsPerLine = max(n, 1)
        let insets = delegate?.collectionView?(collectionView, layout: layout, insetForSectionAt: indexPath.section) ?? .zero
        let spacing = delegate?.collectionView?(collectionView, layout: layout, minimumInteritemSpacingForSectionAt: indexPath.section) ?? 0
        switch layout.scrollDirection {
        case .vertical:
            let availableWidth = collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right - insets.left - insets.right
            let itemWidth = (availableWidth - (CGFloat(itemsPerLine - 1) * spacing)) / CGFloat(itemsPerLine)
            return CGSize(width: itemWidth, height: itemWidth / ratio)
        case .horizontal:
            let availableHeight = collectionView.bounds.height - collectionView.contentInset.top - collectionView.contentInset.bottom - insets.top - insets.bottom
            let itemHeight = (availableHeight - (CGFloat(itemsPerLine - 1) * spacing)) / CGFloat(itemsPerLine)
            return CGSize(width: itemHeight * ratio, height: itemHeight)
        @unknown default:
            return .zero
        }
    }
}
