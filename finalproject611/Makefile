.PHONY: clean all

all:\
derived_data/user_cleaned.csv\
derived_data/ads_cleaned.csv\
derived_data/composite_data1.csv\
derived_data/composite_data2.csv\
figures/interaction_count_histogram.png\
figures/interaction_count_boxplot.png\
figures/overinteract_age.png\
figures/underinteract_age.png\
figures/overinteract_country.png\
figures/underinteract_country.png\
figures/underinteract_interests.png\


clean:
	rm -rf derived_data
	rm -rf figures

derived_data:
	mkdir -p derived_data

figures:
	mkdir -p figures

derived_data/user_cleaned.csv: derived_data source_data/users.csv DataClean1.R
	Rscript DataClean1.R

derived_data/ads_cleaned.csv: derived_data source_data/ads.csv DataClean1.R
	Rscript DataClean1.R
	
derived_data/composite_data1.csv: derived_data \
    source_data/ads.csv \
    source_data/campaigns.csv \
    source_data/ad_events.csv \
    DataClean1.R
	Rscript DataClean1.R
	
derived_data/composite_data2.csv: derived_data \
   source_data/ads.csv \
    source_data/campaigns.csv \
    source_data/ad_events.csv \
    DataClean1.R
	Rscript DataClean1.R
	
figures/interaction_count_histogram.png: derived_data/composite_data2.csv figures Report.Rmd
	Rscript -e "rmarkdown::render('Report.Rmd')"
	
figures/interaction_count_boxplot.png: derived_data/composite_data2.csv figures Report.Rmd
	Rscript -e "rmarkdown::render('Report.Rmd')"

figures/overinteract_age.png: derived_data/composite_data2.csv figures Report.Rmd 
	Rscript -e "rmarkdown::render('Report.Rmd')"
	
figures/underinteract_age.png: derived_data/composite_data2.csv figures Report.Rmd 
	Rscript -e "rmarkdown::render('Report.Rmd')"
	
figures/overinteract_country.png: derived_data/composite_data2.csv figures Report.Rmd 
	Rscript -e "rmarkdown::render('Report.Rmd')"
	
figures/underinteract_country.png: derived_data/composite_data2.csv figures Report.Rmd 
	Rscript -e "rmarkdown::render('Report.Rmd')"
	
figures/underinteract_interests.png: derived_data/composite_data2.csv figures Report.Rmd 
	Rscript -e "rmarkdown::render('Report.Rmd')"
	
figures/overinteract_interests.png: derived_data/composite_data2.csv figures Report.Rmd 
	Rscript -e "rmarkdown::render('Report.Rmd')"
	
