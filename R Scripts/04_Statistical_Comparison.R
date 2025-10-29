# =========================================================================
# 04_Statistical_Comparison.R
# Purpose: Perform final non-parametric statistical testing (Mann-Whitney U Test)
#          to compare feeding patterns between Sick Pigs and Healthy Pigs.
# =========================================================================

# Load necessary libraries
library(dplyr)
library(ggplot2)
# The 'stats' package (which contains wilcox.test) is loaded by default in R.

# ----------------------------------------------------------------------
# 1. Final Data Preparation (Aggregation and Merging - Based on sick pigs + feeding.R)
# NOTE: The merged_data should contain pig-daily feeding metrics (from 03) and 
#       weekly health status (from manual scoring data).
# ----------------------------------------------------------------------

# Example: Load the weekly aggregated data and merge with health status
# feeding_data_weekly <- read.csv("./data/pig_daily_metrics.csv")
# health_data_weekly <- read.csv("./manual_data/combined_health_data.csv") 

# merged_data <- feeding_data_weekly %>%
#   inner_join(health_data_weekly %>% select(ID, week, room, pen, Sick_pigs), 
#              by = c("ID", "week", "room", "pen"))

# ----------------------------------------------------------------------
# 2. Statistical Comparison: Mann-Whitney U Test (The Missing Piece)
# ----------------------------------------------------------------------

# A. Total Meal Duration Comparison
wilcox_duration_result <- merged_data %>%
  # Filter out NA/Inf values and ensure groups are defined
  filter(!is.na(total_duration_secs) & is.finite(total_duration_secs) & Sick_pigs %in% c("Yes", "No")) %>%
  
  # Perform the Mann-Whitney U test (wilcox.test is the R function)
  do(wilcox_test = wilcox.test(total_duration_secs ~ Sick_pigs, data = ., exact = FALSE))

print("Mann-Whitney U Test Result for Total Meal Duration:")
print(wilcox_duration_result$wilcox_test)


# B. Meal Count Comparison
wilcox_count_result <- merged_data %>%
  filter(!is.na(meal_count) & is.finite(meal_count) & Sick_pigs %in% c("Yes", "No")) %>%
  do(wilcox_test = wilcox.test(meal_count ~ Sick_pigs, data = ., exact = FALSE))

print("\nMann-Whitney U Test Result for Meal Count:")
print(wilcox_count_result$wilcox_test)


# ----------------------------------------------------------------------
# 3. Visualization (Boxplots for Presentation)
# ----------------------------------------------------------------------

# Visualization 1: Total Meal Duration
ggplot(merged_data, aes(x = Sick_pigs, y = total_duration_secs, fill = Sick_pigs)) +
  geom_boxplot(outlier.size = 1) + 
  stat_summary(fun = mean, geom = "point", shape = 18, size = 3, color = "black") +  # Add mean
  scale_fill_manual(values = c("No" = "cyan", "Yes" = "coral")) +
  labs(title = "Total Meal Duration by Health Status", x = "Health Status", y = "Total Meal Duration (sec)") + 
  theme_minimal()

# Visualization 2: Meal Count
ggplot(merged_data, aes(x = Sick_pigs, y = meal_count, fill = Sick_pigs)) +
  geom_boxplot(outlier.size = 1) + 
  stat_summary(fun = mean, geom = "point", shape = 18, size = 3, color = "black") + 
  scale_fill_manual(values = c("No" = "cyan", "Yes" = "coral")) +
  labs(title = "Meal Count by Health Status", x = "Health Status", y = "Meal Count") + 
  theme_minimal()

# ----------------------------------------------------------------------
# 4. Save Final Results
# ----------------------------------------------------------------------
# Save the p-values and statistics for reporting
# write.csv(wilcox_duration_result, file = "./outputs/wilcox_duration_pvalue.csv", row.names = FALSE)
# write.csv(wilcox_count_result, file = "./outputs/wilcox_count_pvalue.csv", row.names = FALSE)