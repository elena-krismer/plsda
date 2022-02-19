library(shiny)
library(mixOmics)
# use subsystem library created in python
library(reticulate)
library(dbplyr)
library(dplyr)
library(glue)
library(tidyverse)
library(stats)

source_python("code/code_chunks.py")
source("code/data_preprocessing.R")
source("code/analysis.R")
source("code/ui.R")
source("code/server.R")


#-------------------------------------------------------------------------------
# Shiny
#-------------------------------------------------------------------------------

shinyApp(ui, server)
