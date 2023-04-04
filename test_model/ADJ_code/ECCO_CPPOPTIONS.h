C 
C
#ifndef ECCO_CPPOPTIONS_H
#define ECCO_CPPOPTIONS_H
C
C CPP flags controlling which code is included in the files that
C will be compiled.
C
C ********************************************************************
C ***                         ECCO Package                         ***
C ********************************************************************
C
C o include dump of snap shots for checks
#define ALLOW_ECCO_EVOLUTION

#undef  ALLOW_SNAPSHOTS

#undef  ALLOW_ECCO_FORWARD_RUN
#undef  ALLOW_ECCO_DIAGNOSTICS_RUN
#define  ALLOW_ECCO_OPTIMIZATION

C       >>> Do a long protocol.
#undef ECCO_VERBOSE

C       >>> Just do a "dry" run ( useful for testing ).
#undef  ALLOW_NO_DYNAMICS
C       >>> Use the Yearly-Monthly-Daily-Stepping call tree.
#undef  ALLOW_YMDS_TREE
C       >>> Do not call stepping
#define ALLOW_STEPPING_CALL

#define TARGET_BGL 
#define DISABLE_MPI_READY_TO_RECEIVE

C ********************************************************************
C ***                  Adjoint Support Package                     ***
C ********************************************************************

C o Include/exclude code in order to be able to automatically
C   differentiate the MITgcmUV by using the Tangent Linear and
C   Adjoint Model Compiler (TAMC).
#define INCLUDE_AUTODIFF_PACKAGE
C
#define ALLOW_AUTODIFF_TAMC
C
C       >>> Checkpointing as handled by TAMC
#define ALLOW_TAMC_CHECKPOINTING
C
C       >>> Extract adjoint state
#define ALLOW_AUTODIFF_MONITOR
C
C extend to 4-level checkpointing
#undef AUTODIFF_4_LEVEL_CHECKPOINT
C
C o use divided adjoint to split adjoint computations
#undef ALLOW_DIVIDED_FORWARD

C use divided adjoint
#define ALLOW_DIVIDED_ADJOINT
#define ALLOW_DIVIDED_ADJOINT_MPI
CMM
#undef AUTODIFF_USE_OLDSTORE_3D
CMM 
#define USE_FORTRAN_SCRATCH_FILES
C ********************************************************************
C ***                     Calender Package                         ***
C ********************************************************************
C 
C CPP flags controlling which code is included in the files that
C will be compiled.

CPH >>>>>> THERE ARE NO MORE CAL OPTIONS TO BE SET <<<<<<
C
C ********************************************************************
C ***                Smooth function Package                       ***
c ********************************************************************
C
#undef ALLOW_SMOOTH_CORREL3D
#undef ALLOW_SMOOTH3D
#undef ALLOW_SMOOTH_CORREL2D
#undef ALLOW_SMOOTH2D

C ********************************************************************
C ***                Cost function Package                         ***
c ********************************************************************
C 
#define ALLOW_COST

#ifdef ALLOW_COST

#undef ALLOW_PROFILES_CONTRIBUTION
#undef ALLOW_PROFILES
C       >>> Use the EGM-96 geoid error covariance.
#undef  ALLOW_EGM96_ERROR_DIAG
#undef  ALLOW_EGM96_ERROR_COV
#undef  ALLOW_SPH_PROJECTION

C       >>> Use NSCAT data.
#undef ALLOW_SCAT_COST_CONTRIBUTION

C       >>> Cost function contributions
#undef ALLOW_HFLUX_COST_CONTRIBUTION
#undef ALLOW_SFLUX_COST_CONTRIBUTION
#undef ALLOW_MEAN_HFLUX_COST_CONTRIBUTION
#undef ALLOW_MEAN_SFLUX_COST_CONTRIBUTION
#undef ALLOW_USTRESS_COST_CONTRIBUTION
#undef ALLOW_VSTRESS_COST_CONTRIBUTION
#undef ALLOW_STRESS_MEAN_COST_CONTRIBUTION

#define ALLOW_ATEMP_COST_CONTRIBUTION
#define ALLOW_AQH_COST_CONTRIBUTION
#define ALLOW_PRECIP_COST_CONTRIBUTION
#define ALLOW_SWDOWN_COST_CONTRIBUTION
#define ALLOW_UWIND_COST_CONTRIBUTION 
#define ALLOW_VWIND_COST_CONTRIBUTION

#undef GENERIC_BAR_MONTH
#define ALLOW_THETA_COST_CONTRIBUTION
#define ALLOW_SALT_COST_CONTRIBUTION
#define ALLOW_THETA0_COST_CONTRIBUTION
#define ALLOW_SALT0_COST_CONTRIBUTION

#define ALLOW_SST_COST_CONTRIBUTION
#define ALLOW_SSS_COST_CONTRIBUTION
#define ALLOW_TMI_SST_COST_CONTRIBUTION
#define ALLOW_DAILYSST_COST_CONTRIBUTION

#undef ALLOW_SSH_TOT
#undef ALLOW_SSH_LOCAL_CONTRIBUTION
#undef ALLOW_SSH_MEAN_COST_CONTRIBUTION
#undef ALLOW_SSH_TPANOM_COST_CONTRIBUTION
#undef ALLOW_SSH_ERSANOM_COST_CONTRIBUTION
#undef ALLOW_SSH_GFOANOM_COST_CONTRIBUTION
#if (defined (ALLOW_SSH_MEAN_COST_CONTRIBUTION) || \
      defined (ALLOW_SSH_TPANOM_COST_CONTRIBUTION) || \
      defined (ALLOW_SSH_LOCAL_CONTRIBUTION) || \
      defined (ALLOW_SSH_ERSANOM_COST_CONTRIBUTION))
#undef ALLOW_SSH_COST_CONTRIBUTION
#endif
#undef ALLOW_NEW_SSH_COST

#undef ALLOW_XBT_COST_CONTRIBUTION
#undef ALLOW_CTDT_COST_CONTRIBUTION
#undef ALLOW_CTDS_COST_CONTRIBUTION
#undef ALLOW_DRIFTER_COST_CONTRIBUTION
#undef ALLOW_DRIFT_COST_CONTRIBUTION
#undef ALLOW_DRIFTW_COST_CONTRIBUTION
C
#undef ALLOW_ARGO_THETA_COST_CONTRIBUTION
#undef ALLOW_ARGO_SALT_COST_CONTRIBUTION
C
c       >>> Open boundaries
c       >>> Make sure that ALLOW_OBCS is defined!
#undef ALLOW_OBCSN_COST_CONTRIBUTION
#undef ALLOW_OBCSS_COST_CONTRIBUTION
#undef ALLOW_OBCSW_COST_CONTRIBUTION
#undef ALLOW_OBCSE_COST_CONTRIBUTION
#if (defined (ALLOW_OBCSN_COST_CONTRIBUTION) || \
      defined (ALLOW_OBCSS_COST_CONTRIBUTION) || \
      defined (ALLOW_OBCSW_COST_CONTRIBUTION) || \
      defined (ALLOW_OBCSE_COST_CONTRIBUTION))
#define ALLOW_OBCS_COST_CONTRIBUTION
#endif
#undef OBCS_VOLFLUX_COST_CONTRIBUTION 
#undef OBCS_AGEOS_COST_CONTRIBUTION
#undef BALANCE_CONTROL_VOLFLUX_GLOBAL


#undef ALLOW_SEAICE_COST_SMR_AREA
#undef ALLOW_SEAICE_COST_AREASST

#undef ALLOW_SMOOTH_BC_COST_CONTRIBUTION
#undef ALLOW_SMOOTH_IC_COST_CONTRIBUTION

#undef ALLOW_COST_ATLANTIC
C allow for generic cost function and integral terms


# define ALLOW_THETA0_COST_CONTRIBUTION
# define ALLOW_SALT0_COST_CONTRIBUTION
# define ALLOW_THETA_COST_CONTRIBUTION
# define ALLOW_SALT_COST_CONTRIBUTION
# define ALLOW_SST_COST_CONTRIBUTION
# define ALLOW_SSS_COST_CONTRIBUTION


#define ALLOW_GENCOST_CONTRIBUTION
C allow for 3 dimensional generic terms
#define ALLOW_GENCOST3D

#endif /* ALLOW_COST */


C ********************************************************************
C ***               Control vector Package                         ***
C ********************************************************************
C 
#define  CTRL_SET_PREC_32
cph(
#define  ALLOW_NONDIMENSIONAL_CONTROL_IO
#undef  EXCLUDE_CTRL_PACK
#undef  CTRL_SET_OLD_MAXCVARS_40
cph) 
C       >>> Initial values.
#define ALLOW_THETA0_CONTROL
#define ALLOW_SALT0_CONTROL

C       >>> Surface fluxes.
#undef ALLOW_HFLUX_CONTROL
#undef ALLOW_SFLUX_CONTROL
#undef ALLOW_USTRESS_CONTROL
#undef ALLOW_VSTRESS_CONTROL

C       >>> Atmospheric state.
#define  ALLOW_ATEMP_CONTROL
#define  ALLOW_AQH_CONTROL
#define  ALLOW_PRECIP_CONTROL
#define  ALLOW_SWDOWN_CONTROL
#define  ALLOW_UWIND_CONTROL
#define  ALLOW_VWIND_CONTROL

C       >>> Open boundaries
c       >>> Make sure that ALLOW_OBCS is defined
#undef  ALLOW_OBCSN_CONTROL
#undef  ALLOW_OBCSS_CONTROL
#undef  ALLOW_OBCSW_CONTROL
#define  ALLOW_OBCSE_CONTROL
#if (defined (ALLOW_OBCSN_CONTROL) || \
     defined (ALLOW_OBCSS_CONTROL) || \
     defined (ALLOW_OBCSW_CONTROL) || \
     defined (ALLOW_OBCSE_CONTROL))
#define ALLOW_OBCS_CONTROL
#endif
#undef ALLOW_OBCS_CONTROL_MODES

#undef ALLOW_CTRL_OBCS_BALANCE
#undef BALANCE_CONTROL_VOLFLUX_GLOBAL 
#undef BAROTROPIC_OBVEL_CONTROL

C ********************************************************************
C ***             External forcing Package                         ***
C ********************************************************************
C 
C o Include/exclude the external forcing package. To use this package,
C   you have to include the calendar tool as well. KPP can be switched
C   on or off. The implementation automatically takes care of this.
#define INCLUDE_EXTERNAL_FORCING_PACKAGE

C   Do more printout for the protocol file than usual.
#undef EXF_VERBOSE

C   Bulk formulae related flags.
#define ALLOW_RUNOFF
#define ALLOW_DOWNWARD_RADIATION
#define ALLOW_ATM_TEMP
#define ALLOW_ATM_WIND
#if (defined (ALLOW_ATM_TEMP) || \
     defined (ALLOW_ATM_WIND))
# define ALLOW_BULKFORMULAE
#endif

C   Relaxation to monthly climatologies.
#undef ALLOW_CLIMTEMP_RELAXATION
#undef ALLOW_CLIMSALT_RELAXATION
#undef ALLOW_CLIMSST_RELAXATION
#undef ALLOW_CLIMSSS_RELAXATION

#define EXF_INTERP_USE_DYNALLOC
#define USE_EXF_INTERPOLATION


#endif /* ECCO_CPPOPTIONS_H */

