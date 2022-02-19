# get list of all documented subsystems in human1 for dropdownmenu
list_subsystem <- list_subsystems()

# groups for dropdown menu
groups <- c(
  "Brain metastasis", "Lung metastasis", "Breast cancer",
  "Brain tissue", "Lung tissue", "Breast tissue",
  "Glioblastoma", "GBM surrounding tissue", "Ependymoma",
  "Medullablastoma", "Pilocyticastrocytoma"
)

ui <- fluidPage(
  titlePanel("Partial Least Square Discriminant Analysis"),
  sidebarLayout(
    # ----------------------------------------------------------------------------
    # Side bar Panel
    # ----------------------------------------------------------------------------
    sidebarPanel(
      tags$form(
        checkboxGroupInput("group", "Select groups", groups),
        selectInput("subsystem", "Select subsystem", list_subsystem),
        sliderInput("cutoff", "Cut off  Variables with correlations below this cutoff in absolute value are not plotted ", value = 0.9, min = 0, max = 1)
      ),
      tags$form(
        textInput("reaction", "Get reaction description", "MAR06493"),
        actionButton("button", strong("Submit"))
      ),
      tags$form(
        h4(textOutput("reac")),
        h4(htmlOutput("description"))
      )
    ),
    # ----------------------------------------------------------------------------
    # Main Panel
    # ----------------------------------------------------------------------------
    mainPanel(
      # subsetting main panel into tabs
      tabsetPanel(
        type = "tabs",
        # plots
        tabPanel("Plot", plotOutput("plsda_samples"), plotOutput("plsda_var")),
        # reaction description
        tabPanel("Reaction Description", htmlOutput("table", height = 400, width = 800)),
        # link to kegg database
        tabPanel(
          "KEGG", h5(strong(textOutput("keggheader"))), textOutput("keggids"),
          textInput("reaction_search", "Reaction", "R02736"),
          htmlOutput("link")
        ),
        tabPanel(
          "Paired T-test", h5(strong(textOutput("ttestheader"))), textOutput("humanoneids"),
          textInput("reaction_ttest", "Reaction", "MAR00193"),
          htmlOutput("bounds"),
          htmlOutput("ttest_result", height = 800, width = 1600)
        )
      )
    )
  )
)

