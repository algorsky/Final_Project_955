library(tidyverse)

# Read in data 
data = read_csv('data/data.csv')
extra = read_csv('data/extra.csv')
gas = read_csv('data/gas_stats.csv')

#Data clean and organize
depth<- extra%>%
  group_by(pond)%>%
  summarize(max_depth = mean(Zmax))

#Combine
gas_all<-gas%>%
  left_join(depth, by = "pond")%>%
  mutate(pond = fct_reorder(pond, max_depth))%>%
  mutate(Depth = 0)

all_data<- data%>%
  left_join(gas_all, by = c('date','pond','Depth'))


surface<- all_data%>%
  filter(Depth == 0)

max<- all_data%>%
  group_by(pond, date)%>%
  summarize(Depth = max(Depth))
min<- all_data%>%
  group_by(pond, date)%>%
  summarize(Depth = min(Depth))
max_profile<- max%>%
  left_join(all_data, by = c("pond", "date", "Depth"))%>%
  select(pond, date, Temp_C, Conductivity, Depth, DO_Percent, DO_mgL)%>%
  rename(Bottom_Temp = Temp_C)%>%
  rename(Bottom_Cond = Conductivity)%>%
  rename(Bottom_DO_perc = DO_Percent)

Bottom_DO_perc<- max_profile%>%
  select("pond", "date", "Bottom_DO_perc")

surface<- surface%>%
  left_join(Bottom_DO_perc, by = c("pond", "date"))

write_csv(surface, "data/data_surface.csv")  
