function [XF,YF,ZF,XX,YY,ZZ,M] = GEOPACK_EXAMPLE1;
%function [XF,YF,ZF,XX,YY,ZZ,M] = GEOPACK_EXAMPLE1;
%       PROGRAM EXAMPLE1
% XF,YF,ZF end of example field line trace (GSM)
% XX,YY,ZZ all points in field line trace (GSM)
% M index of last 'real' point in field line trace
% C
% C   IN THIS EXAMPLE IT IS ASSUMED THAT WE KNOW GEOGRAPHIC COORDINATES OF A FOOTPOINT
% C   OF A FIELD LINE AT THE EARTH'S SURFACE AND TRACE THAT LINE FOR A SPECIFIED
% C   MOMENT OF UNIVERSAL TIME, USING A FULL IGRF EXPANSION FOR THE INTERNAL FIELD
% C


%       DIMENSION XX(500),YY(500),ZZ(500), PARMOD(10)
PARMOD = zeros(10,1);
% c
% c    Be sure to include an EXTERNAL statement in your codes, specifying the names
% c    of external and internal field model subroutines in the package, as shown below.
% c    In this example, the external and internal field models are T96_01 and IGRF_GSM,
% c    respectively. Any other models can be used, provided they have the same format
% c    and the same meaning of the input/output parameters.
% c
%       EXTERNAL T96_01,IGRF_GSM
% C
% C   DEFINE THE UNIVERSAL TIME AND PREPARE THE COORDINATE TRANSFORMATION PARAMETERS
% C   BY INVOKING THE SUBROUTINE RECALC: IN THIS PARTICULAR CASE WE TRACE A LINE
% C   FOR YEAR=1997, IDAY=350, UT HOUR = 21, MIN = SEC = 0
% C
GEOPACK_RECALC (1997,350,21,0,0);
% c
% c   Enter T96 model input parameters:
% c
%       PRINT *, '   ENTER SOLAR WIND RAM PRESSURE IN NANOPASCALS'
%       READ *, PARMOD(1)
PARMOD(1) = 3; % Solar Wind Ram Pressure, nPa

% % C
%       PRINT *, '   ENTER DST '
%       READ *, PARMOD(2)
PARMOD(2) = -20; % Dst, nT

% % C
%       PRINT *, '   ENTER IMF BY AND BZ'
%       READ *, PARMOD(3),PARMOD(4)
PARMOD(3) = 3; % By, GSM, nT
PARMOD(4) = -3; % Bz, GSM, nT


% C
% C    THE LINE WILL BE TRACED FROM A POINT WITH GEOGRAPHICAL LONGITUDE 45 DEGREES
% C     AND LATITUDE 75 DEGREES:
% C
GEOLAT=75.;
GEOLON=45.;
COLAT=(90.-GEOLAT)*.01745329;
XLON=GEOLON*.01745329;
% C
% C   CONVERT SPHERICAL COORDS INTO CARTESIAN :
% C
%      CALL SPHCAR(1.,COLAT,XLON,XGEO,YGEO,ZGEO,1)
[XGEO,YGEO,ZGEO] = GEOPACK_SPHCAR(1.,COLAT,XLON,1);
% C
% C   TRANSFORM GEOGRAPHICAL GEOCENTRIC COORDS INTO SOLAR MAGNETOSPHERIC ONES:
% C
[XGSM,YGSM,ZGSM] = GEOPACK_GEOGSM (XGEO,YGEO,ZGEO,1);
% C
% c   SPECIFY TRACING PARAMETERS:
% C
DIR=1.;
% C            (TRACE THE LINE WITH A FOOTPOINT IN THE NORTHERN HEMISPHERE, THAT IS,
% C             ANTIPARALLEL TO THE MAGNETIC FIELD)

RLIM=60.;
% C            (LIMIT THE TRACING REGION WITHIN R=60 Re)
% C
R0=1.;
% C            (LANDING POINT WILL BE CALCULATED ON THE SPHERE R=1,
% C                   I.E. ON THE EARTH'S SURFACE)
% c
IOPT=0;
% C           (IN THIS EXAMPLE IOPT IS JUST A DUMMY PARAMETER,
% C                 WHOSE VALUE DOES NOT MATTER)
% C
% C   TRACE THE FIELD LINE:
% C
%       CALL TRACE(XGSM,YGSM,ZGSM,DIR,RLIM,R0,IOPT,PARMOD,T96_01,IGRF_GSM,
%      *  XF,YF,ZF,XX,YY,ZZ,M)
[XF,YF,ZF,XX,YY,ZZ,M] = GEOPACK_TRACE(XGSM,YGSM,ZGSM,DIR,RLIM,R0,IOPT,PARMOD,'T96','GEOPACK_IGRF_GSM');
% C
% C   WRITE THE RESULTS IN THE DATAFILE 'LINTEST1.DAT':
% C
%         OPEN(UNIT=1,FILE='LINTEST1.DAT',STATUS='NEW')
%         WRITE (1,20) (XX(L),YY(L),ZZ(L),L=1,M)
%  20     FORMAT((2X,3F6.2))
%         CLOSE(UNIT=1)
%       STOP
%       END
% end of function EXAMPLE2

