## Data exlplorer

library(tidyverse)

# Group the data by sector to generate a plot

by_sector <- group_by(SP500, gics_sector)
sum <- summarise(by_sector, count = n())

# Create a column chart that shows count of industries by sector:

ggplot(data = sum, mapping = aes(x = gics_sector, y = count)) + 
        geom_col() +
        theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))


