//
//  ContentView.swift
//  Swift-Notion-API-Integration-Sample
//
//  Created by Gerson Janhuel on 15/05/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var userViewModel: UserViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                List(userViewModel.users) { user in
                    HStack {
                        Text(user.properties.Name.title[0].plain_text)
                        
                        Spacer()
                        
                        Text(user.properties.Email.rich_text[0].plain_text)
                            .font(.caption)
                    }
                    
                }
                .listStyle(InsetListStyle())
                .navigationBarItems(trailing:
                    Button(action: {
                        self.userViewModel.queryFromDatabase()
                    }, label: {
                        Text("Fetch")
                    })
                )
                .navigationTitle("Users")
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
            ContentView(userViewModel: UserViewModel())
            
        }
}
