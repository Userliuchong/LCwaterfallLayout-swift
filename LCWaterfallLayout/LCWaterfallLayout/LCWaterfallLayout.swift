//
//  LCWaterfallLayout.swift
//  LCWaterfallLayout
//
//  Created by 刘崇 on 17/3/13.
//  Copyright © 2017年 liuchong. All rights reserved.
//

import UIKit

//代理协议
protocol LCWaterfallLayoutDelegate {
    //代理方法
    func lcwaterfallLayout(waterfallLayout:LCWaterfallLayout,itemwidth:CGFloat,atindexpath:NSIndexPath) ->CGFloat
}

class LCWaterfallLayout: UICollectionViewLayout {
    //声明外部属性
    public var columnCount : Int? = 3//列数
    public var waterdelegate : LCWaterfallLayoutDelegate?//代理对象
    //内部属性
    var columnSpacing : NSInteger? = 5//列间距
    var rowSpacing : NSInteger? = 5//行间距
    var Section : UIEdgeInsets? = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)//section与collectionview的间距
    var maxYArr :NSMutableDictionary?//记录最大Y值
    var attrubutesArr :[UICollectionViewLayoutAttributes]?//存储每个item布局属性
    //外部设置内部间距属性方法
    public func setColumnSpacing(columnspacing:NSInteger,rowspacing:NSInteger,sectionInset:UIEdgeInsets){
        self.columnSpacing = columnspacing
        self.rowSpacing = rowspacing
        self.Section = sectionInset
    }
    //准备布局
    override func prepare() {
        super.prepare()
        //初始化数组
        self.maxYArr = NSMutableDictionary()
        self.attrubutesArr = [UICollectionViewLayoutAttributes]()
        //for循环加入最大Y值
        for i in 0..<Int(self.columnCount!) {
            maxYArr?[i] = (self.Section?.top)
        }
        let items = self.collectionView?.numberOfItems(inSection: 0)
        self.attrubutesArr?.removeAll()
        //初始化布局属性
        for i in 0..<Int(items!) {
            let attrubutes : UICollectionViewLayoutAttributes = self.layoutAttributesForItem(at: NSIndexPath(item: i, section: 0) as IndexPath)!
            self.attrubutesArr?.append(attrubutes)
        }
    }
    //计算每个item的布局属性
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        //初始化布局属性
        let att = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        //获取collectionview的宽度
        let collectionWidth = self.collectionView?.frame.size.width
        let left = (self.Section?.left)!
        let right = (self.Section?.right)!
        let spac = (self.columnCount! - 1) * (self.columnSpacing)!
        let spacingWidth = (collectionWidth! - left - right - CGFloat(spac))
        //计算每个item的宽度
        let itemWidth =  spacingWidth / CGFloat(self.columnCount!)
        var itemheight :CGFloat?
        //获取每个item的高度
        if self.waterdelegate != nil {
             itemheight = self.waterdelegate?.lcwaterfallLayout(waterfallLayout: self, itemwidth: itemWidth, atindexpath: indexPath as NSIndexPath)
        }
        //找出最短的一列
        var numberoflin = 0
        for (key,value) in self.maxYArr! {
            if self.maxYArr![numberoflin]as! CGFloat > value as! CGFloat{
                numberoflin = key as! Int
            }
        }
        //计算出item的X值
        let itemX = (self.Section?.left)! + (CGFloat(self.columnSpacing!) + itemWidth) * CGFloat(numberoflin)
        //计算出item的Y值
        let itemY = self.maxYArr?[numberoflin] as! CGFloat + CGFloat(self.rowSpacing!)
        //设置布局属性
        att.frame = CGRect(x: itemX, y: itemY, width: itemWidth, height: itemheight!)
        //更新字典
        self.maxYArr?[numberoflin] = itemY + itemheight!
        return att
    }
    //返回rect范围内item的布局属性
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrubutesArr
    }
    //计算collectionview的size
    override var collectionViewContentSize: CGSize{
        //找出最短的一列
        var maxYvalue = CGFloat()
        for (_,value) in self.maxYArr! {
            if value as! CGFloat > maxYvalue {
                maxYvalue = value as! CGFloat
            }
        }
        return CGSize(width: 0, height: maxYvalue + (self.Section?.bottom)!)
    }

}
