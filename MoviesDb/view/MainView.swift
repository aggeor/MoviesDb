import SwiftUI

struct MainView: View {
    
    // 2 columns grid
    private let adaptiveColumns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    // Adjust frame for each movie card
    let frameWidth = UIScreen.main.bounds.width / 2.38
    let frameHeight = UIScreen.main.bounds.height / 3.87
    
    // ViewModel
    @StateObject var mainViewModel: MainViewModel = MainViewModel()
    
    // Search text
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                
                // MARK: Header with title and search
                VStack(spacing: 12) {
                    
                    // Search Field
                    TextField("Search movies...", text: $searchText)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal, 16)
                        .onSubmit {
                            // TODO: Call search endpoint with searchText
                            print("Search for: \(searchText)")
                        }
                    Text("Popular Movies")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                }
                .padding(.vertical, 12)
                .background(Color.black)
                
                // MARK: Movies ScrollView
                ScrollView {
                    LazyVGrid(columns: adaptiveColumns, spacing: 16) {
                        ForEach(mainViewModel.movies, id: \.id) { movie in
                            VStack(spacing: 8) {
                                // Movie poster
                                if let posterPath = movie.poster_path,
                                   let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                                .frame(width: frameWidth, height: frameHeight)
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: frameWidth, height: frameHeight)
                                                .clipped()
                                                .cornerRadius(12)
                                        case .failure:
                                            Color.gray
                                                .frame(width: frameWidth, height: frameHeight)
                                                .cornerRadius(12)
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                } else {
                                    Color.gray
                                        .frame(width: frameWidth, height: frameHeight)
                                        .cornerRadius(12)
                                }
                                
                                // Movie title
                                Text(movie.title ?? "")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
                .background(Color.black.edgesIgnoringSafeArea(.all))
            }
            .navigationBarHidden(true)
            .task {
                await mainViewModel.fetchFirst()
            }
        }
    }
}
