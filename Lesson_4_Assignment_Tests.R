library(testthat)

# each call to test_that() produces one test
# each test represents one point value
# you can have multiple tests for each question

library(readxl)
library(dplyr)
library(ggplot2)
fexp <- read_excel("FieldExperiment.xlsx")
fexp <- data.frame(fexp)
fexp$DATE <- as.Date(fexp$DATE)
fexp$WEEK <- factor(fexp$WEEK)


test_that("Q2 (visible)", {
  
  expect_true(dim(rep1)[1] == 10)
  expect_true(dim(rep1)[2] == 26)
  expect_equal(rep1$DMA_ID[1], 501)
  expect_equal(rep1$DMA_CONDITION[3], "3")
  expect_equal(rep1$GOOGLE_RETARGETING_CLICKS[6], 11)
  
})

test_that("Q3 (visible)", {
  
  expect_true(dim(rep1b)[1] == 10)
  expect_true(dim(rep1b)[2] == 26)
  expect_equal(rep1b$DMA_ID[2], 803)
  expect_equal(rep1b$DMA_CONDITION[3], "18")
  expect_equal(rep1b$GOOGLE_RETARGETING_CLICKS[6], 6)
  
})

test_that("Q4a (visible)", {
  
  expect_true(names(fexp4)[27] == "Tot_Imp")
  expect_equal(sum(fexp4$Tot_Imp), 13184393, tolerance = 10)
              
})
  
test_that("Q4b (visible)", {
  
  expect_true(names(fexp4)[28] == "Tot_Click")
  expect_equal(sum(fexp4$Tot_Click), 66802, tolerance = 10)
  
})

test_that("Q5 (visible)", {
  
  expect_true(names(fexp5)[29] == "CTR")
  expect_equal(sum(fexp5$CTR), 1813.163, tolerance = 1)
  
})

test_that("Q6 (visible)", {
  
  expect_equal(rep2$WebSales, 285249.4, tolerance = 1) 
  expect_equal(rep2$AmznSales, 12260.93, tolerance = 1) 
  
})

test_that("Q7 (visible)", {
  
  expect_equal(as.numeric(rep2b$WEEK[2]), 2, tolerance = 1e-2) 
  expect_equal(rep2b$WebSales[2], 97126.42, tolerance = 1) 
  expect_equal(rep2b$AmznSales[3], 4130.85, tolerance = 1) 
  
})

test_that("Q8 (visible)", {
  
  expect_equal(as.numeric(rep2c$WEEK[11]), 3) 
  expect_equal(rep2c$WebSales[6], 14760.27, tolerance = 1) 
  expect_equal(rep2c$AmznSales[13], 1325.37, tolerance = 1) 
  
})

test_that("Q9 (visible)", {
  
  expect_true(dim(rep2c)[1] == 15)
  expect_true(dim(rep2c)[2] == 5)
  expect_true(names(rep2c)[5] == "PercAmzn")
  expect_equal(rep2c$PercAmzn[3], .0723, tolerance = 1e-3) 
  expect_equal(rep2c$PercAmzn[6], .0282, tolerance = 1e-3) 
  expect_equal(rep2c$PercAmzn[13], .0363, tolerance = 1e-3) 
  
})

test_that("Q10 (visible)", {
  
  expect_true(dim(rep2d)[1] == 15)
  expect_true(dim(rep2d)[2] == 5)
  expect_true(names(rep2d)[5] == "PercAmzn")
  expect_equal(rep2d$PercAmzn[3], .0518, tolerance = 1e-3) 
  expect_equal(rep2d$PercAmzn[6], .0597, tolerance = 1e-3) 
  expect_equal(rep2d$PercAmzn[13], .0363, tolerance = 1e-3) 
  
})

Q12key <- ggplot(fexp, aes(x = AMAZON_US_SALES, y = SHOPIFY_US_SALES)) +
  geom_point() +
  scale_x_log10() +
  scale_y_log10()

test_that("Q12 (visible)", {
  
  expect_equal(Q12p$layers[[1]], Q12key$layers[[1]])
  expect_equal(Q12p$scales, Q12key$scales)
  expect_equal(Q12p$mapping, Q12key$mapping)
  expect_equal(Q12p$labels, Q12key$labels)
  
})

Q13key <- fexp %>% 
  filter(POPN > 500000) %>% 
  group_by(WEEK, DMA_NAME) %>% 
  summarize(WebSales = sum(SHOPIFY_US_SALES),
            AmznSales = sum(AMAZON_US_SALES)) %>% 
  ggplot(aes(x = AmznSales, y = WebSales)) +
  geom_point() +
  scale_x_log10() +
  scale_y_log10()

test_that("Q13 (visible)", {
  
  expect_equal(Q13p$layers[[1]], Q13key$layers[[1]])
  expect_equal(Q13p$scales, Q13key$scales)
  expect_equal(Q13p$mapping, Q13key$mapping)
  expect_equal(Q13p$labels, Q13key$labels)
  
})

Q14key <- fexp %>% 
  filter(POPN > 500000) %>% 
  group_by(WEEK, DMA_NAME) %>% 
  summarize(WebSales = sum(SHOPIFY_US_SALES),
            AmznSales = sum(AMAZON_US_SALES)) %>% 
  ggplot(aes(x = AmznSales, y = WebSales, color = WEEK)) +
  geom_point() +
  scale_x_log10() +
  scale_y_log10()

test_that("Q14 (visible)", {
  
  expect_equal(Q14p$layers[[1]], Q14key$layers[[1]])
  expect_equal(Q14p$scales, Q14key$scales)
  expect_equal(Q14p$mapping, Q14key$mapping)
  expect_equal(Q14p$labels, Q14key$labels)
  
})

Q15key <- fexp %>% 
  filter(DMA_NAME == "New York, NY") %>% 
  ggplot(aes(x = DATE, y = SHOPIFY_US_SALES)) +
  geom_line()

test_that("Q15 (visible)", {
  
  expect_equal(Q15p$layers[[1]], Q15key$layers[[1]])
  expect_equal(Q15p$scales, Q15key$scales)
  expect_equal(Q15p$mapping, Q15key$mapping)
  expect_equal(Q15p$labels, Q15key$labels)
  
})

Q16key <- fexp %>% 
  filter(POPN > 2500000) %>% 
  ggplot(aes(x = DATE, y = SHOPIFY_US_SALES, color = DMA_NAME)) +
  geom_line()

test_that("Q16 (visible)", {
  
  expect_equal(Q16p$layers[[1]], Q16key$layers[[1]])
  expect_equal(Q16p$scales, Q16key$scales)
  expect_equal(Q16p$mapping, Q16key$mapping)
  expect_equal(Q16p$labels, Q16key$labels)
  
})

Q17key <- fexp %>% 
  filter(POPN > 1300000) %>% 
  ggplot(aes(x = DATE, y = SHOPIFY_US_SALES)) +
  geom_line() +
  facet_wrap(~ DMA_NAME)

test_that("Q17 (visible)", {
  
  expect_equal(Q17p$layers[[1]], Q17key$layers[[1]])
  expect_equal(Q17p$scales, Q17key$scales)
  expect_equal(Q17p$mapping, Q17key$mapping)
  expect_equal(Q17p$labels, Q17key$labels)
  
})

Q18key <- fexp %>% 
  filter(POPN > 1300000) %>% 
  group_by(DMA_NAME) %>% 
  summarize(Tot_Sales = sum(SHOPIFY_US_SALES)) %>% 
  ggplot(aes(x = DMA_NAME, y = Tot_Sales)) +
  geom_col()

test_that("Q18 (visible)", {
  
  expect_equal(Q18p$layers[[1]], Q18key$layers[[1]])
  expect_equal(Q18p$scales, Q18key$scales)
  expect_equal(Q18p$mapping, Q18key$mapping)
  expect_equal(Q18p$labels, Q18key$labels)
  
})

Q19key <- fexp %>% 
  group_by(DMA_NAME) %>% 
  summarize(Tot_Sales = sum(SHOPIFY_US_SALES)) %>% 
  ggplot(aes(x = Tot_Sales)) +
  geom_histogram()

test_that("Q19 (visible)", {
  
  expect_equal(Q19p$layers[[1]], Q19key$layers[[1]])
  expect_equal(Q19p$scales, Q19key$scales)
  expect_equal(Q19p$mapping, Q19key$mapping)
  expect_equal(Q19p$labels, Q19key$labels)
  
})

Q20key <- fexp %>% 
  group_by(DMA_NAME) %>% 
  summarize(Tot_Sales = sum(SHOPIFY_US_SALES)) %>% 
  ggplot(aes(x = Tot_Sales)) +
  geom_histogram() +
  scale_x_log10()

test_that("Q20 (visible)", {
  
  expect_equal(Q20p$layers[[1]], Q20key$layers[[1]])
  expect_equal(Q20p$scales, Q20key$scales)
  expect_equal(Q20p$mapping, Q20key$mapping)
  expect_equal(Q20p$labels, Q20key$labels)
  
})

Q21key <- fexp %>% 
  filter(POPN > 2400000) %>% 
  ggplot(aes(x = DMA_NAME, y = AMAZON_US_SALES)) +
  geom_boxplot()

test_that("Q21 (visible)", {
  
  expect_equal(Q21p$layers[[1]], Q21key$layers[[1]])
  expect_equal(Q21p$scales, Q21key$scales)
  expect_equal(Q21p$mapping, Q21key$mapping)
  expect_equal(Q21p$labels, Q21key$labels)
  
})

