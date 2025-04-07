//
//  SettingsView.swift
//  Portsmouth
//
//  Created by Alex on 07.04.2025.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        ZStack {
            BackgoundView(img: .bgmenu)
            
            BackArrowButtonView()
            
            ZStack {
                SettingsFrame()
                
                VStack(spacing: 30) {
                    HStack(alignment: .bottom, spacing: 30) {
                        Image(.sound)
                            .resizable()
                            .frame(width: 75, height: 70)
                        
                        ToggleButtonView(name: "sound", isOn: true, action: {})
                    }
                    
                    HStack(alignment: .bottom, spacing: 30) {
                        Image(.music)
                            .resizable()
                            .frame(width: 75, height: 70)
                        
                        ToggleButtonView(name: "music", isOn: true, action: {})
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    SettingsView()
}

// MARK: - SettingsFrame
struct SettingsFrame: View {
    var body: some View {
        Image(.undrly)
            .resizable()
            .frame(maxWidth: 350, maxHeight: 400)
            .overlay(alignment: .top) {
                Image(.undrly2)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .offset(y: -40)
            }
            .overlay(alignment: .bottom) {
                Button {
                    // rate action
                } label: {
                    Image(.rateButton)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150)
                        .offset(y: 40)
                }
                .buttonStyle(.plain)
            }
            .padding()
    }
}

// MARK: - ToggleButtonView
struct ToggleButtonView: View {
    let name: String
    let isOn: Bool
    let action: () -> Void
    
    var body: some View {
        VStack {
            Text(name)
                .font(.system(size: 18, weight: .heavy, design: .monospaced))
                .foregroundStyle(.bloody)
            
            Button {
                withAnimation {
                    action()
                }
            } label: {
                Image(.undrly3)
                    .resizable()
                    .frame(width: 100, height: 50)
                    .overlay(alignment: isOn ? .trailing : .leading) {
                        Image(.circleButton)
                            .resizable()
                            .frame(width: 45, height: 45)
                            .overlay {
                                Text(isOn ? "on" : "off")
                                    .font(.system(size: 14, weight: .heavy, design: .monospaced))
                                    .foregroundStyle(.white)
                            }
                            .padding(.horizontal, 6)
                    }
            }
            .buttonStyle(.plain)
        }
    }
}
