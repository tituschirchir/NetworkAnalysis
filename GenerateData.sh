# rm -rf csvfiles;
# mkdir csvfiles;
# ./build/FE_655Final $1 $2 $3 $4 $5 $6 $7 $8 $9 $10;

rm -rf build;
mkdir build;
cd build;
cmake ../;
make;
cd ../
rm -rf csvfiles;
mkdir csvfiles;
./build/NetworkAnalysis $1 $2 $3 $4 $5 $6 $7 $8 $9 $10;
