module fcl_mod
    use iso_fortran_env


    type surface_map
        integer(int32), dimension(:), allocatable :: vert_ids
    end type surface_map

    integer(int32) :: num_surface_maps = 0
    type(surface_map), dimension(:), allocatable :: surface_maps



    type contact_obj
        real(real64) :: time_of_Contact = 0.0d0
        real(real64), dimension(3) :: contact_point = 0.0d0
        integer(int32), dimension(3) :: surf_ids_slv = 0
        integer(int32), dimension(3) :: surf_ids_mstr = 0
    end type contact_obj

    type(contact_obj), dimension(:), allocatable :: contacts

    interface

        subroutine add_fcl_surface_c(num_verts, num_tris, vertices, triangles) &
            & bind(C, name="add_fcl_surface")
            import
            use iso_c_binding 
            integer(kind=c_int), value, intent(in) :: num_verts
            integer(kind=c_int), value, intent(in) :: num_tris
            integer(kind=c_int), intent(in) :: triangles
            real(kind=c_double), intent(in) :: vertices
        end subroutine add_fcl_surface_c


        subroutine get_num_fcl_contacts_c(num_contacts) &
            & bind(C, name="get_num_fcl_contacts")
            import
            use iso_c_binding 
            integer(c_int), intent(out) :: num_contacts
        end subroutine get_num_fcl_contacts_c


        subroutine get_fcl_contacts_c(num_contacts, contact_coords, object_pair, surf_ids_slv, surf_ids_mstr) &
            & bind(C, name="get_fcl_contacts")
            import
            use iso_c_binding
            integer(kind=c_int), value, intent(in) :: num_contacts
            real(kind=c_double), intent(out) :: contact_coords
            integer(kind=c_int), intent(out)  :: object_pair
            integer(kind=c_int), intent(out)  :: surf_ids_slv
            integer(kind=c_int), intent(out)  :: surf_ids_mstr
        end subroutine get_fcl_contacts_c


        subroutine clean_fcl_surfaces_c() &
            & bind(C, name="clean_fcl_surfaces")
            import
        end subroutine clean_fcl_surfaces_c

    end interface


contains


integer(int32) function add_contact_surface(num_verts, num_tris, vertices, vert_ids, triangles) result(surface_id)
    use iso_c_binding
    implicit none
    integer(c_int), intent(in) :: num_verts
    integer(c_int), intent(in) :: num_tris
    real(c_double), dimension(3,num_verts), intent(in) :: vertices
    integer(c_int), dimension(num_verts), intent(in) :: vert_ids
    integer(c_int), dimension(num_tris), intent(in) :: triangles

    call add_fcl_surface_c(num_verts, num_tris, vertices, triangles)
    call add_surface_map(num_verts, vert_ids)

    surface_id = num_surface_maps

    return
end function add_contact_surface


subroutine add_surface_map(num_verts, vert_ids)
    implicit none
    integer(int32), intent(in) :: num_verts
    integer(int32), dimension(num_verts), intent(in) :: vert_ids

    type(surface_map), dimension(:), allocatable :: temp_maps

    if (.not.allocated(surface_maps)) then
        allocate(surface_maps(10))
    endif

    if (num_surface_maps.eq.size(surface_maps)) then
        allocate(temp_maps(2*num_surface_maps))
        temp_maps(1:num_surface_maps) = surface_maps
        deallocate(surface_maps)

        allocate(surface_maps(2*num_surface_maps))
        surface_maps = temp_maps
        deallocate(temp_maps)
    endif

    num_surface_maps = num_surface_maps + 1
    allocate(surface_maps(num_surface_maps)%vert_ids(num_verts))
    surface_maps(num_surface_maps)%vert_ids = vert_ids

    return
end subroutine add_surface_map


subroutine update_surface_position
    implicit none
end subroutine update_surface_position



subroutine find_contacts()
    use iso_c_binding
    implicit none 
    integer(c_int) :: num_contacts
    real(c_double), dimension(:), allocatable :: contact_coords
    integer(c_int), dimension(:), allocatable  :: object_pair
    integer(c_int), dimension(:), allocatable  :: surf_ids_slv
    integer(c_int), dimension(:), allocatable  :: surf_ids_mstr

    integer(int32) :: i

    num_contacts = 0
    call get_num_fcl_contacts_c(num_contacts)

    allocate(contact_coords(3*num_contacts))
    allocate(object_pair(2*num_contacts))
    allocate(surf_ids_slv(3*num_contacts))
    allocate(surf_ids_mstr(3*num_contacts))
    call get_fcl_contacts_c(num_contacts, contact_coords, object_pair, surf_ids_slv, surf_ids_mstr)

    if (allocated(contacts)) deallocate(contacts)
    allocate(contacts(num_contacts))
    do i=1, num_contacts
        contacts(i)%contact_point = contact_coords(3*i-2:3*i)
        contacts(i)%surf_ids_slv = surface_maps(object_pair(2*i-1))%vert_ids(surf_ids_slv(3*i-2:3*i))
        contacts(i)%surf_ids_mstr = surface_maps(object_pair(2*i))%vert_ids(surf_ids_mstr(3*i-2:3*i))
    enddo

    return
end subroutine find_contacts



integer(int32) function delete_surface(surface_id) result(ierr)
    implicit none 
    integer(int32), intent(in) :: surface_id

    ierr = 0

    return
end function delete_surface


subroutine clean_surfaces()
    implicit none 
    integer(int32) :: i 

    if (allocated(surface_maps)) then 
        do i=1, num_surface_maps
            surface_maps(i)%id = -1
            if (allocated(surface_maps(i)%vert_ids)) deallocate(surface_maps(i)%vert_ids)
        enddo
    endif

    return
end subroutine clean_surfaces


subroutine delete_surfaces()
    implicit none 
    integer(int32) :: i 

    if (allocated(surface_maps)) then 
        do i=1, size(surface_maps)
            surface_maps(i)%id = -1
            if (allocated(surface_maps(i)%vert_ids)) deallocate(surface_maps(i)%vert_ids)
        enddo
    endif

    ! Clean up cpp surfaces, too
    call clean_fcl_surfaces_c()

    return
end subroutine delete_surfaces


end module fcl_mod
