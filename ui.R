packages <- c("shiny", "shinydashboard", "dashboardthemes", "plotly", "shinythemes")

for (i in packages){
  if (!is.element(i,installed.packages()[,1])) {
    install.packages(i,dependencies = TRUE)
  }
}
lapply(packages, require, character.only = TRUE)

header <- dashboardHeader(
  title = span("DS 3 Weapon Advisor", span("dashboard", style="@import url('www/OptimusPrincepsSemiBold.ttf');* {font-family: OptimusPrincepsSemiBold;}"))
)

sidebar <- dashboardSidebar(
  tags$style(HTML("@import url('www/OptimusPrincepsSemiBold.ttf');")), #
  tags$style(HTML("* {font-family: OptimusPrincepsSemiBold;}")),
  sidebarMenu(
    menuItem("Welcome", tabName="Welcome", icon = icon("certificate", lib = "glyphicon")),
    menuItem("Stats", tabName="Stats", icon = icon("user", lib= "glyphicon")),
    menuItem("Dashboard", tabName="Dashboard", icon = icon("fire",lib = "glyphicon", style="color: rgb(255,128,0)")),
    menuItem("About", tabName="About", icon = icon("info-sign",lib = "glyphicon"))
  )
)

body <- dashboardBody(
  tags$style(HTML("@import url('www/OptimusPrincepsSemiBold.ttf');")), #
  tags$style(HTML("* {font-family: OptimusPrincepsSemiBold;}")),
  
  shinyDashboardThemes(
    theme = "grey_dark"
  ),
  
  tabItems(
    tabItem(tabName = "Welcome",
              img(src="PP_logotyp_ANG_RGB.png", width=756, height=124),
              
              br(),
              br(),
              
              h4("Authors: Kiril Andrukh & Uladzislau Lukashevich", style="font-family: OptimusPrincepsSemiBold"),
            
              br(),  
            
              p("This dashboard offers you the opportunity to facilitate the creation choosing a melee weapons for your build in the
                RPG game Dark Souls 3©, where the right leveling can greatly facilitate the game and help you enjoy its PVP and PVE components."),
            
              br(),
            
              p("To start using it, you need to press on 'Stats' tab and choose your class and your current stats.")
            ),
    tabItem(tabName = "Dashboard",
            box(
              title = "Histogram", status = "primary", solidHeader = TRUE, width = 12, plotlyOutput("plot1")
            )
    ),
    
    tabItem(tabName = "Stats",
            h1("Character Setup", style="font-family: OptimusPrincepsSemiBold", align="center"),
            
            p("In this tab you can choose the class and your current stats for your character so that we can more effectively offer melee weapons for it.", align="center"),
            
            p("When you are done you can go to 'Dashboard' tab.", align="center"),
            
            br(),
            
            fluidRow(
                div(class = "col-sm-5 col-md-5 col-lg-5",
                  box(title = "Character's Attributes", width = '100%', status="primary", solidHeader = TRUE,
                    selectInput(
                      "Class", "Select your class: ",
                      choices = c("Knight", "Mercenary", "Warrior",
                                  "Herald", "Thief", "Assassin", "Sorcerer",
                                  "Pyromancer", "Cleric", "Deprived"),
                      selected = "Knight",
                      width="600px"
                    ),
                    
                    uiOutput("weight_nm"),
                    
                    htmlOutput("lvl"),
                    br(),
                    uiOutput("vig_sl"),
                    uiOutput("att_sl"),
                    uiOutput("end_sl"),
                    uiOutput("vit_sl"),
                    uiOutput("str_sl"),
                    uiOutput("dex_sl"),
                    uiOutput("int_sl"),
                    uiOutput("fth_sl"),
                    uiOutput("luck_sl")
                  )
              ),
              
              div(class = "col-sm-7 col-md-7 col-lg-7",
                  imageOutput("class_image")),
              
              tags$style(".content {
                          min-height: 1200px;
                         }"),
              
              tags$style(HTML("
                    .box.box-solid.box-primary>.box-header {
                          color:#fff;
                          background:#2E4053; 
                        }
    
                        .box.box-solid.box-primary{
                          border-bottom-color:#C6D5ED;
                          border-left-color:#C6D5ED;
                          border-right-color:#C6D5ED;
                          border-top-color:#C6D5ED;
                          background:#2E4053;
                        }
                    "))
            )
    ),
    
    tabItem(tabName = "About",
            h2("About the development", style="font-family: OptimusPrincepsSemiBold"),
            
            br(),
            
            p("This assignments project functionality was inspired by DARK SOULS Character Planner - a tool designed to make it easier to create builds for
                a character in any of the Dark Souls series games, as we tried to implement some of its list of features"),
            p("We decided to focus on the datasets for Dark Souls 3, not to overload the dashboard with features. At the first step we decided
                that we are going to use only weapons dataset, but after some time we decided to add a possibility to choose certain rings, since they can affect 
                damage and 'Weight' parameter."),
            
            br(),
            
            p("The weapons dataset was downloaded from Kaggle: https://www.kaggle.com/datasets/l3llff/-dark-souls-3-weapon."),
            p("A link to the wiki page from which we downloaded rings dataset: https://darksouls3.wiki.fextralife.com/Rings"),
            p("A tool we used to import table from HTML to CSV format: https://www.convertcsv.com/html-table-to-csv.htm"),
            p("A link to the DARK SOULS 3 Character Planner: https://soulsplanner.com/darksouls3.")
    )
  )
)


dashboardPage(
  header,
  sidebar,
  body
)