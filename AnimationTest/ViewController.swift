//
//  ViewController.swift
//  AnimationTest
//
//  Created by Wenslow on 2017/7/14.
//  Copyright © 2017年 com.ucard.app. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let card = AnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        
        view.addSubview(card)
        card.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.size.equalTo(CGSize(width: 200, height: 200))
        }
        
        let button = UIButton()
        let attDic = [NSFontAttributeName: UIFont.systemFont(ofSize: 20), NSForegroundColorAttributeName: UIColor.black]
        button.setAttributedTitle(NSAttributedString.init(string: "解锁", attributes: attDic), for: UIControlState.normal)
        view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.bottom.equalTo(view)
            make.size.equalTo(CGSize(width: 100, height: 100))
            make.centerX.equalTo(view)
        }
        button.addTarget(self, action: #selector(unlock), for: UIControlEvents.touchUpInside)
    }

    func unlock(){
        card.unlockAnimation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

