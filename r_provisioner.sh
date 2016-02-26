#!/bin/bash -x

mkdir /home/centos/src/
cd /home/centos/src/

## Install R from source
yum -y install libpng-devel libjpeg-devel libtiff-devel ghostscript-devel curl libcurl libcurl-devel
#yum install --enablerepo=epel -y R-core R-core-devel R-devel
wget https://cran.r-project.org/src/base/R-3/R-3.2.3.tar.gz
tar xzf R-3.2.3.tar.gz
cd R-3.2.3
./configure --with-x=yes --enable-R-shlib --enable-BLAS-shlib --enable-R-profiling --enable-memory-profiling JAVA_HOME=/usr/lib/jvm/java-openjdk --with-cairo=yes
make && make install && make clean

# Link openblas library
mv /usr/local/lib64/R/lib/libRblas.so /usr/local/lib64/R/lib/libRblas.so.keep
ln -s /opt/OpenBLAS/lib/libopenblas.so /usr/local/lib64/R/lib/libRblas.so

## Install littler
cd /home/centos/src
wget http://dirk.eddelbuettel.com/code/littler/littler-0.2.3.tar.gz
tar xzf littler-0.2.3.tar.gz
cd littler-0.2.3
./bootstrap && ./configure && make && make install && make clean

mkdir -p /opt/littler-0.2.3/bin/
cp /home/centos/src/littler-0.2.3/examples/*.r /opt/littler-0.2.3/bin/

ln -s /opt/littler-0.2.3/bin/install.r /usr/local/bin/install.r
ln -s /opt/littler-0.2.3/bin/install2.r /usr/local/bin/install2.r
ln -s /opt/littler-0.2.3/bin/installGithub.r /usr/local/bin/installGithub.r
ln -s /opt/littler-0.2.3/bin/testInstalled.r /usr/local/bin/testInstalled.r

## Use RStudio CDN as mirror
## Set a default CRAN repo
echo 'options(repos = list(CRAN="http://cran.rstudio.com/"))' >> /usr/lib64/R/etc/Rprofile.site

## Use the default CRAN repo with littler
echo 'source("/usr/lib64/R/etc/Rprofile.site")' >> /etc/littler.r

## Install R packages
Rscript -e 'install.packages(c("docopt", "devtools", "dplyr", "tidyr", "ggplot2", "reshape2", "knitr", "stringr", "readr", "plyr", "data.table", "rJava", "doParallel", "snow", "igraph", "Rcpp", "RcppEigen", "Rclusterpp", "RColorBrewer"))'

## Install synapse R client
# For R client
Rscript -e 'install.packages(c("RJSONIO", "RCurl", "digest"))'

Rscript -e 'source("http://depot.sagebase.org/CRAN.R") ; pkgInstall(c("synapseClient"))'

## Install bioconductor packages
Rscript -e 'source("http://www.bioconductor.org/biocLite.R") ; biocLite(c("limma", "biovizBase", "e1071", "org.Hs.eg.db", "edgeR", "AnnotationDbi", "biomaRt", "ComplexHeatmap", "FDb.InfiniumMethylation.hg19"))'

## Install rGithub client
Rscript -e 'library(devtools); install_github("brian-bot/githubr")'

## Install Rmpi
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib64/openmpi/lib
Rscript -e 'install.packages("Rmpi", configure.args = c("--with-Rmpi-include=/usr/include/openmpi-x86_64","--with-Rmpi-libpath=/usr/lib64/openmpi/lib","--with-Rmpi-type=OPENMPI"))'
