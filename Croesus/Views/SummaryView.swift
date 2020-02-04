//
//  SummaryView.swift
//  Croesus
//
//  Created by Bourne K on 03/02/2020.
//  Copyright © 2020 Triglobe Soft Solutions. All rights reserved.
//

import SwiftUI

struct SummaryView: View {
    var body: some View {
        GeometryReader { geometry in
            //
            NavigationView {
                Text("Hello, World!")
            }
        }.navigationBarTitle(Text("Summary"))
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView()
    }
}
