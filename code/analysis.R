###############################################################################
# PLS-DA plot
###############################################################################

# subset flux dataframe into reactions from subsystem
plsda_for_subsystem <- function(subsystem, flux, groups_list, ellipse_logical = TRUE) {
  # get reactions from subsystem using python function
  reactions <- subsystem_reactions(subsystem)
  # extract rows with specified groups
  flux <- subset(flux, group %in% groups_list)
  # create vector with groups
  group <- flux$group
  # remove group column
  flux$group <- NULL
  # subset into subsystem dataframe
  subsystem_data <- flux[, colnames(flux) %in% reactions]
  # normalize data
  subsystem_data <- scale(subsystem_data, center = FALSE, scale = colSums(subsystem_data))
  
  pls_result <- mixOmics::splsda(subsystem_data, group)
  return(pls_result)
}

###############################################################################
# ttest
###############################################################################

# return tt-test results in html format
ttest_results <- function(groups_list, reaction, flux) {
  flux <- flux[, colnames(flux) %in% c(reaction, "group")] %>% as.data.frame()
  html_output <- glue("<title>{reaction} T-test comparison </title><br>")
  for (group1 in groups_list) {
    for (group2 in groups_list) {
      comparisongroups <- glue("{group1} vs {group2}<br>")
      sample1 <- flux[flux$group == group1, ]
      sample2 <- flux[flux$group == group2, ]
      
      if(length(sample1[1])!=0 && length(sample2[1]) != 0){
        lower_bound <-  stats::quantile(as.vector(unlist(sample1[1])), probs = 0.25) %>% unname()
        upper_bound <-  stats::quantile(as.vector(unlist(sample1[1])), probs = 0.75) %>% unname()
        sample1 <- sample1[1][sample1[1] < upper_bound & sample1[1] > lower_bound] #%>% as.vector(mode = list())
        
        
        lower_bound <-  stats::quantile(as.vector(unlist(sample2[1])), probs = 0.25) %>% unname()
        upper_bound <-  stats::quantile(as.vector(unlist(sample2[1])), probs = 0.75) %>% unname()
        sample2<- sample2[1][sample2[1] < upper_bound & sample2[1] > lower_bound] #%>% as.vector(mode = list())
        
        # ttest remove group names
        print(sample1)
        print(sample2)
        print("x")
        results <- t.test(as.numeric(sample1), as.numeric(sample2))
        print("after test")
        statistic_string <- toString(results$statistic)
        results_string <- glue("<p>P-value: {results$p.value} <span class='tab'></span> Statistic:  {statistic_string}<p> <br><br>")
      }else{results_string <- "NA"}
      html_output <- paste(html_output, comparisongroups, results_string)
    }
  }
  return(HTML(html_output))
}

###############################################################################
# get bounds
###############################################################################

get_bounds <- function(groups_list, reaction, flux) {
  flux <- flux[, colnames(flux) %in% c(reaction, "group")] %>% as.data.frame()
  html_output <- glue("<title>{reaction} Lower and Upperbound </title><br>")
  for (group in groups_list) {
    comparison <- glue("{group}<br>")
    lower_bound <-  stats::quantile(as.vector(unlist(flux[flux$group == group, ][1])), probs = 0.25) %>% unname() %>% toString()
    upper_bound <- stats::quantile(as.vector(unlist(flux[flux$group == group, ][1])), probs = 0.75) %>% unname() %>% toString()
    med <- stats::quantile(as.vector(unlist(flux[flux$group == group, ][1])), probs = 0.5) %>% unname() %>% toString()
    results_string <- glue("<p>Lower Bound: {lower_bound} <span class='tab'></span> Upper Bound:{upper_bound}<p>Median: {med} <span class='tab'></span> <br><br>")
    html_output <- paste(html_output, comparison, results_string)
  }
  return(HTML(html_output))
}