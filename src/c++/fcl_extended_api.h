#pragma once 

extern "C" {
namespace fcl_fortran_inferface {


void add_fcl_surface(int num_verts, 
                     int num_tris, 
                     const double *vertices, 
                     const int *triangles);

void calculate_fcl_contacts();

void get_num_fcl_contacts(int &num_contacts);

void get_fcl_contacts(int &num_contacts, 
                      double &contact_coords, 
                      int &object_pair, 
                      int &surf_ids_slv, 
                      int &surf_ids_mstr);

void clean_fcl_surfaces();

}
}
