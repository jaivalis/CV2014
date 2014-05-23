#include <iostream>
#include <pcl/io/pcd_io.h>
#include <pcl/io/ply_io.h>
#include <pcl/point_types.h>

int main (int argc, char** argv) {
    pcl::PointCloud<pcl::PointXYZ>::Ptr cloud (new pcl::PointCloud<pcl::PointXYZ>);

    if (pcl::io::loadPCDFile<pcl::PointXYZ> ("model.pcd", *cloud) == -1) {
        PCL_ERROR ("Couldn't read file model.pcd\n");
        return (-1);
    }
    std::cout << "Loaded " << cloud->width * cloud->height
              << " data points from the pcd file" << std::endl;

//    for (size_t i = 0; i < cloud->points.size (); ++i) {
//        std::cout << "    " << cloud->points[i].x
//            << " "    << cloud->points[i].y
//            << " "    << cloud->points[i].z << std::endl;
//    }

    pcl::io::savePLYFileASCII("model.ply", *cloud);
    return (0);
}
