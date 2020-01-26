dashboardPage(
  
dashboardHeader(title = 'My Dashboard'
        
    ),
dashboardSidebar(
        sidebarUserPanel('Marina Ma',
                         image = 'profile.JPG',
                         'NYC Data Science Fellow'),
        
        sidebarMenu(menuItem('Overview', tabName = 'overview', icon = icon('columns')),
                    menuItem('Measurement', tabName = 'measurement', icon = icon('funnel-dollar')),
                    menuItem('Geo Location', tabName = 'location', icon=icon('user-shield')),
                    menuItem('Insight', tabName = 'insight', icon=icon('lightbulb'))
                    
        )
    ),
dashboardBody(
       tabItems(
           tabItem(tabName = 'overview',
           fluidRow(
            valueBoxOutput("sales"),
            valueBoxOutput("spend"),
            valueBoxOutput("roi")),
           fluidRow(selectizeInput(inputId = 'selected', label = 'Time Period', choices = choices),
            box(title = 'Store & Online Sales Ratio',
                status = 'info',
                solidHeader = T,
                width = 6,
                collapsible = T,
                htmlOutput('category')),
           box(title = 'ROI by Channel',
               status = 'info',
               solidHeader = T, 
               width = 6,
               collapsible = T, 
               plotlyOutput('romi', height = 300))
        )
           ),
       tabItem(tabName = 'measurement',
               fluidRow(
                   selectizeInput('channel', 'Channel', channel_list), 
                   box(title='CPM by Channel',
                            status = 'info',
                            solidHeader = T,
                            width = 6,
                            collapsible = T,
                            plotlyOutput('cpm', height = 300)
                            ), 
                   box(title='Optmization by Channel',
                            status = 'info',
                            solidHeader = T,
                            width = 6,
                            collapsible = T,
                            plotlyOutput('optimization', height = 300)
                            )
                        )
               ),
       tabItem(tabName = 'location', 
               fluidRow(
                 selectizeInput('quarter', 'Time Period', choices),
                 box(title = 'Store Sales by Geo', 
                   status = 'info', 
                   solidHeader = T, 
                   width = 6, 
                   collapsible = T, 
                   htmlOutput('location')),
                 box(title = 'Online Sales by Geo', 
                     status = 'info', 
                     solidHeader = T, 
                     width = 6, 
                     collapsible = T, 
                     htmlOutput('geo'))
              
                   
         )
           ),
       tabItem(tabName = 'insight',
               fluidRow(infoBox(title = 'Background', width = 8, icon = shiny::icon("store"),subtitle = 'This practice aims to help a CPG brand to discover the sales contribution from both ecommerce and stores across the US using data from the past two years. Also, we want to see how effective each major marketing channel is from ROI and CPM perspective in order to make marketing investment decisions.')),
               fluidRow(infoBox(title ='findings #1', icon = shiny::icon("book-open"),subtitle = 'store sales plays a larger part in the overall sales each quarter, accounting for more than 2/3.')),
               fluidRow(infoBox('findings #2', icon = shiny::icon("book-open"),subtitle = 'top markets/states that contribute to higher sales from both in-store locations and ecommerce are highly similar.')),
               fluidRow(infoBox('findings #3', icon = shiny::icon("book-open"),subtitle = 'the highest ROI-driven channel comes from social in any quarter during the last two years though it is not the highest invested channel.')),
               fluidRow(infoBox('findings #4',icon = shiny::icon("book-open"),subtitle = 'consider increasing spend for social and search channels as they have not hit the diminishing return point yet.'))
               
               
    )
       )
#for dashboard body       
    )
    
#below brace is for dashboardpage    
)