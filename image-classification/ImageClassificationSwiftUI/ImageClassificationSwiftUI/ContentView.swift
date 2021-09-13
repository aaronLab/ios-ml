//
//  ContentView.swift
//  ImageClassificationSwiftUI
//
//  Created by Mohammad Azam on 2/3/20.
//  Copyright © 2020 Mohammad Azam. All rights reserved.
//

import SwiftUI

let kImageClassificationSize: CGSize = CGSize(width: 224, height: 224)

struct ContentView: View {
    
    let photos = ["banana","tiger","bottle"]
    @State private var currentIndex: Int = 0
    @State private var classificationLabel: String = " "
    
    let model = MobileNetV2()
    
    private func performImageClassification() {
        
        let currentImageName = photos[currentIndex]
        
        guard let image = UIImage(named: currentImageName),
              let resizedImage = image.resizeTo(size: kImageClassificationSize),
              let buffer = resizedImage.toBuffer() else { return }
        
        if let output = try? model.prediction(image: buffer) {
            
            let result = output.classLabelProbs.sorted(by: { $0.1 > $1.1 }).first
            
            if let text = result.map({ "\($0)\n\($1 * 100)%" }) {
                
                classificationLabel = text
                
            }
            
        }
        
    }
    
    var body: some View {
        VStack {
            Image(photos[currentIndex])
            .resizable()
                .frame(width: 200, height: 200)
            HStack {
                Button("Previous") {
                    
                    if self.currentIndex >= self.photos.count {
                        self.currentIndex = self.currentIndex - 1
                    } else {
                        self.currentIndex = 0
                    }
                    
                    }.padding()
                    .foregroundColor(Color.white)
                    .background(Color.gray)
                    .cornerRadius(10)
                    .frame(width: 100)
                
                Button("Next") {
                    if self.currentIndex < self.photos.count - 1 {
                        self.currentIndex = self.currentIndex + 1
                    } else {
                        self.currentIndex = 0
                    }
                }
                .padding()
                .foregroundColor(Color.white)
                .frame(width: 100)
                .background(Color.gray)
                .cornerRadius(10)
            
                
                
            }.padding()
            
            Button("Classify") {
                // classify the image here
                performImageClassification()
            }.padding()
            .foregroundColor(Color.white)
            .background(Color.green)
            .cornerRadius(8)
            
            Text(classificationLabel)
                .font(.largeTitle)
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
