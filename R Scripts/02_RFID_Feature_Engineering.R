# =========================================================================
# 02_RFID_Feature_Engineering.R
# Purpose: Define Meal Events using Bout Criterion (58.5s gap) and calculate 
#          the actual duration and summary of each meal event.
# Key Features: 1) Identify Meal Start/End, 2) Calculate Total Meal Duration.
# =========================================================================

# Load necessary libraries
library(dplyr)
library(lubridate) 

# ----------------------------------------------------------------------
# 1. Define Meal Events based on the 58.5 Second Criterion (Bout Logic)
# ----------------------------------------------------------------------

#' Group Consecutive Readings into Meal Events
#' @param cleaned_data A data frame containing cleaned, time-ordered readings.
#' @param meal_break_threshold The time gap (in seconds) that signifies the end of a meal. (Default: 58.5s)
#' @return Data frame with a 'meal_id' column grouping the readings into events.
define_meal_events <- function(cleaned_data, meal_break_threshold = 58.5) {
  
  # Ensure data is sorted by pig and time
  data_sorted <- cleaned_data %>%
    arrange(ID, timestamp)
  
  data_with_meals <- data_sorted %>%
    group_by(ID) %>%
    mutate(
      # 1. Calculate time difference (interval) since the previous reading
      time_interval = as.numeric(difftime(timestamp, lag(timestamp), units = "secs")),
      
      # 2. Identify a new meal start: If interval > threshold or first reading (NA)
      new_meal_start = ifelse(
        is.na(time_interval) | time_interval > meal_break_threshold, 
        1, 
        0
      ),
      
      # 3. Create a unique meal ID (cumulatively sum the new_meal_start flags)
      meal_id = cumsum(new_meal_start)
    ) %>%
    ungroup()
  
  return(data_with_meals)
}

# ----------------------------------------------------------------------
# 2. Summarize the Meal Events (Calculate Meal Duration)
# ----------------------------------------------------------------------

#' Summarize the Grouped Readings into Single Meal Event Records
#' @param data_with_meals Data frame grouped by meal_id.
#' @return Data frame where each row represents one complete meal event.
summarize_meal_events <- function(data_with_meals) {
  
  meal_summary <- data_with_meals %>%
    # Group by the newly created unique meal ID
    group_by(ID, meal_id) %>%
    summarise(
      # Meal Duration: Time difference between the LAST reading and the FIRST reading
      meal_duration_secs = as.numeric(difftime(max(timestamp), min(timestamp), units = "secs")),
      
      # Other essential metrics
      meal_start_time = min(timestamp),
      meal_end_time = max(timestamp),
      num_readings = n(), # Number of readings in the meal event
      
      .groups = "drop"
    )
  
  return(meal_summary)
}