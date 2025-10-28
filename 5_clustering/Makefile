.PHONY: clean all

all: derived_data_1/.done derived_data_2/.done \
     figures_2/shell_clusters.html \
     figures_1/cluster_gap_grid.png \
     figures_2/Spectral_Cluster_Max_Radius.png \
     Clustering_Analysis.pdf


clean:
	rm -rf derived_data_1 
	rm -rf derived_data_2 
	rm -rf figures_1
	rm -rf figures_2
	rm -rf Clustering_Analysis.pdf

derived_data_1:
	mkdir -p derived_data_1
	
derived_data_2:
	mkdir -p derived_data_2

figures_1:
	mkdir -p figures_1
	
figures_2:
	mkdir -p figures_2


derived_data_1/.done: derived_data_1 data_generation.py
	python3 data_generation.py
	touch derived_data_1/.done

derived_data_2/.done: derived_data_2 data_generation_2.py
	python3 data_generation_2.py
	touch derived_data_2/.done


figures_2/shell_clusters.html: figures_2 data_generation_2.py
	python3 data_generation_2.py
	
figures_1/cluster_gap_grid.png: figures_1 Clustering_Analysis.Rmd
	Rscript -e "rmarkdown::render('Clustering_Analysis.Rmd')"
	
figures_2/Spectral_Cluster_Max_Radius.png : figures_2 Clustering_Analysis.Rmd 
	Rscript -e "rmarkdown::render('Clustering_Analysis.Rmd')"

Clustering_Analysis.pdf: derived_data_2 derived_data_1 Clustering_Analysis.Rmd 
	Rscript -e "rmarkdown::render('Clustering_Analysis.Rmd')"

	

