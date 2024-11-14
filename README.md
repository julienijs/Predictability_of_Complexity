# How predictable is linguistic complexity?

This research tries to answer following question:

Do changes in the morphological complexity of a language cause changes in the syntactic complexity of a language?

I test these hypotheses on several diachronic corpora: C-CLAMP, CLMET, DTA, COHA, Frantext and L'Unità corpus.

Following Juola (2008) and Ehret (2017), we use Kolmogorov complexity (1968) to access morphological and syntactic complexity (see also [this repository](https://github.com/julienijs/Linguistic-complexity)).

## Data sets & code
We analyze the data through Granger causality (Rosemeyer & Van de Velde 2021), a technique that aims to determine the causal precedence between two time series A and B. The R scripts apply this technique on the data sets. The data sets contain complexity calculations (Kolmogorov Complexity), derived from samples of different corpora. Both the data cleaning/sampling and the complexity calculations were done with Python scripts (see map 'Python_scripts'). 

## References
For more about information theory and Granger Causality:
- Ehret, K. 2017. *An information-theoretic approach to language complexity: variation in naturalistic corpora*. Freiburg: Albert-Ludwig-Universität Freiburg dissertation.
- Juola, P. 2008. Assessing linguistic complexity. In M. Miestamo, K. Sinnemäki & F. Karlsson (eds.), *Language complexity: typology, contact, change*, 89-108. Amsterdam: John Benjamins.
- Kolmogorov, A. Ni. 1968. Three approaches to the quantitative definition of information. *International Journal of Computer Mathematics 2*(1-4). 157-168. doi:10.1080/00207166808803030.
- Rosemeyer, M. & Van de Velde, F. 2021. On cause and correlation in language change. Word order and clefting in Brazilian Portuguese. *Language Dynamics and Change* 11(1). 130-166.
