# Lesson 4 Assignment - Data Manipulation with dplyr Part 1

# Your assignment is to write the commands instructed in the comments below. To run your
# commands, simply hit Ctrl+Enter (command+return on a MAC) when the cursor is on that 
# command line. You can also type commands directly into the Console below, but you must
# save them in this file for your assignment.


# We will again be using the data from the furniture seller, as we did last week. The 
# dataset fexp contains data on the company's advertising and sales from a three-week 
# period, from November 4 to November 24, 2019. The data should be loaded in the 
# Environment to the right. If it is not, run the six lines of code below to read in 
# the data and format it as a data frame.

# Do not change these six lines or GradeScope will not work
library(readxl)
library(dplyr)
fexp <- read_excel("FieldExperiment.xlsx")
fexp <- data.frame(fexp)
fexp$DATE <- as.Date(fexp$DATE)
fexp$WEEK <- factor(fexp$WEEK)


#1. Use the *names()* function to refresh your memory on the variables contained in fexp.
names(fexp)

# Most of the variable names are quite long. This has the advantage of making each 
# variable clear to a new user, like yourself. But long variable names are also quite 
# cumbersome to use. Let's make things easier on ourselves. 

#2. Create a new dataset, fexp2, that includes the following columns:
# DATE
# DMA_NAME
# DMA_CONDITION
# GP (shortened name for GOOGLE_PROSPECTING_SPEND)
# GR (shortened name for GOOGLE_RETARGETING_SPEND)
# GB (shortened name for GOOGLE_BRAND_SPEND)
# FP (shortened name for FACEBOOK_PROSPECTING_SPEND)
# FR (shortened name for FACEBOOK_RETARGETING_SPEND)
# WebSales (shortened name for SHOPIFY_US_SALES)
# POPN
# WEEK
fexp2 <- fexp %>% 
  select(DATE,
         DMA_NAME,
         DMA_CONDITION,
         GP = GOOGLE_PROSPECTING_SPEND,
         GR = GOOGLE_RETARGETING_SPEND,
         GB = GOOGLE_BRAND_SPEND,
         FP = FACEBOOK_PROSPECTING_SPEND,
         FR = FACEBOOK_RETARGETING_SPEND,
         WebSales = SHOPIFY_US_SALES,
         POPN,
         WEEK)

#3. You will be creating several reports about the advertising on Google and Facebook 
# that the furniture company did over the three-week period in the dataset. Create a 
# report showing the following numbers (variable names in parentheses): total spending 
# on Google Prospecting (GP_spend), on Google Retargeting (GR_spend), on Google Brand 
# (GB_spend), on Facebook Prospecting (FP_spend), on Facebook Retargeting (FR_spend), 
# on all three Google channels (Goog_spend), and on both Facebook channels (FB_spend). 
# Save it as SpendTotals.
SpendTotals <- fexp2 %>% 
  summarize(GP_spend = sum(GP),
            GR_spend = sum(GR),
            GB_spend = sum(GB),
            FP_spend = sum(FP),
            FR_spend = sum(FR),
            Goog_spend = GP_spend + GR_spend + GB_spend,
            FB_spend = FP_spend + FR_spend
            )

#4. Create a report called top10gp that shows the 10 DMAs that spent the most on Google 
# Prospecting, in descending order of Google Prospecting spend (GP_spend). The final 
# output should look like the file Top10GPSpend.png.
top10gp <- fexp2 %>% 
  group_by(DMA_NAME) %>% 
  summarize(GP_spend = sum(GP)) %>% 
  arrange(desc(GP_spend)) %>% 
  top_n(10) 

#5. Create a report called top10gr that shows the 10 DMAs that spent the most on Google 
# Retargeting (GR_spend), in descending order of Google Retargeting spend.
top10gr <- fexp2 %>% 
  group_by(DMA_NAME) %>% 
  summarize(GR_spend = sum(GR)) %>% 
  arrange(desc(GR_spend)) %>% 
  top_n(10) 

#6. Create a report called top10fp that shows the 10 DMAs that spent the most on Facebook 
# Prospecting (FP_spend), in decreasing order of Facebook Prospecting spend.
top10fp <- fexp2 %>% 
  group_by(DMA_NAME) %>% 
  summarize(FP_spend = sum(FP)) %>% 
  arrange(desc(FP_spend)) %>% 
  top_n(10) 


#7. Those reports are useful, but it's cumbersome to look at different reports. Create a 
# single report called top10spend that lists the 10 DMAs that spent the most on Google 
# Prospecting (GP_spend), in descending order, but also reports the amount those DMAs 
# spent on the other four advertising channels (GR_spend, GB_spend, FP_spend, and 
# FR_spend). The final output should look like the file Top10SpendAll.png.
top10spend <- fexp2 %>% 
  group_by(DMA_NAME) %>% 
  summarize(GP_spend = sum(GP),
            GR_spend = sum(GR),
            GB_spend = sum(GB),
            FP_spend = sum(FP),
            FR_spend = sum(FR)
            ) %>% 
  arrange(desc(GP_spend)) %>% 
  top_n(10, GP_spend)  

#8. The most important determinant of advertising spend seems to be population size. Let's 
# examine which regions spend more with the company relative to their population size. 
# Create a report called top25pcsales showing the 25 regions with the highest per capita 
# spending (total advertising spending / POPN; label it PCSales). The first ten lines of 
# the report should look like the file PCSalesTop25.png.
top25pcsales <- fexp2 %>% 
  group_by(DMA_NAME) %>% 
  summarize(TotAdSpend = sum(GP + GR + GB + FP + FR), population = mean(POPN)) %>% 
  mutate(PCSales = TotAdSpend / population) %>% 
  select(DMA_NAME, PCSales) %>% 
  arrange(desc(PCSales)) %>% 
  top_n(25)

#9. Let's take a look at how advertising expenditures vary by day (DATE). Create a report 
# called top5days that shows the 5 days with the largest total ad expenditures. Sort in 
# descending order of total ad spend (Total_Ad_Spend). Also include columns showing the 
# total amount spent on Google (across Prospecting, Retargeting, and Brand; label it 
# Total_Google_Spend) and the total amount spent on Facebook (across Prospecting and 
# Retargeting; label it Total_Facebook_Spend). The report should look like the file
# Top5AdDays.png.
top5days <- fexp2 %>% 
  group_by(DATE) %>% 
  summarize(Total_Ad_Spend = sum(GP + GR + GB + FP + FR),
            Total_Google_Spend = sum(GP + GR + GB),
            Total_Facebook_Spend = sum(FP + FR)) %>% 
  arrange(desc(Total_Ad_Spend)) %>% 
  top_n(5, Total_Ad_Spend)

#10. We have examined region-based summaries and date-based summaries of the data. Weekly 
# summaries by region are more common. Create a report called wksales that shows the weekly 
# sales (not advertising) for the following regions: "Albany, GA", "Alpena, MI", and 
# "Amarillo, TX". Label it TotSales. (If you ran this report for all regions, it would be 
# 630 rows long. The | symbol is equivalent to "or" and can be used to select multiple 
# regions.) The report should look like the file WeeklySalesByRegion.png.
wksales <- fexp2 %>% 
  filter(DMA_NAME == "Albany, GA" | DMA_NAME == "Alpena, MI" | DMA_NAME == "Amarillo, TX") %>% 
  group_by(DMA_NAME, WEEK) %>% 
  summarize(TotSales = sum(WebSales))

#11. Find the minimum, maximum, median, and mean weekly sales across all 210 regions (and 
# across all three weeks). That is, starting with the 630-row report of the weekly sales 
# across all 210 regions, find the minimum, maximum, median, and mean of the 630 sales 
# figures. Label them Min, Max, Medn, Mean. Save the report  as salesstats. (It should 
# be a report with one row.)
salesstats <- fexp2 %>% 
  group_by(DMA_NAME, WEEK) %>% 
  summarize(TotSales = sum(WebSales)) %>% 
  ungroup() %>% 
  summarize(Min = min(TotSales),
            Max = max(TotSales),
            Medn = median(TotSales),
            Mean = mean(TotSales))


