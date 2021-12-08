library(tidyverse)
library(vroom)


census <- vroom::vroom("https://www2.census.gov/programs-surveys/popproj/datasets/2017/2017-popproj/np2017_d1_mid.csv")


census  %>%
  janitor::clean_names() %>%
  filter(sex == 0, origin==0, race==0) -> census


census_calc <- function(yearz = lubridate::year(Sys.Date()), agez=seq(0,100, by=1)){
  ### single year only for now
  if(length(yearz)>1) warning("You selected more than one year, estimates will be an average across years.")
  
  ### add prefix to age to match data
  agez <- paste0("pop_", agez)
  
  ### filter year
  census %>%
    filter(year %in% yearz) -> census
  
  ### compute if single year use value, otherwise average
  
  ### compute total pop for pct.
    census %>%
      select(pop_0:pop_100) %>%
      summarise_all(
        mean
      ) -> total.pop
   total.pop <- sum(total.pop)
        
  
    out <- data.frame(sum(sapply(agez, function(x) mean(pull(census[,x]), na.rm=T))))
    names(out) <- "pop"
    out$pop <- round(out$pop, 0)
    out$pct <- round(out$pop/total.pop*100,2)
    
    out$pop <- format(out$pop, big.mark=",")
    
    
    out2 <- data.frame(paste0(out$pop, " (", out$pct, ")"))
    
    out2 %>%
      DT::datatable(., rownames=F,
                    options = list(dom = 't',
                                   columnDefs = list(list(className = 'dt-center', targets = "_all"))
                    ),
                    colnames = c("Total Population")
      ) -> out2
    
    
  
 return(out2) 
}


