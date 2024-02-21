
MADir <- "/Users/briabartsch/Desktop/FAST_HR_Data"

library(tidyverse)
library(rio)
fi <- list.files( MADir,'FAST_HR_Data',full.names = TRUE, recursive = FALSE)

MApossibles_tmp <- file.info(fi, extra_cols = FALSE) %>%
  as_tibble() %>%
  mutate(name = fi) %>%
  arrange(mtime) %>%
  slice_tail(n=1) %>%
  pull(name)

# Import file as data frame using `import()`
df <- import(MApossibles_tmp)

# Extract the specific range of rows
Subset_HR_Data <- df[601:2100, ]

# Calculate the average of the variable in the subset
MICT_HR_Average <- mean(Subset_HR_Data$`HR (bpm)`)




#IF you want to find the HR mins, maxes, and averages for each minute:
# Extract Time and Heart Rate columns
Times <- df$Time
Heart_Rates <- df$`HR (bpm)`

# Use strptime to convert the Time column to a POSIXct format
FormatTime <- strptime(Times, "%H:%M:%S")

# Extract the minute part of the time using the format function
Minutes <- format(FormatTime, "%M")

# Use tapply to group the heart rates by minute
MeanHR <- tapply(Heart_Rates, Minutes, mean)
MaxHR <- tapply(Heart_Rates, Minutes, max)
MinHR <- tapply(Heart_Rates, Minutes, min)

# Combine the results into a data frame
HR_Table <- data.frame(Min_HR = MinHR, Mean_HR = MeanHR, Max_HR = MaxHR)





#GRAPH HEART RATE:
#Load ggplot2 library
library(ggplot2)

# Calculate heart rate max. ENTER in Participants age. ****"26" is a placeholder****
HR_Max <- 220-26

# Calculate 64-76% of heart rate max
HR_77 <- 0.64 * HR_Max
HR_85 <- 0.76 * HR_Max

# Create a data frame with the time and heart rate columns
HR_Plot_Data <- data.frame(Time = FormatTime, HR = Heart_Rates)

# Create the plot
ggplot(data = HR_Plot_Data, aes(x = Time, y = HR)) +
  geom_line(color = "magenta") +
  scale_x_datetime(date_breaks = "5 mins", date_labels = "%H:%M:%S") +
  scale_y_continuous(breaks = seq(50, 200, by = 10)) +
  labs(x = "Time", y = "Heart Rate", title = "Heart Rate Over Time") +
  geom_ribbon(aes(ymin = HR_77, ymax = HR_85), fill = "blue", alpha = 0.2)

