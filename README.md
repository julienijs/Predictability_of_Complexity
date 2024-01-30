# How predictable is linguistic complexity?

This research tries to answer following question:

Do changes in the morphological complexity of a language cause changes in the syntactic complexity of a language?

We test these hypotheses on C-CLAMP, a corpus of Dutch texts from 1837 till 1999 (Piersoul, De Troij & Van de Velde 2021). The corpus contains excerpts from cultural and literary magazines written in Belgium and The Netherlands.

Following Juola (2008) and Ehret (2017), we use Kolmogorov complexity (1968) to access morphological and syntactic complexity. For the calculation process and how the data sets were generated see [this repository](https://github.com/julienijs/Linguistic-complexity).

## Data sets & code
We analyze the data through Granger causality (Rosemeyer & Van de Velde 2021), a technique that aims to determine the causal precedence between two time series A and B. The R script applies this technique on the data sets generated from C-CLAMP.

## Results
![Morphology vs Syntax CCLAMP Time series](https://github.com/julienijs/Predictability_of_Complexity/assets/107923146/cf981857-c67d-404c-942d-f9116301b123)

## References
For more about information theory and Granger Causality:
- Ehret, K. 2017. *An information-theoretic approach to language complexity: variation in naturalistic corpora*. Freiburg: Albert-Ludwig-Universität Freiburg dissertation.
- Juola, P. 2008. Assessing linguistic complexity. In M. Miestamo, K. Sinnemäki & F. Karlsson (eds.), *Language complexity: typology, contact, change*, 89-108. Amsterdam: John Benjamins.
- Kolmogorov, A. Ni. 1968. Three approaches to the quantitative definition of information. *International Journal of Computer Mathematics 2*(1-4). 157-168. doi:10.1080/00207166808803030.
- Piersoul, J., De Troij, R. &  Van de Velde, F. 2021. 150 years of written Dutch: The construction of the Dutch Corpus of Contemporary and Late Modern Periodicals. *Nederlandse Taalkunde 26*(2). 171-194.
- Rosemeyer, M. & Van de Velde, F. 2021. On cause and correlation in language change. Word order and clefting in Brazilian Portuguese. *Language Dynamics and Change* 11(1). 130-166.

Own research output:
- Nijs, Julie; Van de Velde, Freek; Cuyckens, Hubert; 2023. Morphological complexity as cause and effect. [abstract](https://kuleuven.limo.libis.be/discovery/search?query=any,contains,LIRIAS4097986&tab=LIRIAS&search_scope=lirias_profile&vid=32KUL_KUL:Lirias&offset=0)
- Nijs, Julie; Van de Velde, Freek; Cuyckens, Hubert; 2023. A diachronic perspective on L2-speaker difficulty as a cause for changes in morphological complexity. [abstract](https://kuleuven.limo.libis.be/discovery/search?query=any,contains,LIRIAS4097989&tab=LIRIAS&search_scope=lirias_profile&vid=32KUL_KUL:Lirias&offset=0)
