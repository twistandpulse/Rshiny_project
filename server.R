
function(input,output){
    
    output$sales <- renderValueBox({
        valueBox(paste('$',format(round(as.numeric(sales.quarter$allchannel_sale), digits = 0), big.mark = ',')),
                 subtitle = paste('Highest Sales:', sales.quarter$cal_quarter))
    })
    
    output$spend <- renderValueBox({
        valueBox(paste('$',format(round(as.numeric(spend.quarter$allchannel_spend),digits = 0),big.mark = ',')),
                 subtitle = paste('Highest Spend:', spend.quarter$cal_quarter))
        
    })
    
    output$roi <- renderValueBox({
        valueBox(paste('$',format(round(as.numeric(roi.quarter$roi),digits = 2),big.mark = ',')),
                 subtitle = paste('Highest ROI:', roi.quarter$cal_quarter))
        
    })
    
    output$category <- renderGvis({
        pie_data = sales.category %>% 
            ungroup %>%
            filter(., cal_quarter == input$selected) %>% 
            select(., category, sales)
        
        gvisPieChart(pie_data, labelvar = 'category', numvar = 'sales',
                     options = list(height = 300, chartArea="{left:150,top:50,width:'100%',height:'80%'}"))
        
    })
    
    output$romi <- renderPlotly ({
        roi.channel<- ttlsales %>% 
            select(., search_sale,display_sale,social_sale, search_spend, display_spend, social_spend, cal_quarter) %>% 
            filter(., cal_quarter == input$selected) %>% 
            summarise(., search_roi=sum(search_sale)/sum(search_spend), display_roi=sum(display_sale)/sum(display_spend), social_roi=sum(social_sale)/sum(social_spend)) %>% 
            transpose() %>%
            mutate(., ROI=V1,Channel= c('Search','Display','Social'))
        
            ggplot(data = roi.channel, aes(x=Channel,y=ROI))+geom_bar(stat = 'identity', fill = 'lightblue')+
                scale_y_continuous(labels = scales::dollar_format())
        })
        
        
    output$cpm <- renderPlotly({
        cpm.stack %>% 
            filter(Channel==input$channel) %>% 
            ggplot(aes(x=Quarter,y = CPM))+geom_col(fill = 'lightblue')+
            scale_y_continuous(labels = scales::dollar_format())
            
    })

    output$optimization <- renderPlotly({
        optimization.channel %>% 
            filter(., Type==input$channel) %>% 
            ggplot(aes(x=Spend, y=Sales))+geom_point()+geom_smooth(se=F)+
            scale_x_continuous(labels = scales::dollar_format()) + 
            scale_y_continuous(labels = scales::dollar_format())
        
    })   
    
    store.state.new = reactive({
        store.state.new = store.state %>% 
            filter(., cal_quarter == input$quarter) %>% 
            group_by(., state) %>% summarise(., store_sales = sum(store_sales, na.rm=T))
    })
    
    output$location <- renderGvis({
        gvisGeoChart(store.state.new(), 
                     locationvar='state', 
                     colorvar='store_sales', 
                     options=list(region="US", displayMode="regions",
                                  resolution="provinces",
                                  width="auto", height="auto"))
        
    })
    
    output$geo <- renderGvis({
        
        online.state.new = online.state %>% 
            filter(., cal_quarter == input$quarter) %>% 
            group_by(., state) %>% summarise(., online_sales = sum(online_sales, na.rm=T))
        
        gvisGeoChart(online.state.new, 
                     locationvar='state', 
                     colorvar='online_sales', 
                     options=list(region="US", displayMode="regions",
                                  resolution="provinces",
                                  width="auto", height="auto"))
        
        
        
    })   

    
   
}