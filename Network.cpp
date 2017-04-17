//
// Created by tituskc on 4/14/17.
//

#include "Network.h"
#include <random>
#include <iostream>
#include <algorithm>
#include <boost/foreach.hpp>
#include <fstream>

#define foreach         BOOST_FOREACH

Network::Network(unsigned long N, double p, double A, double theta, double gamma, bool generatePlots)
        : N(N), p(p), generatePlots(generatePlots) {
    initializeAdjacencyMatrix();
    initiateNetwork(A, theta, gamma);
}

Network::~Network() {};

void Network::initializeAdjacencyMatrix() {
    std::default_random_engine generator;
    generator.seed((unsigned long) rand());
    std::uniform_real_distribution<double> distribution(0.0, 1.0);
    inverseAdjacencyMatrix.resize(N, std::vector<int>(N, 0));
    prunedAdjacencyMatrix.resize(N, std::vector<int>(N, 0));
    for (int i = 0; i < N; ++i)
        for (int j = 0; j < N; ++j)
            if (i != j && distribution(generator) > p)
                inverseAdjacencyMatrix[i][j] = 1;
    int v = 0;
    for (int i = 0; i < N; ++i) {
        for (int j = 0; j < N; ++j) {
            v = inverseAdjacencyMatrix[i][j] * (1 - inverseAdjacencyMatrix[j][i]);
            if (v == 1) {
                prunedAdjacencyMatrix[i][j] = v;
                links += 1;
            }
        }
    }
    for (int i = 0; i < N; ++i) {
        for (int j = 0; j < N; ++j) {
            inverseAdjacencyMatrix[i][j] = prunedAdjacencyMatrix[j][i];
        }
    }
}

void Network::initiateNetwork(double A, double theta, double gamma) {
    double e_bk = links == 0 ? 0 : theta * A / links;
    std::string prefix = "B";
    banks = std::vector<Bank>(N);
    for (int i = 0; i < N; ++i) {
        Bank bank = Bank(prefix + std::to_string(i));
        bank.interbankBorrowing =
                accumulate(prunedAdjacencyMatrix[i].begin(), prunedAdjacencyMatrix[i].end(), 0) * e_bk;
        bank.interbankAssets = accumulate(inverseAdjacencyMatrix[i].begin(), inverseAdjacencyMatrix[i].end(), 0) * e_bk;
        double excessAssets = A / N - bank.interbankAssets;
        bank.externalAssets = excessAssets >= 0 ? excessAssets : 0;
        bank.capital = (bank.interbankAssets + bank.externalAssets) * gamma;
        bank.customerDeposits = bank.externalAssets + bank.interbankAssets - bank.capital - bank.interbankBorrowing;
        banks[i] = bank;
    }
}

std::vector<Bank> Network::getBanks() {
    return banks;
}

static double min(const double a, const double b) {
    return a <= b ? a : b;
}

static double max(const double a, const double b) {
    return a >= b ? a : b;
}

void Network::simulateShock(int pos, double shock, bool isInitial) {
    Bank shockedBank = banks[pos];
    if (isInitial)
        banks[pos].externalAssets -= shock;
    else if (shockedBank.capital > 0)
        banks[pos].interbankAssets -= shock;
    banks[pos].affected = true;
    double capitalShock = shockedBank.capital - shock;
    banks[pos].capital = max(shockedBank.capital - shock, 0);
    banks[pos].Loss = shockedBank.Loss + shock;
    totalLoss += shockedBank.Loss;
    banks[pos].visits = shockedBank.visits + 1;
    if (capitalShock < 0) {
        banks[pos].defaults = true;
        failures += 1;
        if (shockedBank.capital > 0) {
            double interbankLiabShock = shockedBank.interbankBorrowing + capitalShock;
            banks[pos].interbankBorrowing = max(interbankLiabShock, 0);
            if (interbankLiabShock < 0) {
                banks[pos].customerDeposits = max(interbankLiabShock + shockedBank.customerDeposits, 0);
            }
        }
        if (generatePlots) writeNetworkData();
        std::vector<int> expVec = getExposureVector(prunedAdjacencyMatrix[pos], pos);
        int k = (int) expVec.size();
        double toTransmit = min(shock - shockedBank.capital, shockedBank.interbankBorrowing);
        if (toTransmit > 0 && k>0) {
                        foreach (int expPos, expVec) {
                                simulateShock(expPos, toTransmit / k, false);
                        }
        }
    }
}


std::vector<int> Network::getExposureVector(std::vector<int> expVec, int pos) {
    std::vector<int> positions;
    for (int i = 0; i < N; ++i) {
        if (i != pos && expVec[i] != 0 && !banks[i].defaults) {
            positions.push_back(i);
        }
    }
    return positions;
}

std::vector<std::vector<int>> Network::getPrunedAdjacencyMatrix() {
    return prunedAdjacencyMatrix;
}

double Network::getNetLoss() {
    return totalLoss;
}

int Network::getFailures() {
    return failures;
}

void Network::writeNetworkData() {
    std::ofstream myfile;
    myfile.open("csvfiles/bankData" + std::to_string(index++) + ".csv");
    myfile << BankHeader;
    std::vector<Bank> banks = getBanks();
    for (int i = 0; i < N; ++i) {
        Bank b = banks[i];
        myfile << b.name << COMMA << b.externalAssets << COMMA
               << b.interbankAssets << COMMA << b.interbankBorrowing << COMMA
               << b.customerDeposits << COMMA << b.capital << COMMA << b.getAssets()
               << COMMA << b.getLiabilities() << COMMA << (b.affected ? 'Y' : 'N') << "\n";
    }
    myfile.close();
}

void Network::writeMetaData(double initialShock) {
    std::ofstream myfile;
    myfile.open("csvfiles/metaData.csv");
    myfile << "index,shock\n";
    myfile << index << COMMA << initialShock << "\n";
    myfile.close();
}


