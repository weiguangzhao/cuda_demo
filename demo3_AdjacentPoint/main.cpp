#include <iostream>
#include <vector>
#include <string>
#include <fstream>
#include <cmath>
#include <map>
#include <algorithm>

#include "AdjacentPoint.h"
using namespace std;

float* read_pc(string filename, float xyz[]){
    ifstream fin;
    fin.open(filename);
    if(!fin) {
        cout << filename << " file could not be opened\n";
        exit(0);
    }
    int idx;
    float x, y, z;
    while(!fin.eof()) {
        fin >> idx >> x >> y >> z;
        xyz[idx*3 + 0] =x;
        xyz[idx*3 + 1] =y;
        xyz[idx*3 + 2] =z;
    }
    return xyz;
}

int main() {
    string inputFileName = "/home/bruno/Documents/Clion_Project/cuda_demo/demo3_AdjacentPoint/input/pc.txt";
    const int point_num = 82883;
    const float eps_v = 0.2;
    float xyz[point_num*3];

    read_pc(inputFileName, xyz);

    checkNearPoints(point_num, xyz, eps_v);

    return 0;
}