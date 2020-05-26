//
//  StatusBarNavigationController.swift
//  UDEX
//
//  Created by Abai Abakirov on 5/26/20.
//  Copyright © 2020 MakeUseOf. All rights reserved.
//

import UIKit
import RxSwift

class StatusBarNavigationController: UINavigationController {
  private let disposeBag = DisposeBag()
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    App.instance.themeManager.currentTheme.statusBarStyle
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    App.instance.themeManager.currentThemeSubject.subscribe(onNext: { (theme) in
      self.setNeedsStatusBarAppearanceUpdate()
    }).disposed(by: disposeBag)
  }
}
