#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#wai ying zheng
#assignment 6 final, bs803

library(shiny)
library(DT)
library(datasets)



# Define UI for application 
ui <- fluidPage(
    
    # Application title
    titlePanel("Diamond Shiny App"),
    
    # Sidebar with fileinput for user to upload data, 
    #a slider for user to update the subset data
    #and a action button which let the user to reset the data
    sidebarLayout(
        sidebarPanel(
            fileInput(
                inputId="infile",
                label="Upload Data Here:",
                multiple = FALSE,
                accept =  c(".csv", ".tsv"),
                width = NULL,
                buttonLabel = "Browse...",
                placeholder = "No file selected"
            ),
            sliderInput(
                "num",
                "Subset Data",
                min = 0,
                max = 0,
              
                value = 0
            ),
            actionButton("resetButton", "Reset", class = "btn-light")
        ),
        
        # Show a plot of the generated distribution and data table
        mainPanel(plotOutput("distPlot"),
                  dataTableOutput("table")
                  
        )
    )
)

# Define server logic required to establish  reactive, set up the reset actionbutton, display the table, and draw a histogram
server <- function(input, output,session) {
    
  #establish reactive to read in the data
  #return the data that user upload from fileinput
    
    x<- reactive({
        if(is.null(input$infile))
            return (NULL)
        infile<-input$infile
        indata<-read.table(infile$datapath, header=TRUE, sep="\t")
        
        #update the slider value to default (display all data, max = num of row of the dataset)
        observe({
          updateSliderInput(
            session,
            "num",
            #the max here will be number of rows
            #step=1 to let the slider only take the whole number(e.g. 100, not 100.1)
            value=nrow(x()), min = 1, max = nrow(x()),step=1)
        })
        
        return (indata)
        
    })
    
    
    
    #create a data table which output the subset of the data table
    output$table<-DT::renderDataTable({
        DT::datatable(x()[1:input$num,])
    })
    
    #create a histogram which output the histogram of the carat col we subset
    output$distPlot <- renderPlot({
      # ?req #  require that the input is available  
        req(x())
        hist(as.numeric(unlist(x()[1:input$num,"carat"])),
        xlab="Diamond carat",main="Histogram of the carat column")
    })
    
    #as user reset, the slider input will update to display all data
    observeEvent(input$resetButton,{updateSliderInput(session,"num",value=nrow(x()),min=1)} )
    
    
}

# Run the application 
shinyApp(ui = ui, server = server)
