#!/bin/bash
CONDA="Anaconda3-4.4.0-Linux-x86_64.sh"
wget -c "https://repo.continuum.io/archive/$CONDA"

sh $CONDA -b
