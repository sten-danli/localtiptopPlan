//
//  ActivityLayout.swift
//  localtiptopPlan
//
//  Created by Dan Li on 12.12.19.
//  Copyright © 2019 Dan Li. All rights reserved.
//

import UIKit

class PinterestLayout: UICollectionViewFlowLayout {
    
    weak var delegate: PinterestDelegate!
    
    var cache = [UICollectionViewLayoutAttributes]()
    
    fileprivate let numberOFColums = 2
    
    fileprivate var contentHeight: CGFloat = 0
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else {return 0.0}
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard let collection = collectionView else {return}
        
        //xOffset坐标图片启始位置
        let columnWidt = contentWidth / CGFloat(numberOFColums) //列宽 = 内容宽度/number of columst纵行
        //X坐标
        var xOffset = [CGFloat]()
        //Y坐标
        var yOffset = [CGFloat](repeating: 0, count: numberOFColums)
        //图片高度
        
        for column in 0  ..< numberOFColums {
            xOffset.append(CGFloat(column) * columnWidt)
        }
       
        
        var columnToplacePhoto = 0
        for item in 0 ..< collection.numberOfItems(inSection: 0) {
            
            //图片内容
            let indexPath = IndexPath(item: item, section: 0)
            let photoHeight:CGFloat = delegate.collectionView(collection, numberOfColumns: numberOFColums, heightForPhotoAtIndexPath: indexPath)
            //用x，y坐标，和图片款高位置确定图片在屏幕上的位置和现实大小。
            let frame = CGRect(x: xOffset[columnToplacePhoto], y: yOffset[columnToplacePhoto], width: columnWidt, height: photoHeight)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            self.cache.append(attributes)
            
            yOffset[columnToplacePhoto] = yOffset[columnToplacePhoto] + photoHeight
            columnToplacePhoto = columnToplacePhoto < (numberOFColums - 1) ? (columnToplacePhoto + 1) : 0
        }
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
      
//        var visibleLayeroutAttribrutes = [UICollectionViewLayoutAttributes]()
        return cache
    }
}
