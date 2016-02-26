cd /home/centos/src
git clone git://github.com/chapmanb/cloudbiolinux.git

cd cloudbiolinux

# Required for rgl/BubbleTree
yum install -y mesa-libGL-devel mesa-libGLU-devel

module load python/3.5.1
fab -f fabfile.py -H localhost install_biolinux:flavor=ngs_pipeline_minimal
cd -
