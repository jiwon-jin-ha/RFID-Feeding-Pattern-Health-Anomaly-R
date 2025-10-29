# =========================================================================
# 03_Behavioral_Aggregation.R
# Purpose: Aggregate individual meal events into daily, pig-level behavioral 
#          metrics, and filter out unstable data from experiment start/end.
# Key Metrics: 1) Total Daily Feeding Duration, 2) Daily Meal Count, 
#              3) Average Meal Duration.
# =========================================================================

# Load necessary libraries
library(dplyr)
library(lubridate) 

# ----------------------------------------------------------------------
# 1. Function to Aggregate Meal Data at the Individual Pig Level (Daily)
# ----------------------------------------------------------------------

#' Aggregate Meal Events to Daily Pig-Level Feeding Patterns
#' @param meal_data A data frame containing meal events (output of 02_Feature_Engineering.R). 
#' @return Data frame with daily feeding metrics per pig (ready for statistical test).
aggregate_feeding_patterns <- function(meal_data) {
  
  # Step 1: Filter out the first 3 days and the last day of observations for each room
  # This filtering step ensures data stability across the experiment.
  pig_daily_filtered <- meal_data %>%
    # Ensure meal_start_time is converted to Date format
    mutate(date = as.Date(meal_start_time)) %>% 
    
    # Calculate min/max date for each room
    group_by(room) %>%
    mutate(
      min_date = min(date),
      max_date = max(date)
    ) %>%
    ungroup() %>%
    
    # Apply the filtering criteria: exclude first 3 days and the final day
    filter(
      date > (min_date + days(3)) & 
        date < max_date
    ) %>%
    select(-min_date, -max_date) # Remove temporary columns
  
  # Step 2: Calculate the key behavioral metrics
  # Note: Metrics use 'meal_duration_secs' (from the new Bout Logic in 02)
  aggregated_data <- pig_daily_filtered %>%
    group_by(room, pen, date, ID) %>% 
    summarise(
      total_duration_secs = sum(meal_duration_secs, na.rm = TRUE),          
      meal_count = n_distinct(meal_id),                                
      avg_meal_duration_secs = mean(meal_duration_secs, na.rm = TRUE), 
      .groups = "drop"
    )
  
  return(aggregated_data)
}

# ----------------------------------------------------------------------
# Example Usage: 
# ----------------------------------------------------------------------
# # 1. Load data from the previous step (e.g., final_meal_events.csv from 02)
# # final_meal_events <- read.csv("./data/final_meal_events.csv") 
# 
# # 2. Aggregate and filter the data
# # pig_daily_metrics <- aggregate_feeding_patterns(final_meal_events)
# 
# # 3. Save the file for the next step (Outlier/Statistical analysis)
# # write.csv(pig_daily_metrics, file = "./data/pig_daily_metrics.csv", row.names = FALSE)