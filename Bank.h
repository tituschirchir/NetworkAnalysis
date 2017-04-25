#include <string>
//
// Created by tituskc on 4/14/17.
//

#ifndef FE_655FINAL_BANK_H
#define FE_655FINAL_BANK_H


class Bank {
public:


    Bank(const std::string &name);

    Bank();
    virtual ~Bank();

public:
    std::string name;
    double interbankAssets = 0,interbankBorrowing = 0, externalAssets = 0, capital = 0, customerDeposits = 0;
    int visits = 0;
    bool defaults, affected = false;

    double getAssets();

    double getLiabilities();

};

#endif //FE_655FINAL_BANK_H
