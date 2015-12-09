# Required for rgl/BubbleTree
yum install -y mesa-libGL-devel mesa-libGLU-devel

git clone git://github.com/chapmanb/cloudbiolinux.git
cd cloudbiolinux

module load python/2.7.10
fab -f fabfile.py -H localhost install_biolinux:flavor=ngs_pipeline_minimal
cd -
