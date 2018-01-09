FROM centos:7

MAINTAINER ron

ENV CONDA_DIR /opt/conda
ENV PATH $CONDA_DIR/bin:$PATH

RUN yum install -y wget \
        epel-release \
        grive2 \
        gcc gcc-c++ make openssl-devel \
        bzip2 \
        python-devel \
        libczmq1 \
        git \
        bash \
        libjpeg \
        libczmq1-devel

RUN echo 'export PATH=$CONDA_DIR/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-4.0.5-Linux-x86_64.sh && \
    bash Miniconda3-4.0.5-Linux-x86_64.sh -b -p $CONDA_DIR && \
    rm Miniconda3-4.0.5-Linux-x86_64.sh

RUN conda install jupyter
RUN conda install -c conda-forge gdal=2.1 fiona
RUN conda install shapely
RUN conda install jupyterlab
RUN jupyter serverextension enable --py jupyterlab --sys-prefix
#RUN pip install utm

RUN pip install tensorflow
RUN pip --no-cache-dir install earthengine-api

RUN pip install matplotlib
RUN pip install git+https://github.com/wookayin/tensorflow-plot.git@master

COPY jupyter_notebook_config.py /root/.jupyter/

# TensorBoard
EXPOSE 6006
# IPython
EXPOSE 8888

CMD jupyter lab --allow-root --port=8888
