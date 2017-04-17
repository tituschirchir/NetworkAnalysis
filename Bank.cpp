//
// Created by tituskc on 4/14/17.
//

#include <iostream>
#include "Bank.h"

Bank::Bank(const std::string &name) : name(name) {}
Bank::Bank() {}

Bank::~Bank() {

}

double Bank::getAssets() {
    return interbankAssets + externalAssets;
}

double Bank::getLiabilities() {
    return customerDeposits + interbankBorrowing;
}



