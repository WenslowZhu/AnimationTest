//
//  AnimationView.swift
//  AnimationTest
//
//  Created by Wenslow on 2017/7/14.
//  Copyright © 2017年 com.ucard.app. All rights reserved.
//

import UIKit
import SnapKit

class AnimationView: UIView {
    
    /// 背面
    fileprivate var backView: UIView?
    /// 正面
    fileprivate var frontView: UIView?
    /// 是否是正面朝上
    fileprivate var isFronted: Bool = true
    /// 上锁界面
    fileprivate let lockImageView = UIImageView(image: UIImage(named: "lock"))
    fileprivate let lockBlurView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.dark))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backView = UIView()
        addSubview(backView!)
        backView?.snp.makeConstraints({ (make) in
            make.edges.equalTo(self)
        })
        backView?.backgroundColor = UIColor.white
        backView?.layer.cornerRadius = 20
        backView?.layer.masksToBounds = true
        
        
        frontView = UIView()
        frontView?.backgroundColor = UIColor.blue
        addSubview(frontView!)
        frontView?.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        frontView?.layer.cornerRadius = 20
        frontView?.layer.masksToBounds = true
        
        //阴影
        backgroundColor = UIColor.white
        layer.cornerRadius = 20
        layer.shadowRadius = 20
        layer.shadowOpacity = 0.8
        layer.shadowColor = UIColor.yellow.cgColor
        
        //阴影添加渐变动画
        shadowAnimation()
        
        //添加翻转手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(rotateAnimation))
        addGestureRecognizer(tap)
        
        setLocked()//设置上锁效果
    }
    
    
    //MARK: 翻转动画
    func rotateAnimation(){
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
        
        let first = self.subviews.index(of: backView!)!
        let second = self.subviews.index(of: frontView!)!
        
        if isFronted {
            UIView.setAnimationTransition(UIViewAnimationTransition.flipFromLeft, for: self, cache: true)
            self.exchangeSubview(at: first, withSubviewAt: second)
        }else{
            UIView.setAnimationTransition(UIViewAnimationTransition.flipFromRight, for: self, cache: true)
            self.exchangeSubview(at: second, withSubviewAt: first)
        }
        
        UIView.commitAnimations()
        isFronted = !isFronted
    }
    
    //MARK: 设置上锁视图
    fileprivate func setLocked(){
        
        let lockBlurView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.dark))
        backView?.addSubview(lockBlurView)
        lockBlurView.snp.makeConstraints { (make) in
            make.edges.equalTo(backView!)
        }
        
        
        lockImageView.contentMode = UIViewContentMode.scaleAspectFit
        lockBlurView.contentView.addSubview(lockImageView)
        lockImageView.frame = CGRect(x: 50, y: 50, width: 100, height: 100)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.white.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.25, 0.5, 0.75]
        
        //设定渐变layer的Frame
        gradientLayer.frame = lockImageView.bounds
        gradientLayer.frame.origin.x = -375/3
        gradientLayer.frame.size.width = 375
        lockImageView.layer.addSublayer(gradientLayer)
        
        //渐变动画
        let gradientAnimation = CABasicAnimation(keyPath: "locations")
        gradientAnimation.fromValue = [0.0, 0.0, 0.25]
        gradientAnimation.toValue = [0.75, 1.0, 1.0]
        gradientAnimation.duration = 2
        gradientAnimation.repeatCount = Float.infinity
        gradientLayer.add(gradientAnimation, forKey: nil)
        
        //绘制mask
        let image = UIImage(named: "lock")
        let maskLayer = CALayer()
        maskLayer.backgroundColor = UIColor.clear.cgColor
        maskLayer.frame = lockImageView.bounds.offsetBy(dx: 370 / 3, dy: 0)
        maskLayer.contents = image?.cgImage
        gradientLayer.mask = maskLayer
    }
    
    //MARK: 阴影渐变动画
    func shadowAnimation(){
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = 0.8
        animation.toValue = 0.0
        animation.duration = 2
        animation.repeatCount = Float.infinity
        animation.autoreverses = true
        self.layer.add(animation, forKey: nil)
    }
    
    //MARK: 解锁动画
    func unlockAnimation() {
        
        if isFronted == true {return}
        
        let rect = CGRect(x: 0, y: 0, width: 200, height: 200)
        
        let emitter = CAEmitterLayer()
        emitter.frame = rect
        self.layer.insertSublayer(emitter, above: lockImageView.layer)
        
        emitter.emitterShape = kCAEmitterLayerRectangle
        emitter.emitterPosition = CGPoint(x: rect.width/2, y: rect.height/2)
        emitter.emitterSize = CGSize(width: 50, height: 50)
        
        let emitterCell = CAEmitterCell()
        emitterCell.contents = UIImage(named: "snowflake1")?.cgImage
        
        emitterCell.birthRate = 100
        emitterCell.lifetime = 1.5
        emitterCell.lifetimeRange = 1
        emitter.emitterCells = [emitterCell]
        
        emitterCell.velocity = 40
        emitterCell.velocityRange = 200
        emitterCell.emissionRange = CGFloat(Double.pi * 2)
        
        emitterCell.color = UIColor(red: 0.9, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
        emitterCell.redRange = 0.1
        emitterCell.greenRange = 0.1
        emitterCell.blueRange = 0.1
        
        emitterCell.scale = 1.5
        emitterCell.scaleRange = 0.8
        emitterCell.scaleSpeed = -0.15
        
        emitterCell.alphaRange = 0.75
        emitterCell.alphaSpeed = -0.15
        
        emitter.shadowColor = UIColor.white.cgColor
        emitter.shadowRadius = 50
        emitter.shadowOpacity = 0.0
        
        //emitter阴影渐变动画
        let shadowFade = CAKeyframeAnimation(keyPath: "opacity")
        shadowFade.duration = 4.0
        shadowFade.values = [0.0, 1.0, 0.0]
        shadowFade.keyTimes = [0.0, 0.5, 1.0]
        emitter.add(shadowFade, forKey: nil)
        
        //一秒之后不再产生粒子
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            emitter.birthRate = 0.0
        }
        
        let fade = CABasicAnimation(keyPath: "opacity")
        fade.fromValue = 1
        fade.toValue = 0
        fade.duration = 2
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
            self.lockImageView.removeFromSuperview()
            self.lockBlurView.removeFromSuperview()
        })
        
        lockBlurView.layer.add(fade, forKey: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
