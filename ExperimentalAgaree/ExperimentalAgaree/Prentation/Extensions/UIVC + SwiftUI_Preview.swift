//
//  UIVC + SwiftUI_Preview.swift
//  ExperimentalAgaree
//
//  Created by Wonsang Hwang on 12/6/24.
//

import UIKit
import SwiftUI

extension UIViewController {
    
    enum DeviceType {
        case iPhoneSE2
        case iPhone8
        case iPhone12Pro
        case iPhone12ProMax
        
        func name() -> String {
            switch self {
            case .iPhoneSE2:
                return "iPhone SE"
            case .iPhone8:
                return "iPhone 8"
            case .iPhone12Pro:
                return "iPhone 12 Pro"
            case .iPhone12ProMax:
                return "iPhone 12 Pro Max"
            }
        }
    }
    
    private struct Preview: UIViewControllerRepresentable {
        let vc: UIViewController
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return vc
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
    func showPreview(on device: DeviceType) -> some View {
        Preview(vc: self).previewDevice(PreviewDevice(rawValue: device.name()))
    }
}


