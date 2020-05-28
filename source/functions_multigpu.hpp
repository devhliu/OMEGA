/**************************************************************************
* Header for matrix-free OpenCL functions for the multi-GPU/device case
*
* Copyright(C) 2020 Ville-Veikko Wettenhovi
*
* This program is free software : you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see <https://www.gnu.org/licenses/>.
***************************************************************************/
#pragma once
#define CL_USE_DEPRECATED_OPENCL_1_2_APIS
#include <vector>
#include "mex.h"
#include "precomp.h"
#include <string>
#include <cmath>

#pragma pack(1)

void OSEM_MLEM(const cl_uint& num_devices_context, const float kerroin, const int cpu_device, const cl_context& context, const cl_command_queue* commandQueues,
	const size_t koko, const uint16_t* lor1, const float* z_det, const float* x, const float* y, const mxArray* Sin, const mxArray* sc_ra, const uint32_t Nx,
	const uint32_t Ny, const uint32_t Nz, const uint32_t Niter, const mxArray* options, const float dx, const float dy, const float dz, const float bx,
	const float by, const float bz, const float bzb, const float maxxx, const float maxyy, const float zmax, const float NSlices, const uint32_t* pituus,
	const size_t koko_l, const uint32_t* xy_index, const uint16_t* z_index, const uint32_t size_x, const uint16_t TotSinos, const bool verbose,
	const uint32_t randoms_correction, const uint32_t attenuation_correction, const uint32_t normalization, const float* atten, const size_t size_atten,
	const float* norm, const size_t size_norm, const uint32_t subsets, const float epps, const uint32_t Nt, const uint32_t* pseudos, const uint32_t det_per_ring,
	const uint32_t prows, const uint16_t* L, const uint8_t raw, const size_t size_z, const uint32_t im_dim, const cl_kernel kernel, const cl_kernel& kernel_sum,
	const cl_kernel& kernel_mlem, const cl_kernel& kernel_convolution, const cl_kernel& kernel_convolution_f, const cl_kernel& kernel_vectorMult, 
	const cl_kernel& kernel_vectorDiv, const size_t numel_x, const float tube_width, const float crystal_size_z, const float* x_center, const float* y_center, 
	const float* z_center, const size_t size_center_x, const size_t size_center_y, const size_t size_center_z, const bool atomic_64bit, 
	const cl_uchar compute_norm_matrix, const bool precompute, const int32_t dec, const uint32_t projector_type, const uint16_t n_rays, const uint16_t n_rays3D, 
	const float cr_pz, mxArray* cell, const bool osem_bool, const float global_factor, const float bmin, const float bmax, const float Vmax, const float* V, 
	const size_t size_V, const size_t local_size, const bool use_psf, const float* gaussian, const size_t size_gauss, const uint32_t scatter);

void f_b_project(const cl_uint& num_devices_context, const float kerroin, const int cpu_device, const cl_context& context, const cl_command_queue* commandQueues,
	const size_t koko, const uint16_t* lor1, const float* z_det, const float* x, const float* y, const float* rhs, const mxArray* sc_ra, const uint32_t Nx,
	const uint32_t Ny, const uint32_t Nz, const float dx, const float dy, const float dz, const float bx, const float by, const float bz, const float bzb,
	const float maxxx, const float maxyy, const float zmax, const float NSlices, const uint32_t* pituus, const size_t koko_l, const uint32_t* xy_index,
	const uint16_t* z_index, const uint32_t size_x, const uint16_t TotSinos, const bool verbose, const uint32_t randoms_correction,
	const uint32_t attenuation_correction, const uint32_t normalization, const float* atten, const size_t size_atten, const float* norm, const size_t size_norm,
	const uint32_t* pseudos, const uint32_t det_per_ring, const uint32_t prows, const uint16_t* L, const uint8_t raw, const size_t size_z, const uint32_t im_dim,
	const cl_kernel& kernel_sum, const cl_kernel& kernel, mxArray* output, const size_t size_rhs, const bool no_norm, const size_t numel_x,
	const float tube_width, const float crystal_size_z, const float* x_center, const float* y_center, const float* z_center, const size_t size_center_x,
	const size_t size_center_y, const size_t size_center_z, const bool precompute, const int32_t dec, const uint32_t projector_type, const uint16_t n_rays, 
	const uint16_t n_rays3D, const float cr_pz, const mxArray* Sin, const bool atomic_64bit, const float global_factor, const float bmin, const float bmax, 
	const float Vmax, const float* V, const size_t size_V, const uint8_t fp, const size_t local_size, const mxArray* options, const uint32_t scatter);

cl_int clGetPlatformsContext(const uint32_t device, const float kerroin, cl_context& context, size_t& size, int& cpu_device,
	cl_uint& num_devices_context, cl_device_id* devices, bool& atomic_64bit, cl_uchar& compute_norm_matrix, const uint32_t Nxyz, const uint32_t subsets, 
	const uint8_t raw);

cl_int clGetPlatformsContextSingle(const uint32_t device, cl_context& context, cl_uint& num_devices_context, cl_device_id* devices);

cl_int ClBuildProgramGetQueues(cl_program& program, const char* k_path, const cl_context context, const cl_uint num_devices_context, 
	const cl_device_id* devices, const bool verbose, cl_command_queue* commandQueues, bool& atomic_64bit, const uint32_t projector_type, const char* header_directory, 
	const float crystal_size_z, const bool precompute, const uint8_t raw, const uint32_t attenuation_correction, const uint32_t normalization_correction, 
	const int32_t dec, const uint8_t fp, const size_t local_size, const uint16_t n_rays, const uint16_t n_rays3D, const bool find_lors, const float dc_z, 
	const float dx, const bool use_psf, const uint32_t scatter, const uint32_t randoms_correction);

void reconstruction_multigpu(const size_t koko, const uint16_t* lor1, const float* z_det, const float* x, const float* y, const mxArray* Sin, 
	const mxArray* sc_ra, const uint32_t Nx, const uint32_t Ny, const uint32_t Nz, const uint32_t Niter, const mxArray* options, const float dx, 
	const float dy, const float dz, const float bx, const float by, const float bz, const float bzb, const float maxxx, const float maxyy, const float zmax, 
	const float NSlices, const uint32_t* pituus, const size_t koko_l, const uint32_t* xy_index, const uint16_t* z_index, const uint32_t size_x, 
	const uint16_t TotSinos, mxArray* cell, const bool verbose, const uint32_t randoms_correction, const uint32_t attenuation_correction, 
	const uint32_t normalization, const float* atten, const size_t size_atten, const float* norm, const size_t size_norm, const uint32_t subsets, 
	const float epps, const uint8_t* rekot, const char* k_path, const size_t size_rekot, const uint32_t Nt, const uint32_t* pseudos, 
	const uint32_t det_per_ring, const uint32_t prows, const uint16_t* L, const uint8_t raw, const size_t size_z, const bool osem_bool, const char* fileName, 
	const bool force_build, const uint32_t device, float kerroin, const size_t numel_x, const float tube_width, const float crystal_size_z, 
	const float* x_center, const float* y_center, const float* z_center, const size_t size_center_x, const size_t size_center_y, const size_t size_center_z, 
	const uint32_t projector_type, const char* header_directory, const bool precompute, const int32_t dec, const uint16_t n_rays, const uint16_t n_rays3D, const float cr_pz,
	const bool use_64bit_atomics, const float global_factor, const float bmin, const float bmax, const float Vmax, const float* V, const size_t size_V, 
	const size_t local_size, const float* gaussian, const size_t size_gauss);

void reconstruction_f_b_proj(const size_t koko, const uint16_t* lor1, const float* z_det, const float* x, const float* y, const float* rhs, const mxArray* sc_ra,
	const uint32_t Nx, const uint32_t Ny, const uint32_t Nz, const float dx, const float dy, const float dz, const float bx, const float by, const float bz,
	const float bzb, const float maxxx, const float maxyy, const float zmax, const float NSlices, const uint32_t* pituus, const size_t koko_l,
	const uint32_t* xy_index, const uint16_t* z_index, const uint32_t size_x, const uint16_t TotSinos, const bool verbose, const uint32_t randoms_correction,
	const uint32_t attenuation_correction, const uint32_t normalization, const float* atten, const size_t size_atten, const float* norm, const size_t size_norm,
	const char* k_path, const uint32_t* pseudos, const uint32_t det_per_ring, const uint32_t prows, const uint16_t* L, const uint8_t raw, const size_t size_z,
	const char* fileName, const uint32_t device, float kerroin, mxArray* output, const size_t size_rhs, const bool no_norm, const size_t numel_x,
	const float tube_width, const float crystal_size_z, const float* x_center, const float* y_center, const float* z_center, const size_t size_center_x,
	const size_t size_center_y, const size_t size_center_z, const uint32_t projector_type, const char* header_directory, const bool precompute,
	const int32_t dec, const uint16_t n_rays, const uint16_t n_rays3D, const float cr_pz, const mxArray* Sin, const bool use_64bit_atomics, const float global_factor, const float bmin,
	const float bmax, const float Vmax, const float* V, const size_t size_V, const size_t local_size, const bool use_psf, const mxArray* options);

void find_LORs(uint16_t* lor, const float* z_det, const float* x, const float* y, const uint32_t Nx, const uint32_t Ny,	const uint32_t Nz, const float dx, 
	const float dy, const float dz, const float bx, const float by, const float bz,	const float bzb, const float maxxx, const float maxyy, const float zmax, 
	const float NSlices, const uint32_t size_x, const uint16_t TotSinos, const bool verbose, const uint32_t loop_var_par, const char* k_path, 
	const uint32_t* pseudos, const uint32_t det_per_ring, const uint32_t prows, const uint16_t* L, const uint8_t raw, const size_t size_z, 
	const char* fileName, const uint32_t device, const size_t numel_x, const char* header_directory, const size_t local_size);