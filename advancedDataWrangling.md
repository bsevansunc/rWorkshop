Advanced data wrangling
========================================================
author: 
date: 
autosize: true
transition: none
width: 1400

R Workshop: Data management in R  
Brian S Evans  
Migratory Bird Center 

Goals of this lesson
========================================================
<img style="float: right; width:330px; height:330px; margin: 0px 10px 10px 0px;" src="https://pbs.twimg.com/profile_images/677589103710306304/m56O6Wgf.jpg">

- Introduction to the tidyverse
- tidyR and dplyr review
- Don't be a **dirty data** maker!
- Manipulating strings using stringr  
- Joining data
- Working with dates  
- Selecting fields (review)  
- Subsetting with %in%  



I. The tidyverse: Tibbles and pipes oh my!
========================================================
![alt text](http://tidyr.tidyverse.org/logo.png)
![alt text](http://stringr.tidyverse.org/logo.png)
![alt text](http://readr.tidyverse.org/logo.png)


```r
install.packages('tidyverse')
install.packages('stringr')
install.packages('lubridate')
```

I. The tidyverse: Tibbles and pipes oh my!
========================================================

**A typical data frame**:  

```
  subject year value
1       A 2016  13.2
2       B 2016  14.6
3       C 2016  27.1
4       A 2017  26.4
5       B 2017  15.2
6       C 2017  31.3
```

I. The tidyverse: Tibbles and pipes oh my!
========================================================

**Summary data on a typical data frame**:  

```r
class(dfLong$subject)
```

```
[1] "factor"
```

```r
str(dfLong)
```

```
'data.frame':	6 obs. of  3 variables:
 $ subject: Factor w/ 3 levels "A","B","C": 1 2 3 1 2 3
 $ year   : chr  "2016" "2016" "2016" "2017" ...
 $ value  : num  13.2 14.6 27.1 26.4 15.2 31.3
```

I. The tidyverse: Tibbles and pipes oh my!
========================================================

**Summary data on a typical data frame**:  

```r
nrow(dfLong)
```

```
[1] 6
```

```r
ncol(dfLong)
```

```
[1] 3
```

```r
dim(dfLong)
```

```
[1] 6 3
```

I. The tidyverse: Tibbles and pipes oh my!
========================================================

**Tibbles**:  
- Show a reduced number of rows and columns, if necessary  
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

I. The tidyverse: Tibbles and pipes oh my!
========================================================
<img style="float: right; margin: 0px 15px 15px 0px;" src="http://revolution-computing.typepad.com/.a/6a010534b1db25970b01a3fd380b67970b-600wi">

The **Pipe operator (%>%)** allows you to pass output from an argument on the left to an argument on the right without assigning a name or nesting functions. 

For example, we can make use the _tbl_df_ function and a _pipe_ to turn a regular data frame to a tibble:

<br style="clear:both" />


```r
dataFrame %>%
  tbl_df
```

I. The tidyverse: Tibbles and pipes oh my!
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

I. The tidyverse: Tibbles and pipes oh my!
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


II. Tidyr review
========================================================
<br style="clear:both" />
**tidyr** provides functions for tidying dirty data, including:

- _gather_: Convert wide to long data frame
- _separate_: Separate one column to several
- _arrange_: Order rows by a column

III. dplyr review
========================================================
<br style="clear:both" />
**dplyr** provides us with key data wrangling functions.  
Some of the most important of these functions are:

- _rename_: Rename columns of a data frame
- _filter_: Subset rows in a data table using logical conditions  
- _select_: Subset columns in a data table  
- _mutate_: Compute and apppend a new column to a data table  
- _mutate_all_: Apply a computation to all columns in a data table
- _bind_rows_: Bind the rows of two data tables together
- _group_by_: Group rows of data by some grouping variable  
- _summarize_: Calculate summary information for groups

<br style="clear:both" />

IV. Rules of the road for tidy data 
========================================================
<img style="float: right; width:330px; height:330px; margin: 0px 10px 10px 0px;" src="https://pbs.twimg.com/profile_images/677589103710306304/m56O6Wgf.jpg">

- Tidy data are easy to:
  - Manipulate
  - Summarize
  - Analyze
- Understanding dirty vs. clean data is key

IV. Rules of the road for tidy data 
========================================================
<br style="clear:both" />

**Dirty:**

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> subject </th>
   <th style="text-align:right;"> mass2016 </th>
   <th style="text-align:right;"> mass2017 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 13.2 </td>
   <td style="text-align:right;"> 26.4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 14.6 </td>
   <td style="text-align:right;"> 15.2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> C </td>
   <td style="text-align:right;"> 27.1 </td>
   <td style="text-align:right;"> 31.3 </td>
  </tr>
</tbody>
</table>

IV. Rules of the road for tidy data 
========================================================
<br style="clear:both" />

**Dirty (wide format):**

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> subject </th>
   <th style="text-align:right;"> mass2016 </th>
   <th style="text-align:right;"> mass2017 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 13.2 </td>
   <td style="text-align:right;"> 26.4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 14.6 </td>
   <td style="text-align:right;"> 15.2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> C </td>
   <td style="text-align:right;"> 27.1 </td>
   <td style="text-align:right;"> 31.3 </td>
  </tr>
</tbody>
</table>

IV. Rules of the road for tidy data 
========================================================
<br style="clear:both" />

1) Store all data in long format  

**Tidy (long format):**

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> subject </th>
   <th style="text-align:left;"> year </th>
   <th style="text-align:right;"> value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> A </td>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:right;"> 13.2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> B </td>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:right;"> 14.6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> C </td>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:right;"> 27.1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> A </td>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:right;"> 26.4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> B </td>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:right;"> 15.2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> C </td>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:right;"> 31.3 </td>
  </tr>
</tbody>
</table>

IV. Rules of the road for tidy data 
========================================================

<br style="clear:both" />

**Dirty:**

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> subject </th>
   <th style="text-align:left;"> year </th>
   <th style="text-align:right;"> value </th>
   <th style="text-align:right;"> site </th>
   <th style="text-align:right;"> canopy </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> A </td>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:right;"> 13.2 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 13.3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> B </td>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:right;"> 14.6 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 13.3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> C </td>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:right;"> 27.1 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 26.8 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> A </td>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:right;"> 26.4 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 13.3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> B </td>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:right;"> 15.2 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 13.3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> C </td>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:right;"> 31.3 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 26.8 </td>
  </tr>
</tbody>
</table>

IV. Rules of the road for tidy data 
========================================================

2) One level of observation per table

**Tidy:**

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> subject </th>
   <th style="text-align:left;"> year </th>
   <th style="text-align:right;"> value </th>
   <th style="text-align:right;"> site </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> A </td>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:right;"> 13.2 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> B </td>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:right;"> 14.6 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> C </td>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:right;"> 27.1 </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> A </td>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:right;"> 26.4 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> B </td>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:right;"> 15.2 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> C </td>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:right;"> 31.3 </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
</tbody>
</table>

<table>
 <thead>
  <tr>
   <th style="text-align:right;"> site </th>
   <th style="text-align:right;"> canopy </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 13.3 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 26.8 </td>
  </tr>
</tbody>
</table>

IV. Rules of the road for tidy data 
========================================================

<br style="clear:both" />

**Tidy:**

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> subject </th>
   <th style="text-align:left;"> year </th>
   <th style="text-align:right;"> value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> A </td>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:right;"> 13.2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> B </td>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:right;"> 14.6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> C </td>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:right;"> 27.1 </td>
  </tr>
</tbody>
</table>

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> subject </th>
   <th style="text-align:left;"> year </th>
   <th style="text-align:right;"> value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> A </td>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:right;"> 26.4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> B </td>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:right;"> 15.2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> C </td>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:right;"> 31.3 </td>
  </tr>
</tbody>
</table>

IV. Rules of the road for tidy data 
========================================================
<br style="clear:both" />

3) One table per level of observation

**Tidy:**

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> subject </th>
   <th style="text-align:left;"> year </th>
   <th style="text-align:right;"> value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> A </td>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:right;"> 13.2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> B </td>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:right;"> 14.6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> C </td>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:right;"> 27.1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> A </td>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:right;"> 26.4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> B </td>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:right;"> 15.2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> C </td>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:right;"> 31.3 </td>
  </tr>
</tbody>
</table>

IV. Rules of the road for tidy data 
========================================================
<br style="clear:both" />

**Dirty:**

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> subject </th>
   <th style="text-align:left;"> date </th>
   <th style="text-align:left;"> year </th>
   <th style="text-align:right;"> value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> A </td>
   <td style="text-align:left;"> 2016-06-12 </td>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:right;"> 13.2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> B </td>
   <td style="text-align:left;"> 2016-06-17 </td>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:right;"> 14.6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> C </td>
   <td style="text-align:left;"> 2016-07-01 </td>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:right;"> 27.1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> A </td>
   <td style="text-align:left;"> 2017-06-14 </td>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:right;"> 26.4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> B </td>
   <td style="text-align:left;"> 2017-06-18 </td>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:right;"> 15.2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> C </td>
   <td style="text-align:left;"> 2017-06-29 </td>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:right;"> 31.3 </td>
  </tr>
</tbody>
</table>

IV. Rules of the road for tidy data 
========================================================
<br style="clear:both" />

4) No derived variables!

**Tidy:**

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> subject </th>
   <th style="text-align:left;"> date </th>
   <th style="text-align:right;"> value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> A </td>
   <td style="text-align:left;"> 2016-06-12 </td>
   <td style="text-align:right;"> 13.2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> B </td>
   <td style="text-align:left;"> 2016-06-17 </td>
   <td style="text-align:right;"> 14.6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> C </td>
   <td style="text-align:left;"> 2016-07-01 </td>
   <td style="text-align:right;"> 27.1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> A </td>
   <td style="text-align:left;"> 2017-06-14 </td>
   <td style="text-align:right;"> 26.4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> B </td>
   <td style="text-align:left;"> 2017-06-18 </td>
   <td style="text-align:right;"> 15.2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> C </td>
   <td style="text-align:left;"> 2017-06-29 </td>
   <td style="text-align:right;"> 31.3 </td>
  </tr>
</tbody>
</table>

IV. Rules of the road for tidy data 
========================================================
<br style="clear:both" />

**Dirty:**

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> subject </th>
   <th style="text-align:right;"> value </th>
   <th style="text-align:left;"> sexYear </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 13.2 </td>
   <td style="text-align:left;"> m2016 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 14.6 </td>
   <td style="text-align:left;"> f2016 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> C </td>
   <td style="text-align:right;"> 27.1 </td>
   <td style="text-align:left;"> f2016 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 26.4 </td>
   <td style="text-align:left;"> m2017 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 15.2 </td>
   <td style="text-align:left;"> f2017 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> C </td>
   <td style="text-align:right;"> 31.3 </td>
   <td style="text-align:left;"> f2017 </td>
  </tr>
</tbody>
</table>

IV. Rules of the road for tidy data 
========================================================
<br style="clear:both" />
5) One data value per field

**Tidy:**

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> subject </th>
   <th style="text-align:left;"> year </th>
   <th style="text-align:left;"> sex </th>
   <th style="text-align:right;"> value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> A </td>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> m </td>
   <td style="text-align:right;"> 13.2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> B </td>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> f </td>
   <td style="text-align:right;"> 14.6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> C </td>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> f </td>
   <td style="text-align:right;"> 27.1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> A </td>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> m </td>
   <td style="text-align:right;"> 26.4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> B </td>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> f </td>
   <td style="text-align:right;"> 15.2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> C </td>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> f </td>
   <td style="text-align:right;"> 31.3 </td>
  </tr>
</tbody>
</table>

IV. Rules of the road for tidy data 
========================================================
<img style="float: right; width:330px; height:330px; margin: 0px 0px 0px 0px;" src="https://pbs.twimg.com/profile_images/677589103710306304/m56O6Wgf.jpg">

1. Store all data in long format    
2. One level of observation per table  
3. One table per level of observation  
4. No derived variables!  
5. One data value per field


V. Data wrangling in the tidyverse: Rules of wrangling
========================================================
<img style="float: center; width:900px; height:700px; margin: 0px 0px 0px 0px;" src="http://www.phdcomics.com/comics/archive/phd052810s.gif">

V. Data wrangling in the tidyverse: Rules of wrangling
========================================================
<br style="clear:both" />
1) Start with raw data and DO NOT store intermediate files*  
<br style="clear:both" />
**Certainly do not do this:**

```r
dfLong2016 <- filter(dfLong, year == 2016)

write_csv(dfLong2016, 'dfLong2016.csv')

dfLong2016A <- filter(read_csv('dfLong2016.csv'), subject == 'A')

write_csv(dfLong2016A, 'dfLong2016A.csv')
```

V. Data wrangling in the tidyverse: Rules of wrangling
========================================================
<br style="clear:both" />
2) DO NOT assign names to intermediate files in a script unless absolutely necessary    
<br style="clear:both" />
**Do not do this either:**


```r
dfLong2016 <- filter(dfLong, year == 2016)

dfLong2016A <- filter(dfLong2016, subject == 'A')

dfLong2016A
```

V. Data wrangling in the tidyverse: Rules of wrangling
========================================================
<br style="clear:both" />
1) Start with raw data and DO NOT store intermediate files*  
2) DO NOT assign names to intermediate files in a script unless absolutely necessary    
<br style="clear:both" />

**Do this:**


```r
dfLong %>%
  filter(
    year == 2016,
    subject == 'A'
    )
```

V. Data wrangling in the tidyverse: Rules of wrangling
========================================================
<br style="clear:both" />
3) Provide a new line of script for each operation, connected by pipes   
<br style="clear:both" />

**Do not do this:**

```r
dfLong %>% filter(year == 2016) %>% mutate(state = 'ridiculous')
```

**Do this:**

```r
dfLong %>%
  filter(year == 2016) %>%
  mutate(state = 'ridiculous')
```

V. Data wrangling in the tidyverse: Rules of wrangling
========================================================
<br style="clear:both" />
4) Provide adequate commenting **above** operations
<br style="clear:both" />


```r
# Filter by year and subject:

dfLong %>%
  filter(
    year == 2016,
    subject == 'A'
    )
```

V. Data wrangling in the tidyverse: Rules of wrangling
========================================================
<br style="clear:both" />
5) Begin scripts with any necessary set-up and arrange scripts in ordered sections  
(e.g., set-up, wrangling, analysis, figures)

<br style="clear:both" />


```r
# Load libraries:

library(tidyverse)
library(stringr)
library(lubridate)

# Get data:

dfLong <- read_csv('dfLong.csv')
```

V. Data wrangling in the tidyverse: Rules of wrangling
========================================================
<br style="clear:both" />
6) Do not use _setwd_ in your script, but do remind yourself of your working directory!
<br style="clear:both" />

**Do not do this this:**

```r
setwd('C:/Users/Brian/Desktop/gits/rWorkshop')
```

**Do this:**

```r
# my working directory: C:/Users/Brian/Desktop/gits/rWorkshop
```

V. Data wrangling in the tidyverse: Rules of wrangling
========================================================
<br style="clear:both" />
7) If an R package is only used once or twice in a script, directly reference the package rather than loading the whole library
<br style="clear:both" />


```r
dplyr::filter(dfLong, year == 2016)
```


V. Data wrangling in the tidyverse: Rules of wrangling
========================================================
<br style="clear:both" />
8) Delineate sections of script
<br style="clear:both" />


```r
#---------------------------------------------------------*
# ---- SET-UP ----
#---------------------------------------------------------*

# Load libraries:

library(tidyverse)
library(stringr)
library(lubridate)
```

V. Data wrangling in the tidyverse: Rules of wrangling
========================================================

1) Start with raw data and DO NOT store intermediate files*  
2) DO NOT assign names to intermediate files in a script unless absolutely necessary    
3) Provide a new line of script for each operation, connected by pipes  
4) Provide adequate commenting **above** operations  
5) Begin scripts with any necessary set-up  
6) Do not use _setwd_ in your script, but do remind yourself of your working directory!  
7) If an R package is only used once or twice in a script, directly reference the package  
8) Delineate sections of script  

VI. String manipulation in stringr
========================================================
<img style="float: left; margin: 0px 15px 15px 0px;" src="http://www.catster.com/wp-content/uploads/2015/06/cat_with_string.jpg">

Manipulating strings is a common data task that **stringr** has greatly simplified.  

Here we'll look at the functions:

- *str_to_upper*: Make strings all upper case
- *str_detect*: Detect a string within a value
- *str_trim*: Remove white space from a string
- *str_replace_all*: Replace characters in a string
- *str_sub*: Extract part of a string by position

VI. String manipulation in stringr
========================================================

*str_to_upper*: Make strings all upper case





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

VI. String manipulation in stringr
========================================================

*str_detect*: Detect a string within a value


```r
str_detect('hello world','hello')
```

```
[1] TRUE
```

```r
str_detect('hello world', 'foo')
```

```
[1] FALSE
```

VI. String manipulation in stringr
========================================================

*str_detect*: Detect a string within a value

Using in conjunction with a filter:

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> country </th>
   <th style="text-align:right;"> population </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:right;"> 30551674 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Albania </td>
   <td style="text-align:right;"> 3173271 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Algeria </td>
   <td style="text-align:right;"> 39208194 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> American Samoa </td>
   <td style="text-align:right;"> 55165 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Andorra </td>
   <td style="text-align:right;"> 79218 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Angola </td>
   <td style="text-align:right;"> 21471618 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Anguilla </td>
   <td style="text-align:right;"> 14300 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Antigua and Barbuda </td>
   <td style="text-align:right;"> 89985 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Argentina </td>
   <td style="text-align:right;"> 41446246 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Armenia </td>
   <td style="text-align:right;"> 2976566 </td>
  </tr>
</tbody>
</table>

VI. String manipulation in stringr
========================================================

*str_detect*: Detect a string within a value

Using in conjunction with a filter:


```r
population %>%
  filter(str_detect(country, 'United'))
```

```
# A tibble: 4 × 2
                                               country population
                                                 <chr>      <int>
1                                 United Arab Emirates    9346129
2 United Kingdom of Great Britain and Northern Ireland   63136265
3                          United Republic of Tanzania   49253126
4                             United States of America  320050716
```

VI. String manipulation in stringr
========================================================

*str_detect*: Detect a string within a value

Using in conjunction with an ifelse statement:


```r
population %>%
  mutate(
    country = ifelse(str_detect(country, 'Al'),
    'Shazam!', country)
    )
```


```
# A tibble: 5 × 2
         country population
           <chr>      <int>
1    Afghanistan   30551674
2        Shazam!    3173271
3        Shazam!   39208194
4 American Samoa      55165
5        Andorra      79218
```

VI. String manipulation in stringr
========================================================

VII. Working with dates
========================================================

VIII. Subsetting with %in%
========================================================

IX. Joining data
========================================================

