# Onetonline Data Scraping

This project involves scraping data from the [Onetonline](https://www.onetonline.org) website to collect information about various job-related skills, interests, knowledge, basic skills, cross-functional skills, work activities, work context, work styles, and work values. The scraped data is organized into separate CSV files for each category.

## Required Libraries

Before running the code, make sure you have the following R libraries installed:

- httr
- rvest
- purrr
- stringr
- tidyverse
- zoo

You can install these libraries using the `install.packages` function in R.

## Scraping Abilities Data

The code starts by scraping data related to abilities. It extracts data from the [Abilities section](https://www.onetonline.org/find/descriptor/browse/1.A/1.A.1/1.A.1.g/1.A.1.b/1.A.1.d/1.A.1.e/1.A.1.c/1.A.1.f/1.A.1.a/1.A.3/1.A.3.b/1.A.3.c/1.A.3.a/1.A.2/1.A.2.b/1.A.2.a/1.A.2.c/1.A.4/1.A.4.b/1.A.4.a) of the website, extracts CSV links, and stores the data in a CSV file named "abilities.csv."

## Scraping Interests Data

Next, the code scrapes data related to interests. It extracts data from the [Interests section](https://www.onetonline.org/find/descriptor/browse/1.B.1) and stores the data in a CSV file named "interests.csv."

## Scraping Knowledge Data

The code then scrapes data related to knowledge. It extracts data from the [Knowledge section](https://www.onetonline.org/find/descriptor/browse/2.C/2.C.7/2.C.1/2.C.9/2.C.3/2.C.5/2.C.8/2.C.2/2.C.4) and stores the data in a CSV file named "knowledge.csv."

## Scraping Basic Skills Data

Data related to basic skills is scraped next. The code extracts data from the [Basic Skills section](https://www.onetonline.org/find/descriptor/browse/2.A/2.A.1/2.A.2) and stores the data in a CSV file named "basic_skills.csv."

## Scraping Cross-Functional Skills Data

The code proceeds to scrape data related to cross-functional skills. It extracts data from the [Cross Functional Skills section](https://www.onetonline.org/find/descriptor/browse/2.B/2.B.2/2.B.5/2.B.1/2.B.4/2.B.3) and stores the data in a CSV file named "cross_functional_skills.csv."

## Scraping Work Activities Data

Data related to work activities is scraped next. The code extracts data from the [Work Activities section](https://www.onetonline.org/find/descriptor/browse/4.A/4.A.1/4.A.1.b/4.A.1.a/4.A.4/4.A.4.c/4.A.4.a/4.A.4.b/4.A.2/4.A.2.a/4.A.2.b/4.A.3/4.A.3.b/4.A.3.a) and stores the data in a CSV file named "work_activities.csv."

## Scraping Work Context Data

The code then scrapes data related to work context. It extracts data from the [Work Context section](https://www.onetonline.org/find/descriptor/browse/4.C/4.C.1/4.C.1.a/4.C.1.a.2/4.C.1.d/4.C.1.c/4.C.1.b/4.C.1.b.1/4.C.2/4.C.2.d/4.C.2.d.1/4.C.2.b/4.C.2.b.1/4.C.2.c/4.C.2.c.1/4.C.2.e/4.C.2.e.1/4.C.2.a/4.C.2.a.1/4.C.3/4.C.3.c/4.C.3.a/4.C.3.a.2/4.C.3.d/4.C.3.b) and stores the data in a CSV file named "work_context.csv."

## Scraping Work Styles Data

Data related to work styles is scraped next. The code extracts data from the [Work Styles section](https://www.onetonline.org/find/descriptor/browse/1.C/1.C.1/1.C.4/1.C.5/1.C.3/1.C.7/1.C.2
