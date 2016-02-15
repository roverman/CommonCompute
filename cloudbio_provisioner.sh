wget https://raw.github.com/chapmanb/bcbio-nextgen/master/scripts/bcbio_nextgen_install.py
python bcbio_nextgen_install.py /opt/bcbio --tooldir=/opt/bcbio --isolate --nodata --aligners bwa --aligners bowtie2 --aligners bowtie --distribution centos --aligners star --aligners novoalign
