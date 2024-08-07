# How predictable is linguistic complexity?

This research tries to answer following question:

Do changes in the morphological complexity of a language cause changes in the syntactic complexity of a language?

I test these hypotheses on several diachronic corpora: C-CLAMP, CLMET, DTA, COHA, Frantext and L'Unità corpus.

Following Juola (2008) and Ehret (2017), we use Kolmogorov complexity (1968) to access morphological and syntactic complexity. For the calculation process and how the data sets were generated see [this repository](https://github.com/julienijs/Linguistic-complexity).

## Data sets & code
We analyze the data through Granger causality (Rosemeyer & Van de Velde 2021), a technique that aims to determine the causal precedence between two time series A and B. The R script applies this technique on the data sets.

## Results
![Morphology vs Syntax CCLAMP Time series](https://github.com/julienijs/Predictability_of_Complexity/blob/main/Plots/morphology_word_order_time_series.png)

## References
For more about information theory and Granger Causality:
- Ehret, K. 2017. *An information-theoretic approach to language complexity: variation in naturalistic corpora*. Freiburg: Albert-Ludwig-Universität Freiburg dissertation.
- Juola, P. 2008. Assessing linguistic complexity. In M. Miestamo, K. Sinnemäki & F. Karlsson (eds.), *Language complexity: typology, contact, change*, 89-108. Amsterdam: John Benjamins.
- Kolmogorov, A. Ni. 1968. Three approaches to the quantitative definition of information. *International Journal of Computer Mathematics 2*(1-4). 157-168. doi:10.1080/00207166808803030.
- Rosemeyer, M. & Van de Velde, F. 2021. On cause and correlation in language change. Word order and clefting in Brazilian Portuguese. *Language Dynamics and Change* 11(1). 130-166.
