#!/bin/tcsh

#SBATCH --job-name=run   # Specify job name
#SBATCH --partition=compute  # Specify partition name for job execution
#SBATCH --nodes=18
#SBATCH --ntasks-per-node=92
#SBATCH --time=08:00:00      # Set a limit on the total run time
#SBATCH --mail-type=FAIL       # Notify user by email in case of job failure
#SBATCH --account=uo0122     # Charge resources on this project account
#SBATCH --output=test.o%j    # Fitie name for standard output
#SBATCH --error=test.e%j     # File name for standard error output
#SBATCH --hint=nomultithread

module load intel-oneapi-compilers/2022.0.1-gcc-11.2.0
module load openmpi/4.1.2-intel-2021.5.0
module load netcdf-fortran/4.5.3-intel-oneapi-mpi-2021.5.0-intel-2021.5.0 


limit stacksize unlimit
setenv OMPI_MCA_pml_ucx_opal_mem_hooks 1

set rundir=../ADJ_OUTPUT3
set source=../ADJ_build
set ctrl=../ADJ_input


mkdir -p $rundir
rm -rf $rundir
mkdir -p $rundir
#mkdir -p $uo_rs
chmod -R 777 $rundir
cd $rundir
#ln -s $input/* .
cp $source/mitgcmuv_ad .
cp $ctrl/data* .
cp $ctrl/eedata .
cp $ctrl/my* .
#
############forward######
srun -n 1656 --hint=nomultithread ./mitgcmuv_ad
echo "fwd"
mv -f STDOUT.0000 STDOUT.0000.fwd
############diva adjoint####
srun -n 1656 --hint=nomultithread ./mitgcmuv_ad
echo " additional DIVA run # 1 : done"
echo "done1"
mv -f STDOUT.0000 STDOUT.0000.diva_1

srun -n 1656 --hint=nomultithread ./mitgcmuv_ad
echo " additional DIVA run # 2 : done"
echo "done2"
mv -f STDOUT.0000 STDOUT.0000.diva_2

srun -n 1656 --hint=nomultithread ./mitgcmuv_ad
echo " additional DIVA run # 3 : done"
echo "done3"
mv -f STDOUT.0000 STDOUT.0000.diva_3




