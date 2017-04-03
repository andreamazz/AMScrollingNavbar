//
//  ScrollViewController.swift
//  ScrollingNavbarDemo
//
//  Created by Andrea Mazzini on 18/08/15.
//  Copyright (c) 2015 Fancy Pixel. All rights reserved.
//

import UIKit
import AMScrollingNavbar

class ScrollViewController: ScrollingNavigationViewController, ScrollingNavigationControllerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "ScrollView"

//        navigationItem.prompt = "Prompt"

        navigationController?.navigationBar.barTintColor = UIColor(red:0.17, green:0.59, blue:0.87, alpha:1)

        scrollView.backgroundColor = UIColor(red:0.13, green:0.5, blue:0.73, alpha:1)

        let label = UILabel(frame: CGRect(x: 10, y: 10, width: 0, height: 0))
        if let font = UIFont(name: "STHeitiSC-Light", size: 20) {
            label.font = font
        }
        scrollView.addSubview(label)

        // Fake some content
        label.text = lyrics.first
        label.numberOfLines = 0
        label.textColor = .white
        label.sizeToFit()

        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: label.frame.size.height)
        scrollView.delegate = self
    }

    func scrollingNavigationController(_ controller: ScrollingNavigationController, didChangeState state: NavigationBarState) {
        switch state {
        case .collapsed:
            print("navbar collapsed")
        case .expanded:
            print("navbar expanded")
        case .scrolling:
            print("navbar is moving")
        }
    }

    // Enable the navbar scrolling
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        navigationController?.navigationBar.barTintColor = UIColor(red:0.17, green:0.59, blue:0.87, alpha:1)

        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(scrollView, delay: 0.0)
            navigationController.scrollingNavbarDelegate = self
            navigationController.expandOnActive = false
        }
    }

    let lyrics = [
    "It's all in motion\nNo stoppin' now\nI've got nothin' to lose\nAnd only one way up\n\nI'm burning bridges\nI destroy the mirage\nOh, visions of collisions\nFuckin 'bon voyage\n\nIt's all smooth sailing\nFrom here on out\n\nI got bruises and hickies\nStitches and scars\nGot my own theme music\nIt plays wherever I are\n\nFear is the hand \nThat pulls your strings\nA useless toy\nPitiful plaything\n\nI'm inflagranti\nIn every way\n\nIt's all smooth sailing\nFrom here on out\nI'm gon' do the damage\nThat needs gettin' done\n\nGod only knows\nWhere love vacations\nIf reason is priceless\nThere's no reason to pay for it\n\nIt's so easy to see\nAnd so hard to find\nMake a mountain of a mole hill\nIf the mole hill is mine\n\nI hypnotize you\nAnd no one can find you\nI blow my load\nOver the status quo\nHere we go\n\nI'm a little bit nonchalant \nBut I dance\nI'm risking it always\nNo second chance\n\nIt's gonna be smooth sailing\nFrom here on out\nI'm gon' do the damage\n'Til the damage is done yeah\n\nGod only knows\nSo mind your behavior\nFollow prescriptions\nOf your lord and savior\n\nEvery temple is gold\nEvery hook is designed\nHell is but the temple\nOf the closed mind\nClosed mind\nClosed mind\nClosed mind\n\nIt's all smooth sailing\nFrom here on out\n\nShut up\n"
    ]
}
