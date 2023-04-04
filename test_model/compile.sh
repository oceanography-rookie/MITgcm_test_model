#!/bin/bash

# select the compiling environment
module load intel-oneapi-compilers/2022.0.1-gcc-11.2.0
module load openmpi/4.1.2-intel-2021.5.0
module load netcdf-fortran/4.5.3-intel-oneapi-mpi-2021.5.0-intel-2021.5.0 

# set the following environment variables

cd ADJ_build
make CLEAN
cp ../staf .
cp ../genmake_* .
../../../tools/genmake2 -mods ../ADJ_code -mpi -optfile ../../../tools/build_options/levante_intel_openmpi  -make=gmake
make depend
make adtaf
make -j 128 adall

echo "compiling done!"

###########run##############

