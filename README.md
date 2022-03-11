# Rshiny
R-shiny, Diamond project

1. the fileInput let the user upload a tab separated file of data. 
https://www.dropbox.com/s/ipdff06edkjlotz/diamonds.txt?dl=1
2. When the user uploads the data, render the data using DT::dataTableOutput and a histogram of the
carat column.
3. A slider that automatically subsets the data, updating the DataTable and the histogram. The
slider should range from 1 to the number of rows in the dataset.
4. An actionButton that resets the subsetted data back to the full datase
