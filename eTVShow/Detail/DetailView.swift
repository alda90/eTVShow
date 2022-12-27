//
//  DetailView.swift
//  eTVShow
//
//  Created by Aldair Carrillo on 26/12/22.
//

import SwiftUI

class TVShowObject: ObservableObject {
    @Published var tvshow: TVShow?
    
    init(tvshow: TVShow? = nil) {
        self.tvshow = tvshow
    }
}

struct DetailView: View {
    @ObservedObject var tvShowObject: TVShowObject
    weak var navigationController: UINavigationController?
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color("background").edgesIgnoringSafeArea(.all)
            Image("orange")
                .resizable()
                .frame(height: UIScreen.main.bounds.height / 3)
           
            ScrollView {
                ZStack (alignment: .topTrailing) {
                    VStack(alignment: .leading) {
                        
                        Text("Summary")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.system(size: 16, weight: .semibold ))
                            .foregroundColor(Color("principal"))
                            .multilineTextAlignment(.leading)
                            .offset(x: 45, y: 35)
                        
                        Text(tvShowObject.tvshow?.name ?? "")
                            .frame(maxWidth: UIScreen.main.bounds.width - 160, alignment: .leading)
                            .foregroundColor(Color.white)
                            .font(.system(size: 17, weight: .semibold))
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                            .offset(x: 45, y: 40)
    
                        Text(tvShowObject.tvshow?.overview ?? "")
                            .frame(maxWidth: UIScreen.main.bounds.width - 75, alignment: .leading)
                            .font(.system(size: 12))
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.leading)
                            .offset(x: 45, y: 55)
                        
                        Text("CReated by Dan Harmond")
                            .frame(maxWidth: UIScreen.main.bounds.width - 75, alignment: .leading)
                            .foregroundColor(Color.white)
                            .font(.system(size: 14))
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                            .offset(x: 45, y: 70)
                        
                        Text("Last Season")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.system(size: 16, weight: .semibold ))
                            .foregroundColor(Color("principal"))
                            .multilineTextAlignment(.leading)
                            .offset(x: 45, y: 90)
                        
                        HStack {
                            Image("jesus")
                                .resizable()
                                .frame( width: 120, height: 160)
                            
                            VStack(alignment: .leading) {
                                Text("Season 4")
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 14, weight: .semibold))
                                    .multilineTextAlignment(.leading)
                                
                                Text(tvShowObject.tvshow?.formattedReleasedDate() ?? "")
                                    .foregroundColor(Color("principal"))
                                    .font(.system(size: 12))
                                    .multilineTextAlignment(.leading)
                                
                                Button(action: {
                                    navigationController?.popViewController(animated: true)
                                }) {
                                    Text("View all seasons")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color.white)
                                }
                                .frame(width: 160, height: 15)
                                .buttonStyle(RoundedRectangleButtonStyle())
                                .buttonStyle(BorderlessButtonStyle())
                                .buttonStyle(DefaultButtonStyle())
                                .padding(.top, 20)
                                
                            }.padding(.leading, 25)
                        } .offset(x: 45, y: 95)
                        
                        Text("Cast")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.system(size: 16, weight: .semibold ))
                            .foregroundColor(Color("principal"))
                            .multilineTextAlignment(.leading)
                            .offset(x: 45, y: 115)
                        
                        Spacer()

                    }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                     .background(Color("backgroundSplash"))
                     .padding(-20)
                     .clipShape(Corners())
                     .offset(y: (UIScreen.main.bounds.height / 3) - 60)
                    
                    Text("8.5")
                        .frame(width: 35, height: 35)
                        .foregroundColor(Color.white)
                        .background(Color("principal"))
                        .clipShape(Circle())
                        .shadow(radius: 4)
                        .padding(.trailing, 55)
                        .offset(y: (UIScreen.main.bounds.height / 3) - 80 )
                    
                    Button(action: {
                        
                    }) {
                        Text("\u{2606}")
                            .foregroundColor(Color("principal"))
                    }
                    .frame(width: 35, height: 35)
                    .padding(.trailing, 55)
                    .offset(y: (UIScreen.main.bounds.height / 3) - 30 )
                }
                .padding(0)
                .frame(width: UIScreen.main.bounds.width)
               
            }
            .padding(0)
            .frame(width: UIScreen.main.bounds.width)

        }.edgesIgnoringSafeArea(.top)
        
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(tvShowObject: TVShowObject())
    }
}
