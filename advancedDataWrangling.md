Advanced data wrangling
========================================================
author: 
date: 
autosize: true
transition: none
width: 1600

Goals of this lesson
========================================================

- Don't be a **dirty data** maker!
- Introduction to the tidyverse
- Manipulating strings using stringr  
- Combining data tables using join and bind  
- Working with dates  
- Selecting fields (review)  
- Subsetting with %in%  
- Summarizing data (review and new)  

I. Rules of the road for tidy data
====================================
type: section

1) Store all data in long format  
2) Do not store multiple levels of observation on one table
3) Do not store data at the same level of observation on multiple tables
4) Always start with raw data ... no derived variables!  
5) One data value per field  

I. Rules of the road for tidy data
========================================================

1) Store all data in long format  

  **Wide format data:**


|subject | mass2016| mass2017|
|:-------|--------:|--------:|
|A       |     13.2|     26.4|
|B       |     14.6|     15.2|
|C       |     27.1|     31.3|

I. Rules of the road for tidy data
========================================================

1) Store all data in long format

  **Long format data:**


|subject |year | value|
|:-------|:----|-----:|
|A       |2016 |  13.2|
|B       |2016 |  14.6|
|C       |2016 |  27.1|
|A       |2017 |  26.4|
|B       |2017 |  15.2|
|C       |2017 |  31.3|

I. Rules of the road for tidy data
========================================================

2) Do not store multiple levels of observation on one table

  **Don't do this:**


|subject |year | value| site| canopy| precip|
|:-------|:----|-----:|----:|------:|------:|
|A       |2016 |  13.2|    1|   13.3|   91.7|
|B       |2016 |  14.6|    1|   13.3|   91.7|
|C       |2016 |  27.1|    2|   26.8|   78.1|
|A       |2017 |  26.4|    1|   13.3|   91.7|
|B       |2017 |  15.2|    1|   13.3|   91.7|
|C       |2017 |  31.3|    2|   26.8|   78.1|

I. Rules of the road for tidy data
========================================================

2)  Do not store multiple levels of observation on one table

  **Do this:**


|subject |year | value| site|
|:-------|:----|-----:|----:|
|A       |2016 |  13.2|    1|
|B       |2016 |  14.6|    1|
|C       |2016 |  27.1|    2|
|A       |2017 |  26.4|    1|
|B       |2017 |  15.2|    1|
|C       |2017 |  31.3|    2|


| site| canopy| precip|
|----:|------:|------:|
|    1|   13.3|   91.7|
|    2|   26.8|   78.1|

I. Rules of the road for tidy data
========================================================

3) Do not store data at the same level of observation on multiple tables

  **Don't do this:**


|subject |year | value|
|:-------|:----|-----:|
|A       |2016 |  13.2|
|B       |2016 |  14.6|
|C       |2016 |  27.1|


|subject |year | value|
|:-------|:----|-----:|
|A       |2017 |  26.4|
|B       |2017 |  15.2|
|C       |2017 |  31.3|

I. Rules of the road for tidy data
========================================================
3) Do not store data at the same level of observation on multiple tables

  **Do this:**


|subject |year | value|
|:-------|:----|-----:|
|A       |2016 |  13.2|
|B       |2016 |  14.6|
|C       |2016 |  27.1|
|A       |2017 |  26.4|
|B       |2017 |  15.2|
|C       |2017 |  31.3|


I. Rules of the road for tidy data
========================================================

4) Always start with raw data ... no derived variables!

  **Don't do this:**


|subject |date       |year | value|
|:-------|:----------|:----|-----:|
|A       |2016-06-12 |2016 |  13.2|
|B       |2016-06-17 |2016 |  14.6|
|C       |2016-07-01 |2016 |  27.1|
|A       |2017-06-14 |2017 |  26.4|
|B       |2017-06-18 |2017 |  15.2|
|C       |2017-06-29 |2017 |  31.3|

I. Rules of the road for tidy data
========================================================

4) Always start with raw data ... no derived variables!

  **Do this:**


|subject |date       | value|
|:-------|:----------|-----:|
|A       |2016-06-12 |  13.2|
|B       |2016-06-17 |  14.6|
|C       |2016-07-01 |  27.1|
|A       |2017-06-14 |  26.4|
|B       |2017-06-18 |  15.2|
|C       |2017-06-29 |  31.3|

I. Rules of the road for tidy data
========================================================

5) One data value per field

  **Don't do this:**


|subject | value|sexYear |
|:-------|-----:|:-------|
|A       |  13.2|m2016   |
|B       |  14.6|f2016   |
|C       |  27.1|f2016   |
|A       |  26.4|m2017   |
|B       |  15.2|f2017   |
|C       |  31.3|f2017   |

I. Rules of the road for tidy data
========================================================

5) One data value per field

  **Don't do this:**


|subject |year | value|sexYear |
|:-------|:----|-----:|:-------|
|A       |2016 |  13.2|m       |
|B       |2016 |  14.6|f       |
|C       |2016 |  27.1|f       |
|A       |2017 |  26.4|m       |
|B       |2017 |  15.2|f       |
|C       |2017 |  31.3|f       |

II. The tidyverse: Tibbles and pipes oh my!
========================================================
![alt text](http://tidyr.tidyverse.org/logo.png)
![alt text](http://stringr.tidyverse.org/logo.png)
![alt text](http://readr.tidyverse.org/logo.png)


```r
install.packages('tidyverse')
install.packages('stringr')
install.packages('lubridate')
```

II. The tidyverse: Tibbles and pipes oh my!
========================================================

**Tibbles**:  
- Show a maximum of 10 rows for long data tables
- Show a reduced number of columns, if necessary
- Provide the dimensions of the data table
- Provide the class of fields in a data frame


```
  subject year value
1       A 2016  13.2
2       B 2016  14.6
3       C 2016  27.1
4       A 2017  26.4
5       B 2017  15.2
6       C 2017  31.3
```

II. The tidyverse: Tibbles and pipes oh my!
========================================================

**Tibbles**:  
- Show a maximum of 10 rows for long data tables
- Show a reduced number of columns, if necessary
- Provide the dimensions of the data table
- Provide the class of fields in a data frame


```
# A tibble: 6 × 3
  subject  year value
   <fctr> <chr> <dbl>
1       A  2016  13.2
2       B  2016  14.6
3       C  2016  27.1
4       A  2017  26.4
5       B  2017  15.2
6       C  2017  31.3
```

II. The tidyverse: Tibbles and pipes oh my!
========================================================
<img style="float: right; margin: 0px 15px 15px 0px;" src="http://revolution-computing.typepad.com/.a/6a010534b1db25970b01a3fd380b67970b-600wi">

The **Pipe operator (%>%)** allows you to pass output from an argument on the left to an argument on the right without assigning a name or nesting functions. 

For example, we can make use the _tbl_df_ function and a _pipe_ to turn a regular data frame to a tibble:

<br style="clear:both" />


```r
dataFrame %>%
  tbl_df
```

II. The tidyverse: Tibbles and pipes oh my!
========================================================

<img style="float: right; margin: 0px 15px 15px 0px;" src="http://revolution-computing.typepad.com/.a/6a010534b1db25970b01a3fd380b67970b-600wi">

The **Pipe operator (%>%)** allows you to pass output from an argument on the left to an argument on the right without assigning a name or nesting functions. 

For example, we can make use the _tbl_df_ function and a _pipe_ to turn a regular data frame to a tibble:

<br style="clear:both" />


```r
dataFrame %>%
  tbl_df
```

Note the convention to start a new line after each pipe. This is to make your code more readable.

II. The tidyverse: Tibbles and pipes oh my!
========================================================
We can read a data table into R directly as a tibble using the **readr** function _read_csv_. 


```r
read_csv(dataFrame.csv)
```


```
# A tibble: 6 × 3
  subject  year value
   <fctr> <chr> <dbl>
1       A  2016  13.2
2       B  2016  14.6
3       C  2016  27.1
4       A  2017  26.4
5       B  2017  15.2
6       C  2017  31.3
```

**Let's use read_csv to load the data for today's workshop!**

III. Data wrangling in the tidyverse: Rules of the road
========================================================
1) Start with raw data and DO NOT store intermediate files*  
2) Provide a new line of script for each operation, connected by pipes  
3) DO NOT assign names to intermediate files in a script unless absolutely necessary  

**Certainly do not do this:**

```r
dfLong2016 <- filter(dfLong, year == 2016)

write_csv(dfLong2016, 'dfLong2016.csv')

dfLong2016A <- filter(read_csv('dfLong2016.csv'), subject == 'A')

write_csv(dfLong2016A, 'dfLong2016A.csv')
```

III. Data wrangling in the tidyverse: Rules of the road
========================================================
1) Start with raw data and DO NOT store intermediate files*  
2) Provide a new line of script for each operation, connected by pipes  
3) DO NOT assign names to intermediate files in a script unless absolutely necessary  

**Do not do this either:**

```r
dfLong2016 <- filter(dfLong, year == 2016)

dfLong2016A <- filter(dfLong2016, subject == 'A')

dfLong2016A
```

III. Data wrangling in the tidyverse: Rules of the road
========================================================
1) Start with raw data and DO NOT store intermediate files*  
2) Provide a new line of script for each operation, connected by pipes  
3) DO NOT assign names to intermediate files in a script unless absolutely necessary  

**Do this:**

```r
dfLong %>%
  filter(
    year == 2016,
    subject == 'A'
    )
```

IV. dplyr review
========================================================


IV. String manipulation in stringr
========================================================
<img style="float: left; margin: 0px 15px 15px 0px;" src="http://www.catster.com/wp-content/uploads/2015/06/cat_with_string.jpg">

Manipulating strings is a common data task that **stringr** has greatly simplified.  

Here we'll look at the functions:

<br style="clear:both" />

- *str_to_upper*: Make strings all upper case
- *str_detect*: Detect a string within a value
- *str_trim*: Remove white space from a string
- *str_replace_all*: Replace characters in a string
- *str_sub*: Extract part of a string by position

IV. String manipulation in stringr
========================================================
*str_to_upper*





```r
sp
```

```
 [1] "NOCA" "BCCH" "GRCA" "Sosp" "SOSP" "grca" "sosp" "Grca" "HOWR" "bcch"
[11] "AMRO" "howr" "CARW" "noca" "amro" "NOMO" "Amro" "Carw" "carw" "EAPH"
[21] "RBWO"
```

```r
sp %>%
  str_to_upper %>%
  unique
```

```
 [1] "NOCA" "BCCH" "GRCA" "SOSP" "HOWR" "AMRO" "CARW" "NOMO" "EAPH" "RBWO"
```

IV. String manipulation in stringr
========================================================

IV. Combining data tables using join and bind
========================================================

V. Working with dates
========================================================

VI. Selecting fields (review) 
========================================================

VII. Subsetting with %in%
========================================================

VIII. Summarizing data
========================================================

