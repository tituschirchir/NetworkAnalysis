#include <iostream>
#include <vector>
#include <random>
#include <fstream>
#include "Bank.h"
#include "Network.h"
#include <ctime>
#include <string.h>
#include <zconf.h>

void analyseData(unsigned long N, double prob, double assets, double gamma, double theta, double failFactor, char analysisType, int M);

void writeAdjacencyMatrix(unsigned long N, double prob, double assets, double gamma, double theta, double failFactor);

void writeAdjMat(Network network, int N);

using namespace std;

int main(int argc, char *argv[]) {
    std::string loc="../NetworkAnalysis/";
    chdir(loc.c_str());
    srand((unsigned int) time(NULL));
    char *type = argv[1];
    double prob, gamma, theta, assets, failFactor;
    int N, M = 0;
    if (strcmp(type, "Analysis") == 0) {
        prob = atof(argv[2]);
        gamma = atof(argv[3]);
        theta = atof(argv[4]);
        assets = atof(argv[5]);
        failFactor = atof(argv[6]);
        N = atoi(argv[7]);
        char analysisType = argv[8][0];
        M = atoi(argv[9]);
        clock_t tStart = clock();
        analyseData(N, prob, assets, gamma, theta, failFactor, analysisType, M);
        printf("Time taken: %.2fs\n", (double)(clock() - tStart)/CLOCKS_PER_SEC);
    } else {
        prob = atof(argv[2]);
        gamma = atof(argv[3]);
        theta = atof(argv[4]);
        assets = atof(argv[5]);
        failFactor = atof(argv[6]);
        N = atoi(argv[7]);
        writeAdjacencyMatrix(N, prob, assets, gamma, theta, failFactor);
    }
    return 0;
}

void writeAdjacencyMatrix(unsigned long N, double prob, double assets, double gamma, double theta, double failFactor) {
    Network network(N, prob, assets, theta, gamma, true);
    std::cout<<network.getEntropy()<<std::endl;
    writeAdjMat(network, N);
    network.writeNetworkData();
    Bank b = network.getBanks()[0];
    network.simulateShock(0, b.externalAssets * failFactor, true);
    std::cout << "Shock: " << b.externalAssets * failFactor << "; Dead: " << network.getFailures() << std::endl;
    network.writeMetaData(b.externalAssets * failFactor);
}

void analyseData(unsigned long N, double prob, double assets, double gamma, double theta, double failFactor, char analysisType,
                 int M) {
    std::ofstream myfile;
    std::string name("mcfiles/mcSimulation");
    name.push_back(analysisType);
    name.append(".csv");
    myfile.open(name);
    myfile << "Value,Defaults,MarketLoss,Entropy\n";
    double fails, marketLoss, entropy;
    int iterations=1000;
    switch (analysisType) {
        case 'T': {
            double dtheta = 0.5 / iterations;
            for (int i = 0; i < iterations; ++i) {
                theta = dtheta * i;
                fails = 0.0;
                entropy=0.0;
                marketLoss = 0.0;
                for (int j = 0; j < M; j++) {
                    Network network(N, prob, assets, theta, gamma, false);
                    network.simulateShock(0, network.getBanks()[0].externalAssets * failFactor, true);
                    fails += network.getFailures();
                    marketLoss += network.getMarketLoss();
                    entropy+=network.getEntropy();
                }
                myfile << theta << "," << fails / M << "," << marketLoss / M<< "," << entropy / M << "\n";
            }
            break;
        }
        case 'G': {
            double dgamma = 0.1 / iterations;
            for (int i = 0; i < iterations; ++i) {
                gamma = dgamma * i;
                entropy=0;
                fails = 0;
                marketLoss = 0.0;
                for (int j = 0; j < M; j++) {
                    Network network(N, prob, assets, theta, gamma, false);
                    network.simulateShock(0, network.getBanks()[0].externalAssets * failFactor, true);
                    fails += network.getFailures();
                    marketLoss+= network.getMarketLoss();
                    entropy+=network.getEntropy();
                }
                myfile << gamma << "," << fails / M<< "," << marketLoss / M <<"," << entropy / M <<  "\n";
            }
            break;
        }
        case 'P': {
            double dprob = 0.5 / iterations;
            for (int i = iterations; i--;) {
                prob = dprob * i;
                entropy=0.0;
                fails = 0.0;
                marketLoss = 0.0;
                for (int j = M; j--;) {
                    Network network(N, prob, assets, theta, gamma, false);
                    network.simulateShock(0, network.getBanks()[0].externalAssets * failFactor, true);
                    fails += network.getFailures();
                    marketLoss+= network.getMarketLoss();
                    entropy+=network.getEntropy();
                }
                myfile << prob << "," << fails / M << "," << marketLoss / M <<"," << entropy / M <<  "\n";
            }
            break;
        }
        default: {
            for (int i = 1; i <= N; ++i) {
                entropy=0.0;
                fails = 0;
                marketLoss = 0.0;
                for (int j = 0; j < M; j++) {
                    Network network(i, prob, assets, theta, gamma, false);
                    Bank b = network.getBanks()[0];
                    network.simulateShock(0, b.externalAssets * failFactor, true);
                    fails += network.getFailures();
                    marketLoss += network.getMarketLoss();
                    entropy+=network.getEntropy();
                }
                myfile << i << "," << fails / M<< "," << marketLoss / M <<"," << entropy / M <<  "\n";
            }
            break;
        }
    }
    myfile.close();
}

void writeAdjMat(Network network, int N) {
    std::ofstream myfile;
    myfile.open("csvfiles/adjMat.csv");
    std::vector<Bank> banks = network.getBanks();
    for (int i = 0; i < N - 1; ++i) {
        myfile << banks[i].name << ",";
    }
    myfile << banks[N - 1].name << "\n";
    std::vector<std::vector<int>> adj = network.getPrunedAdjacencyMatrix();
    for (int i = 0; i < N; ++i) {
        for (int j = 0; j < N - 1; ++j) {
            myfile << adj[i][j] << ",";
        }
        myfile << adj[i][N - 1] << "\n";
    }
    myfile.close();
}


