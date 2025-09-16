docker build . -t myfinalproject611
docker run -e USERID=$(id -u) -e GROUPID=$(id -g)\
  -v $(pwd):/home/rstudio/work\
  -v $HOME/.ssh:/home/rstudio/.ssh\
  -v $HOME/.gitconfig:/home/rstudio/.gitconfig\
  -p 8797:8787 rocker/verse
