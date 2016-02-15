#!/bin/bash -x

mkdir /root/src/
cd /root/src/

## Install R from epel repo
#yum install --enablerepo=epel -y R-core R-core-devel R-devel

# Install X11 headers for R
yum install libXt-devel libX11-devel 

## Install R from source code
wget https://cran.r-project.org/src/base/R-3/R-3.2.3.tar.gz
tar xzf R-3.2.3.tar.gz
cd R-3.2.3
./configure && make && make install
make clean

## Install littler
cd ..
wget http://dirk.eddelbuettel.com/code/littler/littler-0.2.3.tar.gz
tar xzf littler-0.2.3.tar.gz
cd littler-0.2.3
./bootstrap && ./configure && make && make install
make clean

mkdir -p /opt/littler-0.2.3/bin/
cp /root/src/littler-0.2.3/examples/*.r /opt/littler-0.2.3/bin/

ln -s /opt/littler-0.2.3/bin/install.r /usr/local/bin/install.r
ln -s /opt/littler-0.2.3/bin/install2.r /usr/local/bin/install2.r
ln -s /opt/littler-0.2.3/bin/installGithub.r /usr/local/bin/installGithub.r
ln -s /opt/littler-0.2.3/bin/testInstalled.r /usr/local/bin/testInstalled.r

## Use RStudio CDN as mirror
## Set a default CRAN repo
echo 'options(repos = list(CRAN="http://cran.rstudio.com/"))' >> /usr/local/lib64/R/etc/Rprofile.site

## Use the default CRAN repo with littler
echo 'source("/usr/loacal/lib64/R/etc/Rprofile.site")' >> /etc/littler.r

## Install additional packages for R
yum install -y curl libcurl libcurl-devel
Rscript -e 'install.packages(c("docopt","devtools", "dplyr", "tidyr", "ggplot2", "reshape2", "knitr", "stringr", "readr", "plyr", "data.table", "RJSONIO", "rJava", "RCurl", "digest", "parallel", "snow", "MRCE", "vbsr", "Rcpp", "RcppEigen", "Rclusterpp", "dplyr", "plyr", "data.table", "tools", "RColorBrewer", "ggplot2", "gplots", "ctv", "psych", "reshape2", "vcd", "erer", "fpc", "knitr", "stringr", "igraph", "tidyr"))'
 
## Install synapse R client
Rscript -e 'source("http://depot.sagebase.org/CRAN.R") ; pkgInstall(c("synapseClient"))'

## Install additional packages from Bioconductor
Rscript -e 'source("http://bioconductor.org/biocLite.R"); biocLite(pkgs=c("RDAVIDWebService", "topGO", "goseq", "GO.db", "GSVA", "org.Hs.eg.db", "edgeR", "limma", "CePa", "Biobase", "pracma", "annotate", "AnnotationDbi", "BiocInstaller", "biomaRt", "Biostrings", "edgeR", "GEOquery", "GOstats", "graph", "GSEABase", "impute", "preprocessCore", "GO.db", "ComplexHeatmap", "FDb.InfiniumMethylation.hg19"))'

## Dependent R packages (install after installing bioc packages)
Rscript -e 'install.packages(c("WGCNA", "idr"))'

## rGithub client
Rscript -e 'install.packages("devtools"); require(devtools); install_github("brian-bot/rGithubClient@dev")'

## Install Rmpi
Rscript -e 'install.packages("Rmpi", configure.args = c("--with-Rmpi-include=/usr/include/openmpi-x86_64","--with-Rmpi-libpath=/usr/lib64/openmpi/lib","--with-Rmpi-type=OPENMPI"))'
