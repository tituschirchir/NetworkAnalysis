# Network Analysis
#### By Titus Chirchir and Dhanoosha Penmetsa
The algorithms presented in this project were initially intended for analysing contagion effect within a financial system. The following is the procedure for the construction of a network:
    
1. **Initialize a matrix representing the interbank relationships**: To be able to propagate contagion through the system, we would need to know whether bank A is exposed to bank B and so forth. The matrix creation utilizes an Erdos Renyi probability-type graph whereby the exposure between two banks is dependent on a given probability, p. The higher the probability, the more likely that the banks are coupled.
2. **Construct a system of N banks**: A bank is represented by a balance sheet containing 
    * Assets
        * External Assets
        * Interbank Loans (Lending)
    * Liabilities
        * Customer Deposits
        * Interbank Loans (Borrowing)
    * Capital (Equity / Royalties/ Accumulated profit and Loss)
    
    Each bank's balance sheet has to conform with the accounting identity of **Assets = Liabilities + Capital**. This means that overall, the entire network should satisfy this identy as well i.e. **Total Assets = Total Liabilities + Total Capital**. The total assets of the network is seleted by the user. The user can also select the proportion capital/asset ratio (**Gamma**) and ratio of interbank lending to external assets (**Theta**).
3. **Trigger a Shock**: After the network has been initialized with banking institutions, each with a specified balance sheet defining its capitalization and exposure to other banks in the network, we then trigger a credit event. This event takes the form of a wipe-out of one of the banks' **external assets**. We then track the reverberation of the credit event throughout the system. A bank is deemed to have defaulted when the shock it feels is of a greater magnitude than its capital. i.e.
    * if shock > capital, bank defaults
    * In terms of the impact of the shock on the bank's stakeholders, capital will be eaten away first, followed by a default on interbank loans (up to the residual shock from capital cushion) and finally a failure to reimburse customer deposits (up to the residual shock from interbank loans).
    * if the shock is not absorbed fully by the banks's capital, the shock is transmitted equally to the lending banks and the process begins again.
    * the reverberation ends when it has been fully absorbed by the system or all the linked institutions have defaulted.
4. **Report the results**: We use **R** to generate graphs simulating the transmission of the shock in the system. In addition, we plot graphs to analyse the impact of toggling the inputs of the system such as *interbank assets to asset ratio*, *capital to asset ratio, gamma*, *Number of Banks, N* and *Interconnectivity (Erdos Renyi Probability), p*.

#### Example: Shock Reverberation in a 5-Bank Network (p=50%, gamma=5%, theta=20%)

<img src="https://cloud.githubusercontent.com/assets/7333584/25133616/2c9197b4-241b-11e7-9af8-5ed80699c33d.png" alt="Network Before Shock" width=300 height=300/>
<img src="https://cloud.githubusercontent.com/assets/7333584/25133627/38c6eb1a-241b-11e7-86c9-803de62f1d72.png" alt="Shock Stage 1"  width=300 height=300/>
<img src="https://cloud.githubusercontent.com/assets/7333584/25133642/412a8e88-241b-11e7-946a-d7cc8dc7f305.png" alt="Shock Stage 2"  width=300 height=300/>
<img src="https://cloud.githubusercontent.com/assets/7333584/25133651/496a3df0-241b-11e7-90a4-0be50d2ea567.png" alt="Final Stage of Schock"  width=300 height=300/>
