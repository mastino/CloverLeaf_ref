!Crown Copyright 2012 AWE.
!
! This file is part of CloverLeaf.
!
! CloverLeaf is free software: you can redistribute it and/or modify it under 
! the terms of the GNU General Public License as published by the 
! Free Software Foundation, either version 3 of the License, or (at your option) 
! any later version.
!
! CloverLeaf is distributed in the hope that it will be useful, but 
! WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or 
! FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more 
! details.
!
! You should have received a copy of the GNU General Public License along with 
! CloverLeaf. If not, see http://www.gnu.org/licenses/.

!>  @brief Driver for the field summary kernels
!>  @author Wayne Gaudin
!>  @details The user specified field summary kernel is invoked here. A summation
!>  across all mesh chunks is then performed and the information outputed.
!>  If the run is a test problem, the final result is compared with the expected
!>  result and the difference output.
!>  Note the reference solution is the value returned from an Intel compiler with
!>  ieee options set on a single core crun.

SUBROUTINE field_summary()

  USE clover_module
  USE ideal_gas_module
  USE field_summary_kernel_module

  IMPLICIT NONE

  REAL(KIND=8) :: vol,mass,ie,ke,press
  REAL(KIND=8) :: tile_vol,tile_mass,tile_ie,tile_ke,tile_press
  REAL(KIND=8) :: qa_diff

!$ INTEGER :: OMP_GET_THREAD_NUM

  INTEGER      :: t

  REAL(KIND=8) :: kernel_time,timer

  IF(parallel%boss) THEN
    WRITE(g_out,*)
    WRITE(g_out,*) 'Time ',time
    WRITE(g_out,'(a13,7a18)')'           ','Volume','Mass','Density','Pressure','Internal Energy','Kinetic Energy','Total Energy'
  ENDIF

  vol=0.0
  mass=0.0
  ie=0.0
  ke=0.0
  press=0.0

  IF(profiler_on) kernel_time=timer()
  CALL ideal_gas(.FALSE.)
  IF(profiler_on) profiler%ideal_gas=profiler%ideal_gas+(timer()-kernel_time)

  IF(profiler_on) kernel_time=timer()
  IF(use_fortran_kernels)THEN
!$OMP PARALLEL PRIVATE(tile_vol,tile_mass,tile_ie,tile_ke,tile_press)
!$OMP DO REDUCTION(+ : vol,mass,ie,ke,press)
    DO t=1,tiles_per_task
      tile_vol=0.0
      tile_mass=0.0
      tile_ie=0.0
      tile_ke=0.0
      tile_press=0.0

      CALL field_summary_kernel(chunk%tiles(t)%field%x_min,                   &
                                chunk%tiles(t)%field%x_max,                   &
                                chunk%tiles(t)%field%y_min,                   &
                                chunk%tiles(t)%field%y_max,                   &
                                chunk%tiles(t)%field%volume,                  &
                                chunk%tiles(t)%field%density0,                &
                                chunk%tiles(t)%field%energy0,                 &
                                chunk%tiles(t)%field%pressure,                 &
                                chunk%tiles(t)%field%xvel0,                 &
                                chunk%tiles(t)%field%yvel0,                 &
                                tile_vol,tile_mass,tile_ie,tile_ke,tile_press)

      vol = vol + tile_vol
      mass = mass + tile_mass
      ie = ie + tile_ie
      ke = ke + tile_ke
      press = press + tile_press
    ENDDO
!$OMP END DO NOWAIT
!$OMP END PARALLEL
  ENDIF


  ! For mpi I need a reduction here
  CALL clover_sum(vol)
  CALL clover_sum(mass)
  CALL clover_sum(press)
  CALL clover_sum(ie)
  CALL clover_sum(ke)
  IF(profiler_on) profiler%summary=profiler%summary+(timer()-kernel_time)

  IF(parallel%boss) THEN
!$  IF(OMP_GET_THREAD_NUM().EQ.0) THEN
      WRITE(g_out,'(a6,i7,7e18.10)')' step:',step,vol,mass,mass/vol,press/vol,ie,ke,ie+ke
      WRITE(g_out,*)
!$  ENDIF
  ENDIF

  !Check if this is the final call and if it is a test problem, check the result.
  IF(complete) THEN
    IF(parallel%boss) THEN
!$    IF(OMP_GET_THREAD_NUM().EQ.0) THEN
        IF(test_problem.GE.1) THEN
          IF(test_problem.EQ.1) qa_diff=ABS((100.0_8*(ke/1.82280367310258_8))-100.0_8)
          IF(test_problem.EQ.2) qa_diff=ABS((100.0_8*(ke/1.19316898756307_8))-100.0_8)
          IF(test_problem.EQ.3) qa_diff=ABS((100.0_8*(ke/2.58984003503994_8))-100.0_8)
          IF(test_problem.EQ.4) qa_diff=ABS((100.0_8*(ke/0.307475452287895_8))-100.0_8)
          IF(test_problem.EQ.5) qa_diff=ABS((100.0_8*(ke/4.85350315783719_8))-100.0_8)
          WRITE(*,'(a,i4,a,e16.7,a)')"Test problem", Test_problem," is within",qa_diff,"% of the expected solution"
          WRITE(g_out,'(a,i4,a,e16.7,a)')"Test problem", Test_problem," is within",qa_diff,"% of the expected solution"
          IF(qa_diff.LT.0.001) THEN
            WRITE(*,*)"This test is considered PASSED"
            WRITE(g_out,*)"This test is considered PASSED"
          ELSE
            WRITE(*,*)"This test is considered NOT PASSED"
            WRITE(g_out,*)"This is test is considered NOT PASSED"
          ENDIF
        ENDIF
!$    ENDIF
    ENDIF
  ENDIF

END SUBROUTINE field_summary
