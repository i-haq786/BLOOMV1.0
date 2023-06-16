//
//  BookMarkPage.swift
//  BLOOMFINAL
//
//  Created by Inzamam on 16/06/23.
//

import SwiftUI

struct Bookmark: Identifiable {
    let id = UUID()
    let title: String
    let website: String
}

struct BookmarkPage: View {
    @State private var bookmarks = [
        Bookmark(title: "Pottery Making", website: "Pottershouse"),
        Bookmark(title: "Horticulture", website: "Gardening School"),
        Bookmark(title: "Cooking Recipes", website: "Foodies Corner"),
        Bookmark(title: "Photography Tips", website: "ShutterBugs"),
        Bookmark(title: "Art History", website: "ArtGallery"),
        Bookmark(title: "Travel Guides", website: "Wanderlust"),
        Bookmark(title: "Fitness Workouts", website: "FitLife"),
        Bookmark(title: "Music Lessons", website: "MelodyMakers"),
        Bookmark(title: "Coding Tutorials", website: "CodeNinja"),
        Bookmark(title: "Fashion Trends", website: "StyleHub")
    ]
    
    var body: some View {
        VStack {
            Text("Bookmarks")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, -40)
            
            List {
                ForEach(bookmarks) { bookmark in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(bookmark.title)
                            .font(.headline)
                            .fontWeight(.bold)
                        Text(bookmark.website)
                            .font(.subheadline)
                    }
                }
                .onDelete { indices in
                    bookmarks.remove(atOffsets: indices)
                }
            }
        }
    }
}

struct BookmarkPage_Previews: PreviewProvider {
    static var previews: some View {
        BookmarkPage()
    }
}
