//
//  EpisodeView.swift
//  eTVShow
//
//  Created by Aldair Carrillo on 27/12/22.
//

import SwiftUI

struct EpisodeView: View {
    @ObservedObject var viewModel = EpisodeViewModel()
    var seasons: [Season] = []
    var tvId: Int
    
    var body: some View {
        ZStack {
            Color("background").edgesIgnoringSafeArea(.all)
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack {
                    ForEach(seasons, id: \.id) { index in
                        Text(index.name)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.system(size: 16, weight: .semibold ))
                            .foregroundColor(Color("principal"))
                            .multilineTextAlignment(.leading)
                            .offset(x: 25)
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack {
                                let episodes = viewModel.episodes[index.seasonNumber ?? 0]
                                
                                ForEach(episodes ?? [Episode](), id: \.id) { epi in
                                    cardView(name: epi.name ?? "")
                                }
                               
                            }.onAppear {
                                viewModel.loadEpisdos(id: tvId, seasonNumber: index.seasonNumber ?? 0)
                            }

                        }
                        .frame(height: 130)
                        .offset(x: 25)

                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width)
            .padding(.top, 20)
           
        }
        .edgesIgnoringSafeArea(.top)
    }
}

struct EpisodeView_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeView(tvId: 0)
    }
}

struct cardView: View {
    var name: String?
    var body: some View {
        VStack(alignment: .leading) {
            Image("orange")
                .resizable()
                .aspectRatio(contentMode: .fill)
            Text(name ?? "")
                .multilineTextAlignment(.leading)
                .foregroundColor(Color.white)
                .font(.system(size: 11))
                .padding(.top, -20)
                .padding(.leading, 15)
                .frame(height: 55)

        }
        .frame(width: 210, height: 120)
        .background(Color("backgroundSplash"))
        .clipShape(Corners())
        .padding(2)
    }
}
