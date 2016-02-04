#!/bin/bash -x

mkdir /root/src/
cd /root/src/

yum install --enablerepo=epel -y R-core R-core-devel R-devel

wget http://dirk.eddelbuettel.com/code/littler/littler-0.2.3.tar.gz
tar xzf littler-0.2.3.tar.gz
cd littler-0.2.3
./bootstrap && ./configure && make && make install

mkdir -p /opt/littler-0.2.3/bin/
cp /root/src/littler-0.2.3/examples/*.r /opt/littler-0.2.3/bin/

ln -s /opt/littler-0.2.3/bin/install.r /usr/local/bin/install.r
ln -s /opt/littler-0.2.3/bin/install2.r /usr/local/bin/install2.r
ln -s /opt/littler-0.2.3/bin/installGithub.r /usr/local/bin/installGithub.r
ln -s /opt/littler-0.2.3/bin/testInstalled.r /usr/local/bin/testInstalled.r

## Use RStudio CDN as mirror
## Set a default CRAN repo
echo 'options(repos = list(CRAN="http://cran.rstudio.com/"))' >> /usr/lib64/R/etc/Rprofile.site

## Use the default CRAN repo with littler
echo 'source("/usr/lib64/R/etc/Rprofile.site")' >> /etc/littler.r

# Rscript -e 'install.packages("docopt")'

Rscript -e 'install.packages(c("devtools", "dplyr", "tidyr", "ggplot2", "reshape2", "knitr", "stringr", "readr", "plyr", "data.table"))'

## For the R client
yum install -y curl libcurl libcurl-devel
Rscript -e 'install.packages(c("RJSONIO", "Rmpi", "RCurl", "digest", "parallel", "snow", "MRCE", "vbsr", "Rcpp", "RcppEigen", "Rclusterpp", "dplyr", "plyr", "data.table", "tools", "RColorBrewer", "ggplot2", "gplots", "ctv", "psych", "reshape2", "vcd", "erer", "fpc", "knitr", "stringr", "igraph", "tidyr"))'
 
Rscript -e 'source("http://depot.sagebase.org/CRAN.R") ; pkgInstall(c("synapseClient"), stack="staging")'

Rscript -e 'source("http://bioconductor.org/biocLite.R") ; biocLite(pkgs=c("RDAVIDWebService", "topGO", "goseq", "GO.db", "GSVA", "org.Hs.eg.db", "edgeR", "limma", "CePa", "Biobase", "pracma", "annotate", "AnnotationDbi", "BiocInstaller", "biomaRt", "Biostrings", "edgeR", "GEOquery", "GOstats", "graph", 
"GSEABase", "impute", "preprocessCore", "GO.db", "ComplexHeatmap", "FDb.InfiniumMethylation.hg19"))'

Rscript -e 'install.packages(c("WGCNA", "idr"))'

Rscript -e 'install.packages("devtools"); require(devtools); install_github("brian-bot/rGithubClient@dev")'

# Install Rstudio server
wget https://download2.rstudio.org/rstudio-server-rhel-0.99.467-x86_64.rpm
yum install --nogpgcheck rstudio-server-rhel-0.99.467-x86_64.rpm

Rscript -e 'source("http://depot.sagebase.org/CRAN.R") ; pkgInstall(c("synapseClient"))'
Rscript -e 'source("http://www.bioconductor.org/biocLite.R") ; biocLite(c("limma", "biovizBase", "e1071"))'
