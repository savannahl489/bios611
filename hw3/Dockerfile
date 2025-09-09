# Loading docker image
FROM rocker/verse:latest

# pipe yes into unminimize
RUN apt update && \
    apt install -y unminimize man-db && \
    yes | unminimize && \
    rm -rf /var/lib/apt/lists/*


# Set a working directory
WORKDIR /home/rstudio/project

# Expose RStudio Server port
EXPOSE 8787
