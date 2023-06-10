packages <- c("shiny", "shinydashboard", "tidyr", "plotly", "dplyr", "readr", "stringr", "shinybrowser")
for (i in packages){
  if (!is.element(i,installed.packages()[,1])) {
    install.packages(i,dependencies = TRUE)
  }
}
lapply(packages, require, character.only = TRUE)

df_weapons <- read.csv("DS3_weapon.csv", header=TRUE)

damage_columns <- c("PhysicalDamage", "MagicDamage", "FireDamage", "LightningDamage", "DarkDamage")
reduction_columns <- c("PhysicalReduction", "MagicReduction", "FireReduction", "LightningReduction", "DarkReduction")
requirements_columns <- c("StrengthReq", "DexterityReq", "IntelligenceReq", "FaithReq")
bonuses_columns <- c("StrengthBonus", "DexterityBonus", "IntelligenceBonus", "FaithBonus")

df_weapons <- df_weapons %>% separate_wider_delim('Damage', delim="/", names=damage_columns)
df_weapons <- df_weapons %>% separate_wider_delim('Damage.Reduction', delim="/", names=reduction_columns)
df_weapons <- df_weapons %>% separate_wider_delim('Stat.Requirements', delim="/", names=requirements_columns)
df_weapons <- df_weapons %>% separate_wider_delim('Stat.Bonuses', delim="/", names=bonuses_columns)

df_weapons[damage_columns] <- sapply(df_weapons[damage_columns], as.numeric)
df_weapons[reduction_columns] <- sapply(df_weapons[reduction_columns], as.numeric)
df_weapons[requirements_columns] <- sapply(df_weapons[requirements_columns], as.numeric)
df_weapons[bonuses_columns] <- sapply(df_weapons[bonuses_columns], as.numeric)

df_rings <- read.csv("DS3_rings.csv", header=TRUE)

df_classes <- read.csv("DS3_classes.csv")

function(input, 
         output, session) {
  output$plot1 <- renderPlotly({
    p <- plot_ly(df_weapons, x=~Name, y=~PhysicalDamage, type="bar")
    p <- p %>% layout(barmode="overlay", xaxis = list(categoryorder = "total descending"))
    
    p
  })
  
  update_mins <- reactive({
    min_vig <- df_classes[df_classes$Classes == input$Class, ]$Vgr
    min_att <- df_classes[df_classes$Classes == input$Class, ]$Att
    min_end <- df_classes[df_classes$Classes == input$Class, ]$End
    min_vit <- df_classes[df_classes$Classes == input$Class, ]$Vit
    min_str <- df_classes[df_classes$Classes == input$Class, ]$Str
    min_dex <- df_classes[df_classes$Classes == input$Class, ]$Dex
    min_int <- df_classes[df_classes$Classes == input$Class, ]$Int
    min_fth <- df_classes[df_classes$Classes == input$Class, ]$Fth
    min_luck <- df_classes[df_classes$Classes == input$Class, ]$Luck
    
    output$vig_sl <- renderUI({
      sliderInput("Vig", "Vigor:",
                  min = min_vig, max = 99,
                  value = min_vig, step=1, width='600px')
    })
    output$att_sl <- renderUI({
      sliderInput("Att", "Attunement:",
                  min = min_att, max = 99,
                  value = min_att, step=1, width='600px')
    })
    output$end_sl <- renderUI({
      sliderInput("End", "Endurance:",
                  min = min_end, max = 99,
                  value = min_end, step=1, width='600px')
    })
    output$vit_sl <- renderUI({
      sliderInput("Vit", "Vitality:",
                  min = min_vit, max = 99,
                  value = min_vit, step=1, width='600px')
    })
    output$str_sl <- renderUI({
      sliderInput("Str", "Strength:",
                  min = min_str, max = 99,
                  value = min_str, step=1, width='600px')
    })
    output$dex_sl <- renderUI({
      sliderInput("Dex", "Dexterity:",
                  min = min_dex, max = 99,
                  value = min_dex, step=1, width='600px')
    })
    output$int_sl <- renderUI({
      sliderInput("Int", "Intelligence:",
                  min = min_int, max = 99,
                  value = min_int, step=1, width='600px')
    })
    output$fth_sl <- renderUI({
      sliderInput("Fth", "Faith:",
                  min = min_fth, max = 99,
                  value = min_fth, step=1, width='600px')
    })
    output$luck_sl <- renderUI({
      sliderInput("Luck", "Luck:",
                  min = min_luck, max = 99,
                  value = min_luck, step=1, width='600px')
    })
    
    output$weight_nm <- renderUI({
      numericInput("Weight", "Weight:", value=50, min=0, max=178.6)
    })
    
    output$class_image <- renderImage({
      filename <- normalizePath(file.path('./www/Classes',
                                          paste(input$Class, '.jpg', sep='')))
      list(src=filename, width="550px", height="825px")
    }, deleteFile=FALSE)
    count_level()
  })
  
  att_change <- reactive({
    list(input$Vig, input$Att, input$End, input$Vit, input$Str, input$Dex, input$Int, input$Fth, input$Luck)
  })
  
  count_level <- reactive({
    lvl <- df_classes[df_classes$Classes == input$Class, ]$LV
    lvl <- lvl + (input$Vig - df_classes[df_classes$Classes == input$Class, ]$Vgr)
    lvl <- lvl + (input$Att - df_classes[df_classes$Classes == input$Class, ]$Att) 
    lvl <- lvl + (input$End - df_classes[df_classes$Classes == input$Class, ]$End)
    lvl <- lvl + (input$Vit - df_classes[df_classes$Classes == input$Class, ]$Vit) 
    lvl <- lvl + (input$Str - df_classes[df_classes$Classes == input$Class, ]$Str) 
    lvl <- lvl + (input$Dex - df_classes[df_classes$Classes == input$Class, ]$Dex) 
    lvl <- lvl + (input$Int - df_classes[df_classes$Classes == input$Class, ]$Int) 
    lvl <- lvl + (input$Fth - df_classes[df_classes$Classes == input$Class, ]$Fth) 
    lvl <- lvl + (input$Luck - df_classes[df_classes$Classes == input$Class, ]$Luck)
    
    output$lvl <- renderText({paste("<b><font size=\"4\">Your current level: ", lvl, "</font></b>")})
    
  })
  
  observeEvent(att_change(), count_level())
  
  observeEvent(input$Class, update_mins())
}
