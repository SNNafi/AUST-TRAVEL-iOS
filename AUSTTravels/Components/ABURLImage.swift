//
//  ABURLImage.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 4/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import SwiftUI
import Combine

struct ABURLImage: View {
    @ObservedObject var imageFetcher: ImageFetcher
    @State private var image: UIImage = UIImage(named: "user")!
    
    init(imageURL: URL) {
        imageFetcher = ImageFetcher(imageURL)
    }
    
    var body: some View {
       Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .frame(width: 19.dWidth(), height: 19.dWidth(), alignment: .center)
            .onReceive(imageFetcher.didLoad) { data in
                self.image = UIImage(data: data) ??  UIImage(named: "user")!
            }
    }
}

//struct ABURLImage_Previews: PreviewProvider {
//    static var previews: some View {
//        ABURLImage()
//    }
//}


class ImageFetcher: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    var didLoad = PassthroughSubject<Data, Never>()
    var imageData = Data() {
        didSet {
            didLoad.send(imageData)
        }
    }
    
    init(_ url: URL) {
        URLSession.shared.dataTaskPublisher(for: url)
            .sink { _ in
                
            } receiveValue: { [weak self] (data, response) in
                DispatchQueue.main.async {
                    self?.imageData = data
                }
            }.store(in: &cancellables)

    }
}
