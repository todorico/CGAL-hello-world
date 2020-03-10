// CGAL
#include <CGAL/Simple_cartesian.h>
#include <CGAL/Surface_mesh.h>
#include <CGAL/draw_surface_mesh.h>

// STD
#include <algorithm>
#include <fstream>
#include <string>

// Typedefs
using Kernel = CGAL::Simple_cartesian<double>;
using Point  = Kernel::Point_3;
using Mesh   = CGAL::Surface_mesh<Point>;

Mesh read_from(std::string filename)
{
	Mesh mesh;
	std::ifstream input_file(filename);

	if(!input_file.is_open())
	{
		exit(EXIT_FAILURE);
	}

	// Reading file depending on file extension

	std::transform(filename.begin(), filename.end(), filename.begin(), ::tolower);

	if(filename.find_last_of(".ply") != std::string::npos)
	{
		read_ply(input_file, mesh);
	}
	else if(filename.find_last_of(".off") != std::string::npos)
	{
		read_off(input_file, mesh);
	}
	else
	{
		std::cerr << "Error : file type is not supported\n";
		exit(EXIT_FAILURE);
	}

	if(mesh.is_empty())
	{
		std::cerr << "Error : after reading file, mesh is empty\n";
		exit(EXIT_FAILURE);
	}

	return mesh;
}

int main(int argc, char* argv[])
{
	std::string filename;

	if(argc < 2)
	{
		std::cerr << "Usage : " << argv[0] << " <MESH_FILE.(PLY|OFF)>\n";
		std::cerr << "Default MESH_FILE is set to ../data/hello-world.ply\n";
		filename = "../data/hello-world.ply";
	}
	else
	{
		filename = argv[1];
	}

	std::cerr << "Reading mesh from (" << filename << ")...\n";
	Mesh mesh = read_from(filename);

	CGAL::draw(mesh);

	return EXIT_SUCCESS;
}
