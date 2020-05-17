module fcl_mod
    use iso_fortran_env


    type surface_map
        integer(int32) :: id
        integer(int32), dimension(:), allocatable :: vert_ids
    end type surface_map

    type contact_obj
        real(real64) :: time_of_Contact
        integer(int32) :: contact_type ! 1 : node-node, 2 : edge-edge, 3 : node-face
    end type contact_obj

    type(surface_map), dimension(:), allocatable :: surface_maps

contains

integer(int32) function add_surface(num_verts, num_tris, vertices, vert_ids, triangles) result(surface_id)
    use iso_c_binding
    implicit none
    integer(c_int), intent(in) :: num_verts
    integer(c_int), intent(in) :: num_tris
    real(real64), dimension(3,num_verts), intent(in) :: vertices
    integer(int32), dimension(num_verts), intent(in) :: vert_ids
    integer(int32), dimension(num_tris), intent(in) :: triangles

    surface_id = -1

    return
end function add_surface


subroutine update_surface_position

    implicit none
end subroutine update_surface_position



subroutine get_contacts(surface_id, contacts)
    implicit none 
    integer(int32), intent(in) :: surface_id
    type(contact_obj), dimension(:), allocatable :: contacts


end subroutine get_contacts



integer(int32) function delete_surface(surface_id) result(ierr)
    implicit none 
    integer(int32), intent(in) :: surface_id

    ierr = 0

    return
end function delete_surface


end module fcl_mod
