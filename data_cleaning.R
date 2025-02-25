# Load necessary libraries
library(readxl)
library(dplyr)

# Load the dataset
file_path <- "Employees data.xlsx"
df <- read_excel(file_path)

# Rename columns if necessary (fix spaces in column names)
colnames(df) <- gsub(" ", "_", colnames(df))  # Replaces spaces with underscores

# View initial structure
str(df)
summary(df)

# Handle missing values
df$Name[is.na(df$Name)] <- "Unknown"
df$Department[is.na(df$Department)] <- "Unassigned"
df$Salary[is.na(df$Salary)] <- mean(df$Salary, na.rm = TRUE)

# Drop rows where Age or DOB is missing
df <- df[!is.na(df$Age) & !is.na(df$DOB), ]

# Convert columns to proper format
df$DOB <- as.Date(df$DOB)  # Convert DOB to Date format
df$Joining_Date <- as.Date(df$Joining_Date)  # Convert Joining_Date to Date format
df$Performance_Score <- as.factor(df$Performance_Score)  # Convert Performance Score to Factor

# Create new derived columns
df$Tenure <- as.numeric(difftime(Sys.Date(), df$Joining_Date, units = "days")) / 365

# Create Experience Level based on Tenure
df$Experience_Level <- case_when(
  df$Tenure < 2 ~ "Junior",
  df$Tenure >= 2 & df$Tenure < 5 ~ "Mid",
  df$Tenure >= 5 ~ "Senior",
  TRUE ~ NA_character_  # Handles any unexpected cases
)

# Save the cleaned dataset
write.csv(df, "cleaned_employees.csv", row.names = FALSE)

# View final structure
str(df)
summary(df)

# Print success message
print("cleaned_employees.csv has been successfully created!")
