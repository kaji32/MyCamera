//
//  EffectView.swift
//  MyCamera
//
//  Created by 中嶋真太郎 on 2023/05/22.
//

import SwiftUI

struct EffectView: View {
    @Binding var isShowSheet: Bool
    let captureImage : UIImage
    @State var showImage:UIImage?
    let filterArray = [
                        "CIPhotoEffectMono",
                        "CIPhotoEffectChrome",
                        "CIPhotoEffectFade",
                        "CIPhotoEffectInstant",
                        "CIPhotoEffectNoir",
                        "CIPhotoEffectProcess",
                        "CIPhotoEffectTonal",
                        "CIPhotoEffectTransfer",
                        "CISepiaTone"
                        ]
    
    @State var filterSelectNumber = 0
    
    var body: some View {
        VStack{
            Spacer()
            
            if let showImage{
                Image(uiImage:showImage)
                    .resizable()
                    .scaledToFit()
            }
            
            Spacer()
            
            Button{
                let filterName = filterArray[filterSelectNumber]
                
                filterSelectNumber += 1
                if filterSelectNumber == filterArray.count{
                    filterSelectNumber = 0
                }
                
                
                let rotate = captureImage.imageOrientation
                let inputImage = CIImage(image:captureImage)
                
                guard let effectFilter = CIFilter(name: filterName)else{
                    return
                }
                
                effectFilter.setDefaults()
                
                effectFilter.setValue(inputImage, forKey: kCIInputImageKey)
                
                guard let outputImage = effectFilter.outputImage else{
                    return
                }
                
                let ciContext = CIContext(options: nil)
                
                guard let cgImage = ciContext.createCGImage(outputImage, from: outputImage.extent) else{
                    return
                }
                
                showImage = UIImage(
                    cgImage: cgImage,
                    scale: 1.0,
                    orientation: rotate
                )
                
            }label: {
                Text("エフェクト")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
            }
            .padding()
            
            if let showImage{
                let shareImage = Image(uiImage:showImage)
                
                ShareLink(item: shareImage, subject: nil, message:nil, preview:SharePreview("Photo", image:shareImage)){
                    Text("シェア")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                }
                .padding()
            }
            
            Button{
                
            }label: {
                Text("閉じる")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
            }
            .padding()
            
        }
        .onAppear{
            showImage = captureImage
        }
    }
}

