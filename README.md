# CGAL hello world

## Description

This program can visualize a 3D mesh by reading a PLY or an OFF file (`./hello MESH_FILE`). If `MESH_FILE` is not given, the program will visualize a 3D Hello World mesh.

## Clone, Build, Execute

```bash
# Clone directory
git clone https://github.com/todorico/CGAL-hello-world.git
# Create build directory
cd CGAL-hello-world && mkdir build && cd build
# Configure cmake
cmake .. -DCMAKE_BUILD_TYPE=DebugFast
# Compile
make
# Execute
./hello
```
