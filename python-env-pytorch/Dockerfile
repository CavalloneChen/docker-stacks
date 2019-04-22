# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

# Ubuntu 18.04 (bionic) from 2018-05-26
# https://github.com/docker-library/official-images/commit/aac6a45b9eb2bffb8102353c350d341a410fb169
#ARG BASE_CONTAINER=ubuntu:bionic-20180526@sha256:c8c275751219dadad8fa56b3ac41ca6cb22219ff117ca98fe82b42f24e1ba64e
ARG BASE_CONTAINER=nvidia/cuda:9.0-cudnn7-runtime-ubuntu16.04
FROM $BASE_CONTAINER

LABEL maintainer="Cavallone"
ARG NB_USER="cavallone"
ARG NB_UID="1012"
ARG NB_GID="100"

USER root

# Install all OS dependencies for notebook server that starts but lacks all
# features (e.g., download as all possible file formats)
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get clean && apt-get update && apt-get -yq dist-upgrade \
 && apt-get install -yq --no-install-recommends \
    libxkbfile-dev \
    libsecret-1-dev \
    openssl \
    net-tools \
    git \
    software-properties-common \
    wget \
    curl \
    ca-certificates \
    sudo \
    locales \
    build-essential \
    libsm6 \
    libxext-dev \
    libxrender1 \
 && rm -rf /var/lib/apt/lists/*

RUN apt-add-repository ppa:fish-shell/release-3 &&\
    apt-get update && apt-get -yq dist-upgrade \
 && apt-get install -yq --no-install-recommends \
    fish \
    && rm -rf /var/lib/apt/lists/*
    
RUN curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash - \
    && apt-get update \
 	&& apt-get install -yq --no-install-recommends \
	nodejs\
	&& rm -rf /var/lib/apt/lists/*

RUN npm install -g yarn &&\
    npm cache clean --force

# RUN add-apt-repository ppa:fish-shell/release-3 && apt-get update && \
#     apt-get install -yq --no-install-recommends\
#     fish \
# && rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

# Configure environment
ENV CONDA_DIR=/opt/conda \
    SHELL=/bin/bash \
    NB_USER=$NB_USER \
    NB_UID=$NB_UID \
    NB_GID=$NB_GID \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8
ENV PATH=$CONDA_DIR/bin:$PATH \
    HOME=/home/$NB_USER

ADD fix-permissions /usr/local/bin/fix-permissions
# Create cavallone user with UID=1000 and in the 'users' group
# and make sure these dirs are writable by the `users` group.
RUN groupadd wheel -g 11 && \
    echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su && \
    useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
    echo "cavallone:h6626068" | chpasswd &&\
    mkdir -p $CONDA_DIR && \
    chown $NB_USER:$NB_GID $CONDA_DIR && \
    chmod g+w /etc/passwd && \
    adduser $NB_USER sudo && \
    fix-permissions $HOME && \
    fix-permissions "$(dirname $CONDA_DIR)"

USER $NB_UID
# Install conda as cavallone and check the md5 sum provided on the download site
ENV MINICONDA_VERSION latest
RUN cd /tmp && \
    wget "https://repo.continuum.io/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh" && \
    /bin/bash Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -f -b -p $CONDA_DIR && \
    rm Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh && \
    $CONDA_DIR/bin/conda config --system --prepend channels conda-forge && \
    $CONDA_DIR/bin/conda config --system --set auto_update_conda false && \
    $CONDA_DIR/bin/conda config --system --set show_channel_urls true && \
    $CONDA_DIR/bin/conda install --quiet --yes conda && \
    $CONDA_DIR/bin/conda update --all --quiet --yes && \
    conda clean --all && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Install Tini
RUN conda install --yes 'tini=0.18.0' && \
    conda list tini | grep tini | tr -s ' ' | cut -d ' ' -f 1,2 >> $CONDA_DIR/conda-meta/pinned && \
    conda clean --all && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Install Jupyter Notebook, Lab, and Hub
# Generate a notebook server config
# Cleanup temporary files
# Correct permissions
# Do all this in a single RUN command to avoid duplicating all of the
# files across image layers when the permissions change
RUN conda install --yes\
    'pandas' \
    'tqdm' \
    'matplotlib'\
    'visdom'&& \
    conda install --yes -c pytorch \
    'pytorch' \ 
    'torchvision' \
    'cudatoolkit=9.0' &&\
    conda install --yes -c conda-forge \
    'jupyterlab' \
    'ipywidgets' && \
    conda clean --all && \
    pip install -i https://pypi.tuna.tsinghua.edu.cn/simple --no-cache-dir \
    'visdom' \
    'jupyterlab_code_formatter' \
    'black' \
    'ipykernel' && \
    jupyter labextension install @oriolmirosa/jupyterlab_materialdarker && \
    jupyter labextension install @ryantam626/jupyterlab_code_formatter && \
    jupyter labextension install @jupyter-widgets/jupyterlab-manager && \
    jupyter serverextension enable --py jupyterlab_code_formatter &&\
    npm cache clean --force && \
    jupyter notebook --generate-config && \
    rm -rf $CONDA_DIR/share/jupyter/lab/staging && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

USER root

ENV CODE_SERVER_VER 1.903-vsc1.33.1
RUN wget https://github.com/codercom/code-server/releases/download/${CODE_SERVER_VER}/code-server${CODE_SERVER_VER}-linux-x64.tar.gz &&\
	tar -xvzf code-server${CODE_SERVER_VER}-linux-x64.tar.gz &&\
	cd code-server${CODE_SERVER_VER}-linux-x64 &&\
	mv ./code-server /usr/local/bin/code-server &&\
	cd .. && rm -rf code-server${CODE_SERVER_VER}-linux-x64 &&\
	rm code-server${CODE_SERVER_VER}-linux-x64.tar.gz

EXPOSE 8888 8443 8097
WORKDIR $HOME

# Configure container startup
ENTRYPOINT ["tini", "-g", "--"]
CMD ["start-notebook.sh"]

# Add local files as late as possible to avoid cache busting
COPY start.sh /usr/local/bin/
COPY start-notebook.sh /usr/local/bin/
COPY start-singleuser.sh /usr/local/bin/
COPY jupyter_notebook_config.py /etc/jupyter/
RUN fix-permissions /etc/jupyter/
RUN fix-permissions /home

# Switch back to cavallone to avoid accidental container runs as root
USER $NB_UID
