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

!>  @brief  Allocates the data for each mesh chunk
!>  @author Wayne Gaudin
!>  @details The data fields for the mesh chunk are allocated based on the mesh
!>  size.

SUBROUTINE build_field()

  USE clover_module

  IMPLICIT NONE

  INTEGER :: j,k
  INTEGER :: t

!$OMP PARALLEL
!$OMP DO
  DO t=1,tiles_per_task
    chunk%tiles(t)%field%x_min=1
    chunk%tiles(t)%field%y_min=1

    chunk%tiles(t)%field%x_max=chunk%tiles(t)%x_cells
    chunk%tiles(t)%field%y_max=chunk%tiles(t)%y_cells

    ALLOCATE(chunk%tiles(t)%field%density0 (chunk%tiles(t)%field%x_min-2:chunk%tiles(t)%field%x_max+2, &
         chunk%tiles(t)%field%y_min-2:chunk%tiles(t)%field%y_max+2))
    ALLOCATE(chunk%tiles(t)%field%density1 (chunk%tiles(t)%field%x_min-2:chunk%tiles(t)%field%x_max+2, &
         chunk%tiles(t)%field%y_min-2:chunk%tiles(t)%field%y_max+2))
    ALLOCATE(chunk%tiles(t)%field%energy0  (chunk%tiles(t)%field%x_min-2:chunk%tiles(t)%field%x_max+2, &
         chunk%tiles(t)%field%y_min-2:chunk%tiles(t)%field%y_max+2))
    ALLOCATE(chunk%tiles(t)%field%energy1  (chunk%tiles(t)%field%x_min-2:chunk%tiles(t)%field%x_max+2, &
         chunk%tiles(t)%field%y_min-2:chunk%tiles(t)%field%y_max+2))

    ALLOCATE(chunk%tiles(t)%field%pressure  (chunk%tiles(t)%field%x_min-2:chunk%tiles(t)%field%x_max+2, &
                    chunk%tiles(t)%field%y_min-2:chunk%tiles(t)%field%y_max+2))
    ALLOCATE(chunk%tiles(t)%field%viscosity (chunk%tiles(t)%field%x_min-2:chunk%tiles(t)%field%x_max+2, &
                    chunk%tiles(t)%field%y_min-2:chunk%tiles(t)%field%y_max+2))
    ALLOCATE(chunk%tiles(t)%field%soundspeed(chunk%tiles(t)%field%x_min-2:chunk%tiles(t)%field%x_max+2, &
                    chunk%tiles(t)%field%y_min-2:chunk%tiles(t)%field%y_max+2))

    ALLOCATE(chunk%tiles(t)%field%xvel0(chunk%tiles(t)%field%x_min-2:chunk%tiles(t)%field%x_max+3, &
                                       chunk%tiles(t)%field%y_min-2:chunk%tiles(t)%field%y_max+3))
    ALLOCATE(chunk%tiles(t)%field%xvel1(chunk%tiles(t)%field%x_min-2:chunk%tiles(t)%field%x_max+3, &
                                       chunk%tiles(t)%field%y_min-2:chunk%tiles(t)%field%y_max+3))
    ALLOCATE(chunk%tiles(t)%field%yvel0(chunk%tiles(t)%field%x_min-2:chunk%tiles(t)%field%x_max+3, &
                                       chunk%tiles(t)%field%y_min-2:chunk%tiles(t)%field%y_max+3))
    ALLOCATE(chunk%tiles(t)%field%yvel1(chunk%tiles(t)%field%x_min-2:chunk%tiles(t)%field%x_max+3, &
                                       chunk%tiles(t)%field%y_min-2:chunk%tiles(t)%field%y_max+3))

    ALLOCATE(chunk%tiles(t)%field%vol_flux_x (chunk%tiles(t)%field%x_min-2:chunk%tiles(t)%field%x_max+3, &
                                             chunk%tiles(t)%field%y_min-2:chunk%tiles(t)%field%y_max+2))
    ALLOCATE(chunk%tiles(t)%field%mass_flux_x(chunk%tiles(t)%field%x_min-2:chunk%tiles(t)%field%x_max+3, &
                                             chunk%tiles(t)%field%y_min-2:chunk%tiles(t)%field%y_max+2))
    ALLOCATE(chunk%tiles(t)%field%vol_flux_y (chunk%tiles(t)%field%x_min-2:chunk%tiles(t)%field%x_max+2, &
                                             chunk%tiles(t)%field%y_min-2:chunk%tiles(t)%field%y_max+3))
    ALLOCATE(chunk%tiles(t)%field%mass_flux_y(chunk%tiles(t)%field%x_min-2:chunk%tiles(t)%field%x_max+2, &
                                             chunk%tiles(t)%field%y_min-2:chunk%tiles(t)%field%y_max+3))

    ALLOCATE(chunk%tiles(t)%field%work_array1 (chunk%tiles(t)%field%x_min-2:chunk%tiles(t)%field%x_max+3, &
         chunk%tiles(t)%field%y_min-2:chunk%tiles(t)%field%y_max+3))
    ALLOCATE(chunk%tiles(t)%field%work_array2(chunk%tiles(t)%field%x_min-2:chunk%tiles(t)%field%x_max+3, &
         chunk%tiles(t)%field%y_min-2:chunk%tiles(t)%field%y_max+3))
    ALLOCATE(chunk%tiles(t)%field%work_array3 (chunk%tiles(t)%field%x_min-2:chunk%tiles(t)%field%x_max+3, &
         chunk%tiles(t)%field%y_min-2:chunk%tiles(t)%field%y_max+3))
    ALLOCATE(chunk%tiles(t)%field%work_array4 (chunk%tiles(t)%field%x_min-2:chunk%tiles(t)%field%x_max+3, &
         chunk%tiles(t)%field%y_min-2:chunk%tiles(t)%field%y_max+3))
    ALLOCATE(chunk%tiles(t)%field%work_array5(chunk%tiles(t)%field%x_min-2:chunk%tiles(t)%field%x_max+3, &
         chunk%tiles(t)%field%y_min-2:chunk%tiles(t)%field%y_max+3))
    ALLOCATE(chunk%tiles(t)%field%work_array6(chunk%tiles(t)%field%x_min-2:chunk%tiles(t)%field%x_max+3, &
         chunk%tiles(t)%field%y_min-2:chunk%tiles(t)%field%y_max+3))
    ALLOCATE(chunk%tiles(t)%field%work_array7 (chunk%tiles(t)%field%x_min-2:chunk%tiles(t)%field%x_max+3, &
         chunk%tiles(t)%field%y_min-2:chunk%tiles(t)%field%y_max+3))

    ALLOCATE(chunk%tiles(t)%field%cellx   (chunk%tiles(t)%field%x_min-2:chunk%tiles(t)%field%x_max+2))
    ALLOCATE(chunk%tiles(t)%field%celly   (chunk%tiles(t)%field%y_min-2:chunk%tiles(t)%field%y_max+2))
    ALLOCATE(chunk%tiles(t)%field%vertexx (chunk%tiles(t)%field%x_min-2:chunk%tiles(t)%field%x_max+3))
    ALLOCATE(chunk%tiles(t)%field%vertexy (chunk%tiles(t)%field%y_min-2:chunk%tiles(t)%field%y_max+3))
    ALLOCATE(chunk%tiles(t)%field%celldx  (chunk%tiles(t)%field%x_min-2:chunk%tiles(t)%field%x_max+2))
    ALLOCATE(chunk%tiles(t)%field%celldy  (chunk%tiles(t)%field%y_min-2:chunk%tiles(t)%field%y_max+2))
    ALLOCATE(chunk%tiles(t)%field%vertexdx(chunk%tiles(t)%field%x_min-2:chunk%tiles(t)%field%x_max+3))
    ALLOCATE(chunk%tiles(t)%field%vertexdy(chunk%tiles(t)%field%y_min-2:chunk%tiles(t)%field%y_max+3))
    ALLOCATE(chunk%tiles(t)%field%volume  (chunk%tiles(t)%field%x_min-2:chunk%tiles(t)%field%x_max+2, &
         chunk%tiles(t)%field%y_min-2:chunk%tiles(t)%field%y_max+2))
    ALLOCATE(chunk%tiles(t)%field%xarea   (chunk%tiles(t)%field%x_min-2:chunk%tiles(t)%field%x_max+3, &
         chunk%tiles(t)%field%y_min-2:chunk%tiles(t)%field%y_max+2))
    ALLOCATE(chunk%tiles(t)%field%yarea   (chunk%tiles(t)%field%x_min-2:chunk%tiles(t)%field%x_max+2, &
         chunk%tiles(t)%field%y_min-2:chunk%tiles(t)%field%y_max+3))

  ! Zeroing isn't strictly neccessary but it ensures physical pages
  ! are allocated. This prevents first touch overheads in the main code
  ! cycle which can skew timings in the first step
  ! Explicit loop limits ensures correct NUMA access, which array syntax does
  ! not
!$OMP PARALLEL
!$OMP DO
  DO k=chunk%tiles(t)%field%y_min-2,chunk%tiles(t)%field%y_max+2
    DO j=chunk%tiles(t)%field%x_min-2,chunk%tiles(t)%field%x_max+2
      chunk%tiles(t)%field%density0(j,k)=0.0
      chunk%tiles(t)%field%density1(j,k)=0.0
      chunk%tiles(t)%field%energy0(j,k)=0.0
      chunk%tiles(t)%field%energy1(j,k)=0.0

      chunk%tiles(t)%field%pressure(j,k)=0.0
      chunk%tiles(t)%field%soundspeed(j,k)=0.0
      chunk%tiles(t)%field%viscosity(j,k)=0.0
    ENDDO
  ENDDO
!$OMP ENDDO
!$OMP DO
  DO k=chunk%tiles(t)%field%y_min-2,chunk%tiles(t)%field%y_max+2
    DO j=chunk%tiles(t)%field%x_min-2,chunk%tiles(t)%field%x_max+3
      chunk%tiles(t)%field%vol_flux_x(j,k)=0.0
      chunk%tiles(t)%field%mass_flux_x(j,k)=0.0
    ENDDO
  ENDDO
!$OMP ENDDO
!$OMP DO
  DO k=chunk%tiles(t)%field%y_min-2,chunk%tiles(t)%field%y_max+3
    DO j=chunk%tiles(t)%field%x_min-2,chunk%tiles(t)%field%x_max+2
      chunk%tiles(t)%field%vol_flux_y(j,k)=0.0
      chunk%tiles(t)%field%mass_flux_y(j,k)=0.0
    ENDDO
  ENDDO
!$OMP ENDDO
!$OMP DO
  DO k=chunk%tiles(t)%field%y_min-2,chunk%tiles(t)%field%y_max+3
    DO j=chunk%tiles(t)%field%x_min-2,chunk%tiles(t)%field%x_max+3
      chunk%tiles(t)%field%xvel0(j,k)=0.0
      chunk%tiles(t)%field%xvel1(j,k)=0.0
      chunk%tiles(t)%field%yvel0(j,k)=0.0
      chunk%tiles(t)%field%yvel1(j,k)=0.0

      chunk%tiles(t)%field%work_array1(j,k)=0.0
      chunk%tiles(t)%field%work_array2(j,k)=0.0
      chunk%tiles(t)%field%work_array3(j,k)=0.0
      chunk%tiles(t)%field%work_array4(j,k)=0.0
      chunk%tiles(t)%field%work_array5(j,k)=0.0
      chunk%tiles(t)%field%work_array6(j,k)=0.0
      chunk%tiles(t)%field%work_array7(j,k)=0.0
    ENDDO
  ENDDO
!$OMP ENDDO
!$OMP DO
  DO k=chunk%tiles(t)%field%y_min-2,chunk%tiles(t)%field%y_max+2
    DO j=chunk%tiles(t)%field%x_min-2,chunk%tiles(t)%field%x_max+2
      chunk%tiles(t)%field%volume(j,k)=0.0
    ENDDO
  ENDDO
!$OMP ENDDO
!$OMP DO
  DO k=chunk%tiles(t)%field%y_min-2,chunk%tiles(t)%field%y_max+2
      DO j=chunk%tiles(t)%field%x_min-2,chunk%tiles(t)%field%x_max+3
          chunk%tiles(t)%field%xarea(j,k)=0.0
      ENDDO
  ENDDO
!$OMP END DO
!$OMP DO
  DO k=chunk%tiles(t)%field%y_min-2,chunk%tiles(t)%field%y_max+3
      DO j=chunk%tiles(t)%field%x_min-2,chunk%tiles(t)%field%x_max+2
          chunk%tiles(t)%field%yarea(j,k)=0.0
      ENDDO
  ENDDO
!$OMP END DO
!$OMP DO
  DO j=chunk%tiles(t)%field%x_min-2,chunk%tiles(t)%field%x_max+2
      chunk%tiles(t)%field%cellx(j)=0.0
      chunk%tiles(t)%field%celldx(j)=0.0
  ENDDO
!$OMP END DO
!$OMP DO
  DO k=chunk%tiles(t)%field%y_min-2,chunk%tiles(t)%field%y_max+2
      chunk%tiles(t)%field%celly(k)=0.0
      chunk%tiles(t)%field%celldy(k)=0.0
  ENDDO
!$OMP END DO
!$OMP DO
  DO j=chunk%tiles(t)%field%x_min-2,chunk%tiles(t)%field%x_max+3
      chunk%tiles(t)%field%vertexx(j)=0.0
      chunk%tiles(t)%field%vertexdx(j)=0.0
  ENDDO
!$OMP END DO
!$OMP DO
  DO k=chunk%tiles(t)%field%y_min-2,chunk%tiles(t)%field%y_max+3
      chunk%tiles(t)%field%vertexy(k)=0.0
      chunk%tiles(t)%field%vertexdy(k)=0.0
  ENDDO
!$OMP END DO
!$OMP END PARALLEL

  ENDDO
!$OMP END DO
!$OMP END PARALLEL

END SUBROUTINE build_field
