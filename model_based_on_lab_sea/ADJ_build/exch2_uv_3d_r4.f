#include "CPP_EEOPTIONS.h"
#include "W2_OPTIONS.h"
#undef DO_CORNER_COPY_V2U

CBOP
C     !ROUTINE: EXCH2_UV_3D_R4

C     !INTERFACE:
      SUBROUTINE EXCH2_UV_3D_R4(
     U                           Uphi, Vphi,
     I                           withSigns, myNz, myThid )

C     !DESCRIPTION:
C     *==========================================================*
C     | SUBROUTINE EXCH2_UV_3D_R4
C     | o Handle exchanges for _R4, 3-dimensional vector arrays.
C     *==========================================================*
C     | Vector arrays need to be rotated and interchanged for
C     | exchange operations on some grids. This driver routine
C     | branches to support this.
C     *==========================================================*

C     !USES:
      IMPLICIT NONE
C     === Global data ===
#include "SIZE.h"
#include "EEPARAMS.h"
#include "W2_EXCH2_SIZE.h"
#include "W2_EXCH2_TOPOLOGY.h"
c#ifdef W2_FILL_NULL_REGIONS
c#include "W2_EXCH2_PARAMS.h"
c#endif

C     !INPUT/OUTPUT PARAMETERS:
C     === Routine arguments ===
C     phi    :: Array with overlap regions are to be exchanged
C               Note - The interface to EXCH_R4 assumes that
C               the standard Fortran 77 sequence association rules
C               apply.
C     myNz   :: 3rd dimension of array to exchange
C     myThid :: My thread id.
      INTEGER myNz
      _R4 Uphi(1-OLx:sNx+OLx,1-OLy:sNy+OLy,myNz,nSx,nSy)
      _R4 Vphi(1-OLx:sNx+OLx,1-OLy:sNy+OLy,myNz,nSx,nSy)
      LOGICAL withSigns
      INTEGER myThid

C     !LOCAL VARIABLES:
C     == Local variables ==
C     OL[wens]       :: Overlap extents in west, east, north, south.
C     exchWidth[XY]  :: Extent of regions that will be exchanged.
      INTEGER OLw, OLe, OLn, OLs, exchWidthX, exchWidthY
      INTEGER bi, bj, myTile, k
#ifdef W2_FILL_NULL_REGIONS
      INTEGER i, j
#else
# ifdef DO_CORNER_COPY_V2U
      INTEGER j
# endif
#endif
CEOP

      OLw        = OLx
      OLe        = OLx
      OLn        = OLy
      OLs        = OLy
      exchWidthX = OLx
      exchWidthY = OLy

       CALL EXCH2_R42_CUBE( Uphi, Vphi, withSigns, 'Cg',
     I            OLw, OLe, OLs, OLn, myNz,
     I            exchWidthX, exchWidthY,
     I            EXCH_IGNORE_CORNERS, myThid )
       CALL EXCH2_R42_CUBE( Uphi, Vphi, withSigns, 'Cg',
     I            OLw, OLe, OLs, OLn, myNz,
     I            exchWidthX, exchWidthY,
     I            EXCH_UPDATE_CORNERS, myThid )

      IF (useCubedSphereExchange) THEN
C---  using CubedSphereExchange:
      DO bj=myByLo(myThid),myByHi(myThid)
       DO bi=myBxLo(myThid),myBxHi(myThid)
        myTile = W2_myTileList(bi,bj)

#ifdef DO_CORNER_COPY_V2U
        IF ( exch2_isEedge(myTile) .EQ. 1 .AND.
     &       exch2_isSedge(myTile) .EQ. 1 ) THEN
         DO k=1,myNz
C         Uphi(sNx+1,    0,k,bi,bj)= vPhi(sNx+1,    1,k,bi,bj)
          DO j=1-OLx,0
           Uphi(sNx+1,    j,k,bi,bj)= vPhi(sNx+(1-j),    1,k,bi,bj)
          ENDDO
         ENDDO
        ENDIF
        IF ( withSigns ) THEN
         IF ( exch2_isEedge(myTile) .EQ. 1 .AND.
     &        exch2_isNedge(myTile) .EQ. 1 ) THEN
          DO k=1,myNz
C          Uphi(sNx+1,sNy+1,k,bi,bj)=-vPhi(sNx+1,sNy+1,k,bi,bj)
           DO j=1,OLx
            Uphi(sNx+1,sNy+j,k,bi,bj)=-vPhi(sNx+j,sNy+1,k,bi,bj)
           ENDDO
          ENDDO
         ENDIF
        ELSE
         IF ( exch2_isEedge(myTile) .EQ. 1 .AND.
     &        exch2_isNedge(myTile) .EQ. 1 ) THEN
          DO k=1,myNz
C          Uphi(sNx+1,sNy+1,k,bi,bj)= vPhi(sNx+1,sNy+1,k,bi,bj)
           DO j=1,OLx
            Uphi(sNx+1,sNy+j,k,bi,bj)= vPhi(sNx+j,sNy+1,k,bi,bj)
           ENDDO
          ENDDO
         ENDIF
        ENDIF
#endif /* DO_CORNER_COPY_V2U */

C--     Now zero out the null areas that should not be used in the numerics
C       Also add one valid u,v value next to the corner, that allows
C        to compute vorticity on a wider stencil (e.g., vort3(0,1) & (1,0))

        IF ( exch2_isWedge(myTile) .EQ. 1 .AND.
     &       exch2_isSedge(myTile) .EQ. 1 ) THEN
C        Zero SW corner points
         DO k=1,myNz
#ifdef W2_FILL_NULL_REGIONS
          DO j=1-OLx,0
           DO i=1-OLx,0
            uPhi(i,j,k,bi,bj)=e2FillValue_R4
           ENDDO
          ENDDO
          DO j=1-OLx,0
           DO i=1-OLx,0
            vPhi(i,j,k,bi,bj)=e2FillValue_R4
           ENDDO
          ENDDO
#endif
          IF ( OLx.GE.2 .AND. OLy.GE.2 ) THEN
            uPhi(0,0,k,bi,bj)=vPhi(1,0,k,bi,bj)
            vPhi(0,0,k,bi,bj)=uPhi(0,1,k,bi,bj)
          ENDIF
         ENDDO
        ENDIF

        IF ( exch2_isWedge(myTile) .EQ. 1 .AND.
     &       exch2_isNedge(myTile) .EQ. 1 ) THEN
C        Zero NW corner points
         DO k=1,myNz
#ifdef W2_FILL_NULL_REGIONS
          DO j=sNy+1,sNy+OLy
           DO i=1-OLx,0
            uPhi(i,j,k,bi,bj)=e2FillValue_R4
           ENDDO
          ENDDO
          DO j=sNy+2,sNy+OLy
           DO i=1-OLx,0
            vPhi(i,j,k,bi,bj)=e2FillValue_R4
           ENDDO
          ENDDO
#endif
          IF ( OLx.GE.2 .AND. OLy.GE.2 ) THEN
           IF ( withSigns ) THEN
            uPhi(0,sNy+1,k,bi,bj)=-vPhi(1,sNy+2,k,bi,bj)
            vPhi(0,sNy+2,k,bi,bj)=-uPhi(0,sNy,k,bi,bj)
           ELSE
            uPhi(0,sNy+1,k,bi,bj)= vPhi(1,sNy+2,k,bi,bj)
            vPhi(0,sNy+2,k,bi,bj)= uPhi(0,sNy,k,bi,bj)
           ENDIF
          ENDIF
         ENDDO
        ENDIF

        IF ( exch2_isEedge(myTile) .EQ. 1 .AND.
     &       exch2_isSedge(myTile) .EQ. 1 ) THEN
C        Zero SE corner points
         DO k=1,myNz
#ifdef W2_FILL_NULL_REGIONS
          DO j=1-OLx,0
           DO i=sNx+2,sNx+OLx
            uPhi(i,j,k,bi,bj)=e2FillValue_R4
           ENDDO
          ENDDO
          DO j=1-OLx,0
           DO i=sNx+1,sNx+OLx
            vPhi(i,j,k,bi,bj)=e2FillValue_R4
           ENDDO
          ENDDO
#endif
          IF ( OLx.GE.2 .AND. OLy.GE.2 ) THEN
           IF ( withSigns ) THEN
            uPhi(sNx+2,0,k,bi,bj)=-vPhi(sNx,0,k,bi,bj)
            vPhi(sNx+1,0,k,bi,bj)=-uPhi(sNx+2,1,k,bi,bj)
           ELSE
            uPhi(sNx+2,0,k,bi,bj)= vPhi(sNx,0,k,bi,bj)
            vPhi(sNx+1,0,k,bi,bj)= uPhi(sNx+2,1,k,bi,bj)
           ENDIF
          ENDIF
         ENDDO
        ENDIF

        IF ( exch2_isEedge(myTile) .EQ. 1 .AND.
     &       exch2_isNedge(myTile) .EQ. 1 ) THEN
C        Zero NE corner points
         DO k=1,myNz
#ifdef W2_FILL_NULL_REGIONS
          DO j=sNy+1,sNy+OLy
           DO i=sNx+2,sNx+OLx
            uPhi(i,j,k,bi,bj)=e2FillValue_R4
           ENDDO
          ENDDO
          DO j=sNy+2,sNy+OLy
           DO i=sNx+1,sNx+OLx
            vPhi(i,j,k,bi,bj)=e2FillValue_R4
           ENDDO
          ENDDO
#endif
          IF ( OLx.GE.2 .AND. OLy.GE.2 ) THEN
            uPhi(sNx+2,sNy+1,k,bi,bj)=vPhi(sNx,sNy+2,k,bi,bj)
            vPhi(sNx+1,sNy+2,k,bi,bj)=uPhi(sNx+2,sNy,k,bi,bj)
          ENDIF
         ENDDO
        ENDIF

       ENDDO
      ENDDO
C---  using or not using CubedSphereExchange: end
      ENDIF

      RETURN
      END

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***
