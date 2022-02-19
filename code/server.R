server <- function(input, output, session) {
  # ----------------------------------------------------------------------------
  # PLS-DA plot
  # ----------------------------------------------------------------------------
  output$plsda_samples <- renderPlot({
    # get subsystem inpit
    x <- input$subsystem
    # use selected groups for subsetting df
    g_list <- input$group
    colors <- c( "#C177B3", "#468189", "#9DBEBB", "#65676F", 
                 "#ABCCA6", "#B395F2", "#535F97", "black", 
                 "#A7D87F", "#F3A020", "#20CAF3" )
    colors <- head(colors, length(g_list))
    plsda_result <- plsda_for_subsystem(x, flux, groups_list = g_list)
    plotIndiv(plsda_result, 
              ellipse = TRUE, title = x, 
              legend = TRUE, 
              col = colors )
  })
  # PLS- DA PLots with variable labels
  output$plsda_var <- renderPlot({
    x <- input$subsystem
    g_list <- input$group
    cutoff_defined <- input$cutoff
    plsda_result <- plsda_for_subsystem(x, flux, groups_list = g_list)
    plotVar(plsda_result, 
            cutoff = cutoff_defined)
  })
  
  # ----------------------------------------------------------------------------
  # reaction description look up
  # ----------------------------------------------------------------------------
  
  string_reac <- eventReactive(input$button, {
    return(input$reaction)
  })
  output$reac <- renderText({
    string_reac()
  })
  string <- eventReactive(input$button, {
    description <- get_reaction_description(input$reaction)
    x <- glue('{description}<br><br><a href="https://metabolicatlas.org/explore/Human-GEM/gem-browser/reaction/{input$reaction}"> "View Reaction on Metabolic atlas"</a>')
    return(x)
  })
  output$description <- renderUI({
    HTML(string())
  })
  
  # ----------------------------------------------------------------------------
  # description table
  # ----------------------------------------------------------------------------
  html_table_output <- function() {
    x <- input$subsystem
    cutoff_defined <- input$cutoff
    plsda_result <- plsda_for_subsystem(x, flux, groups_list = input$group)
    plotVar_data <- plotVar(plsda_result, cutoff = cutoff_defined)
    reaction_names <- rownames(plotVar_data)
    return(HTML(html_table(reaction_names)))
  }
  reaction_search_input <- output$table <- renderUI({
    html_table_output()
  })
  
  
  # ----------------------------------------------------------------------------
  # for KEGG look up
  # ----------------------------------------------------------------------------
  keggheader <- function() {
    cutoff <- input$cutoff
    header <- glue("KEGG IDs for Reaction with a correlation above: {cutoff}")
    return(header)
  }
  
  output$keggheader <- renderText({
    keggheader()
  })
  reaction_list <- function() {
    x <- input$subsystem
    cutoff_defined <- input$cutoff
    plsda_result <- plsda_for_subsystem(x, flux, groups_list = input$group)
    plotVar_data <- plotVar(plsda_result, cutoff = cutoff_defined)
    reaction_names <- rownames(plotVar_data)
    return(reaction_names)
  }
  output$keggids <- renderText(get_keggID(reaction_list()))
  getPage <- function() {
    kegg_link <- glue("https://www.genome.jp/dbget-bin/www_bget?rn:{input$reaction_search}")
    return(tags$iframe(
      src = kegg_link, style = "width:100%;", frameborder = "0",
      id = "iframe", height = "500px"
    ))
  }
  output$link <- renderUI({
    getPage()
  })
  
  # ----------------------------------------------------------------------------
  # T-test
  # ----------------------------------------------------------------------------
  ttestheader <- function() {
    cutoff <- input$cutoff
    header <- glue("HumanOne IDs for Reaction with a correlation above: {cutoff}")
    return(header)
  }
  output$ttestheader <- renderText({
    ttestheader()
  })
  output$humanoneids <- renderText(reaction_list())
  output$bounds <- renderUI({
    get_bounds(groups_list = input$group, reaction = input$reaction_ttest, flux = flux)
  })
  output$ttest_result <- renderUI({
    ttest_results(groups_list = input$group, reaction = input$reaction_ttest, flux = flux)
  })
}