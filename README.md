# Network Analysis
The algorithms presented in this project is initially intended for analysing contagion effect within a financial system. The following is the procedure for the construction of a networ:
    
1. Initialize a matrix representing the interbank relationships: To be able to propagate contagion through the system, we would need to know whether bank A is exposed to bank B and so forth. The matrix creation utilizes an Erdos Renyi probability-type graph whereby the exposure between two banks is dependent on a given probability, p. The higher the probability, the more likely that the banks are coupled.
2. Construct a system of N banks: A bank is represented by a balance sheet containing 
    * Assets
        * External Assets
        * Interbank Loans (Lending)
    * Liabilities
        * Customer Deposits
        * Interbank Loans (Borrowing)
    * Capital (Equity / Royalties/ Accumulated profit and Loss)
    
    Each bank's balance sheet has to conform with the accounting identity of **Assets = Liabilities + Capital**. This means that overall, the entire network should satisfy this identy as well i.e. **Total Assets = Total Liabilities + Total Capital**. The total assets of the network is seleted by the user. The user can also select the proportion capital/asset ratio and ratio of interbank lending to external assets (theta). 
    