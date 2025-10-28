.PHONY: clean all

all: derived_data/user_cleaned.csv

clean:
	rm -rf derived_data

derived_data:
	mkdir -p derived_data

derived_data/user_cleaned.csv: derived_data source_data/users.csv DataClean1.R
	Rscript DataClean1.R