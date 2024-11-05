//
//  HomeLoadingView.swift
//  Weather
//
//  Created by Mark Davis on 10/26/24.
//

import SwiftUI

struct HomeLoadingView: View {
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Color.gray.opacity(0.5))
                .frame(width: 250, height: 70)
                .padding(.top, 120)
                .padding(.bottom, 20)
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Color.gray.opacity(0.5))
                .frame(width: 80, height: 80)
                .padding(.bottom, 20)
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Color.gray.opacity(0.5))
                .frame(width: 200, height: 70)
                .padding(.bottom, 30)
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Color.gray.opacity(0.5))
                .frame(width: 250, height: 70)
                .padding(.bottom, 30)
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Color.gray.opacity(0.5))
                .frame(width: 250, height: 70)
                .padding(.bottom, 10)
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .padding()
        .background(Color("BackgroundColor"))
    }
}

#Preview {
    HomeLoadingView()
}
