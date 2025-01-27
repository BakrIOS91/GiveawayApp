//
//  DetailedView.swift
//  Giveaway
//
//  Created by Bakr mohamed on 26/01/2025.
//

import SwiftUI
import Kingfisher

struct DetailedView: View {
    @Bindable var viewModel: DetailedViewModel
    
    var body: some View {
        ZStack {
            if viewModel.state.isLoading {
                LoaderView()
            } else {
                if let apiError = viewModel.state.apiError {
                    ErrorView(apiError: apiError)
                } else {
                    contentView
                }
            }
        }
        .task {
            viewModel.trigger(.loadItemDetail)
        }
        .if(!viewModel.state.apiError.isNil) { view in
            view
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            viewModel.trigger(.didPressOnBacButton)
                        } label: {
                            Image(systemName: "chevron.backward.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundStyle(.gray)
                        }
                    }
                }
        }
        .if(viewModel.state.apiError.isNil) {
            $0.toolbar(.hidden, for: .navigationBar)
        }
    }
    
    fileprivate var contentView: some View {
        VStack {
            ScrollView {
                ZStack(alignment: .top) {
                    itemImageView
                    
                    VStack(alignment: .leading) {
                        actionView
                        
                        Spacer()
                        
                        titleView
                    }
                    .padding()
                    .padding(.top, 30)
                }
                .frame(height: 300)
                
                VStack(alignment: .leading, spacing: 20) {
                    infoView
                    
                    sectionView(StringConstants.details_Platform, value: viewModel.state.giveawayItem?.platforms ?? "N/A")
                    
                    sectionView(StringConstants.details_End_Date, value: viewModel.state.giveawayItem?.endDate?.convertDate(from: "yyyy-MM-dd HH:mm:ss", to: "dd-MM-yyyy") ?? "N/A")
                    
                    sectionView(StringConstants.details_Description, value: viewModel.state.giveawayItem?.description ?? "N/A")
                }
                .foregroundStyle(.black)
                .padding(20)
            }
        }
        .ignoresSafeArea()
    }
    
    fileprivate var itemImageView: some View {
        KFImage(
            URL(string: viewModel.state.giveawayItem?.image ?? "")
        )
        .placeholder {
            Image(.placeholder)
                .resizable()
        }
        .resizable()
        .frame(height: 300)
        .overlay {
            Color.black.opacity(0.8)
        }
        .shadow(color: .black.opacity(0.5), radius: 8)
    }
    
    fileprivate var actionView: some View {
        HStack {
            Button {
                viewModel.trigger(.didPressOnBacButton)
            } label: {
                Image(systemName: "chevron.backward.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(.white)
            }
            
            Spacer()
            
            Button {
                viewModel.trigger(.didPressOnFavorite)
            } label: {
                Image(systemName: viewModel.state.giveawayItem?.isFavorite == true ? "heart.fill" : "heart")
                    .resizable()
                    .foregroundStyle(viewModel.state.giveawayItem?.isFavorite == true ? .red : .white)
            }
            .frame(width: 25, height: 25)
        }
    }
    
    fileprivate var titleView: some View {
        let title: String = "\(viewModel.state.giveawayItem?.title ?? "")  \(viewModel.state.giveawayItem?.isActive == true ? "✅" : "" )"
        return Text(title)
            .font(.title3)
            .fontWeight(.bold)
            .foregroundStyle(.white)
    }
    
    fileprivate var infoView: some View {
       HStack {
            VStack {
                Image(systemName: "singaporedollarsign.square.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                
                Text(viewModel.state.giveawayItem?.worth ?? "N/A")
                    .font(.callout)
                    .fontWeight(.bold)
                
            }
            .frame(width: 100)
           
            Divider()
           
            VStack {
                Image(systemName: "person.2.fill")
                    .resizable()
                    .frame(width: 40, height: 30)
                
                Text("\(viewModel.state.giveawayItem?.users ?? 0)")
                    .font(.callout)
                    .fontWeight(.bold)
                
            }
            .frame(width: 100)
           
            Divider()
           
            VStack {
                Image(systemName: "gamecontroller.fill")
                    .resizable()
                    .frame(width: 50, height: 30)
                
                Text(viewModel.state.giveawayItem?.type ?? "N/A")
                    .font(.callout)
                    .fontWeight(.bold)
                
            }
            .frame(width: 100)
        }
        .frame(height: 100)
        
    }
    
    fileprivate func sectionView(_ title: LocalizedStringKey, value: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(value)
                .font(.callout)
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    @Previewable @State var showDetaildScreen = false
//    NavigationStack {
//        VStack {
//            Button("show Detaild Screen"){
//                showDetaildScreen = true
//            }
//        }
//        .toolbar(.hidden, for: .navigationBar)
//        .navigationDestination(isPresented: $showDetaildScreen, destination: {
//            DetailedView(
//                viewModel: .init(
//                    1,
//                    isFavorite: false
//                )
//            )
//        })
//    }
    DetailedView(
        viewModel: .init(
            1,
            isFavorite: false
        )
    )
}
