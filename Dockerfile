# Version 1

# Pull from CentOS RPM Build Image
FROM centos:7

MAINTAINER ron

ENV CONDA_DIR /opt/conda
ENV PATH $CONDA_DIR/bin:$PATH

RUN yum install -y wget \
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
RUN conda install -c conda-forge gdal

RUN pip install \
 https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.4.0rc1-cp35-cp35m-linux_x86_64.whl

RUN pip --no-cache-dir install earthengine-api

COPY jupyter_notebook_config.py /root/.jupyter/

# TensorBoard
# EXPOSE 6006
# IPython
EXPOSE 8888

#CMD /bin/bash
#CMD python
#CMD ["/bin/bash"]
#RUN nohup tensorboard --logdir /root/logs &
CMD jupyter notebook --allow-root --port=8888
