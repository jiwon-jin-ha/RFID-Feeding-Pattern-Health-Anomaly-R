# =========================================================================
# 01_RFID_Data_Cleaning.R
# Purpose: Implement cleaning rules on raw RFID feeder log data and 
#          filtering impossible data based on the farm information.
# Key Cleaning Rules: 1) Extract 4-digit Pig ID, 2) Filter data by 
#                     valid farm location (Compartment/Pen).
# =========================================================================

# Load necessary libraries
library(dplyr)
library(lubridate) 


# ----------------------------------------------------------------------
# 1. Combine Multiple Log Files from Different PCs for a Given Date
# ----------------------------------------------------------------------

#' Combine Multiple Raw RFID Data Files (from multiple PCs) for a Given Date
#' @param base_dir The root directory containing PC subfolders (e.g., 20240705_agrident_01)
#' @param date_str Date in YYYY-MM-DD format (e.g., "2024-04-09")
#' @return Combined raw data frame from all PCs
combine_raw_logs <- function(base_dir, date_str) {
  
  # Define the paths for all PC folders
  pc_folders <- list.dirs(base_dir, recursive = FALSE, full.names = TRUE)
  
  # Initialize an empty list to store data frames
  combined_list <- list()
  
  # Loop through each PC folder
  for (folder in pc_folders) {
    # Generate the file pattern (e.g., "LogFile 2024-04-09.*.txt")
    file_pattern <- paste0("LogFile ", date_str, ".*\\.txt$")
    log_files <- list.files(path = folder, pattern = file_pattern, full.names = TRUE)
    
    # Read and combine all files for the current date and PC
    if (length(log_files) > 0) {
      daily_data <- do.call(rbind, lapply(log_files, function(file) {
        # Read the file (adjust skip/header based on the actual raw format)
        data <- read.table(file, header = TRUE, sep = ";", skip = 1, stringsAsFactors = FALSE)
        # Add a column for the data source (PC/Room info might be useful later)
        data$source_folder <- basename(folder)
        return(data)
      }))
      combined_list[[folder]] <- daily_data
    }
  }
  
  # Combine data from all PCs
  final_combined_data <- bind_rows(combined_list)
  
  if (nrow(final_combined_data) == 0) {
    warning(paste("No data found across all PCs for date", date_str))
    return(NULL)
  }
  
  return(final_combined_data)
}

# ----------------------------------------------------------------------
# 2. Implement Cleaning Rules and Filtering
# ----------------------------------------------------------------------

#' Perform Farm Information Based Filtering (Pig ID and Location)
#' @param raw_data Combined raw data frame
#' @param pig_info_path Path to the pig ID and pen map file (e.g., "./data/pig_id_and_pen.csv")
#' @return Cleaned and merged data frame
clean_and_filter_data <- function(raw_data, pig_info_path = "./data/pig_id_and_pen.csv") {
  
  # 1. Extract 4-digit Pig ID from the RFID Tag (CC.NID)
  raw_data$ID <- substr(
    as.character(raw_data$CC.NID), 
    nchar(as.character(raw_data$CC.NID)) - 3, 
    nchar(as.character(raw_data$CC.NID))
  )
  
  # 2. Load and Merge Pig Information (Ensuring pig ID is valid)
  pig_info <- read.csv(pig_info_path, header = TRUE, stringsAsFactors = FALSE)
  pig_info$ID <- as.character(pig_info$ID)
  
  merged_data <- raw_data %>%
    left_join(pig_info, by = c("ID" = "ID"))
  
  # 3. Filter: Remove impossible data (pigs with invalid compartment/pen info)
  #    e.g., Only pigs in Compartment 3 Pen 1, C4 P1, and C4 P2 are physically possible.
  allowed_combinations <- data.frame(
    compartment = c(3, 4, 4),
    pen = c(1, 1, 2)
  )
  
  cleaned_data <- merged_data %>%
    semi_join(allowed_combinations, by = c("compartment", "pen"))
  
  return(cleaned_data)
}