//
// Created by tituskc on 4/14/17.
//

#ifndef FE_655FINAL_NETWORK_H
#define FE_655FINAL_NETWORK_H


static const char *const BankHeader = "bname,e,i,b,d,c,assets,liabilities,affected\n";

static const char *const COMMA = ",";

#include <vector>
#include "Bank.h"

class Network {
    int failures = 0, index=0;
    unsigned long N;
    double p, marketLoss = 0.0;
    double entropy=0;
    int links = 0;
    bool generatePlots = false;
    std::vector<std::vector<int>> inverseAdjacencyMatrix, prunedAdjacencyMatrix;
    std::vector<Bank> banks;

    void initializeAdjacencyMatrix();

    void initiateNetwork(double A, double theta, double gamma);

    std::vector<int> getExposureVector(std::vector<int> expVec, int pos);

public:
    Network(unsigned long N, double p, double A, double theta, double gamma, bool b);
    std::vector<Bank> getBanks();

    void simulateShock(int pos, double shock, bool isInitial);

    int getFailures();

    std::vector<std::vector<int>> getPrunedAdjacencyMatrix();

    void writeNetworkData();

    void writeMetaData(double initialShock);

    virtual ~Network();

    double getMarketLoss();

    double getEntropy();
};


#endif //FE_655FINAL_NETWORK_H
