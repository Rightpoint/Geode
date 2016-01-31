// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import UIKit

extension UIColor {
  convenience init(rgbaValue: UInt32) {
    let red   = CGFloat((rgbaValue >> 24) & 0xff) / 255.0
    let green = CGFloat((rgbaValue >> 16) & 0xff) / 255.0
    let blue  = CGFloat((rgbaValue >>  8) & 0xff) / 255.0
    let alpha = CGFloat((rgbaValue      ) & 0xff) / 255.0

    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}

extension UIColor {
  enum Name {
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 100% <br/> (0x000000ff)
    case Black
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#a162a1"></span>
    /// Alpha: 100% <br/> (0xa162a1ff)
    case Purple
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ffffff"></span>
    /// Alpha: 100% <br/> (0xffffffff)
    case White

    var rgbaValue: UInt32! {
      switch self {
      case .Black: return 0x000000ff
      case .Purple: return 0xa162a1ff
      case .White: return 0xffffffff
      }
    }
  }

  convenience init(named name: Name) {
    self.init(rgbaValue: name.rgbaValue)
  }
}
