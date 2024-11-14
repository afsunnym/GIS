library(here)
library(readr)
library(sf)
library(dplyr)
library(countrycode)

#step 1.1: loading the inqeuality data

global_gender_inequality <- read.csv(here("HDR23-24_Composite_indices_complete_time_series.csv"),
                                       fileEncoding = "UTF-8") %>%
  select(iso3, gii_2010, gii_2019)


#step 1.2: calculationg the difference between 2010 and 2019                                   

gii20102019 <- global_gender_inequality %>%
  mutate(diff_gii = gii_2019 - gii_2010) %>%
  filter(!is.na(diff_gii))

#step 1.3: checking the data 

head(gii20102019,10)




#step 2.1: loading the spatial data (GeoJSON)

countries_GeoJSON <- st_read(here("World_Countries_(Generalized)_9029012925078512962.geojson"))

#step 2.2: adding iso3 column using the "countrycode" package

countries_data <- countries_GeoJSON %>%
  mutate(iso3 = countrycode(ISO, origin = "iso2c", destination = "iso3c"))

  
#step 2.3: checking the data

head(countries_data,10)

#step 2.4: too messy! let's clean up a bit

countries_clean <- countries_data %>%
  select(COUNTRY, geometry, iso3)

#step 2.5: let's check the data again

head(countries_clean, 10)
  #much better, nice and clean


#step 3.1: combining the inequality data to the spatial data using (left_join)

merged <- countries_clean %>%
  left_join(gii20102019, by = "iso3")

#step 3.2: checking the combined data

head(merged,10)

###*DONE*
