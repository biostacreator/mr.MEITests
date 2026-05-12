---
output: github_document
---

<!-- README.md is generated from README.Rmd. Please edit that file -->



# Modified Egger Intercept Tests for Mendelian Randomization

<!-- badges: start -->
[![R-CMD-check](https://github.com/biostacreator/mr.MEITests/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/biostacreator/mr.MEITests/actions/workflows/R-CMD-check.yaml)
[![Codecov test coverage](https://codecov.io/gh/biostacreator/mr.MEITests/graph/badge.svg)](https://app.codecov.io/gh/biostacreator/mr.MEITests)
<!-- badges: end -->

`mr.MEITests` is an R package for detecting horizontal pleiotropy in two-sample summary-data Mendelian randomization using the modified Egger intercept (MEI) tests. The MEI test is constructed based on a bias-corrected Egger intercept estimator under the null hypothesis of no directional or correlated pleiotropy, accounting for measurement error and winner’s curse. The test statistics are obtained under two allele coding schemes, along with a combined version.

## Installation

You can install the development version of mr.MEITests from [GitHub](https://github.com/) with:

``` r
library(devtools)
install_github("biostacreator/mr.MEITests") 
```

## Usage
```
mr_MEITests(
    g_hat,
    gse,
    G_hat,
    Gse,
    EAF.exp,
    EAF.out,
    eta,
    sel.pthr)
```
`g_hat`: A numeric vector of beta-coefficient values for genetic associations with the exposure variable.

`gse`: The standard errors associated with the beta-coefficients `g_hat`.

`G_hat`: A numeric vector of beta-coefficient values for genetic associations with the outcome variable.

`Gse`: The standard errors associated with the beta-coefficients `G_hat`.

`EAF.exp`: A numeric vector of effect allele frequency in the exposure sample.

`EAF.out`: A numeric vector of effect allele frequency in the outcome sample.

`eta`: A parameter representing the standard deviation of the pseudo IV-exposure effect. By default, `eta=0.5`. 

`sel.pthr`: The significance level threshold for IV selection. By default, `sel.pthr=5e-5`.

## Documentation

Full documentation website on: https://biostacreator.github.io/mr.MEITests

## Documentation

Full documentation website on: https://biostacreator.github.io/mr.MEITests

## Documentation

Full documentation website on: https://biostacreator.github.io/mr.MEITests

## Documentation

Full documentation website on: https://biostacreator.github.io/mr.MEITests

## Documentation

Full documentation website on: https://biostacreator.github.io/mr.MEITests

## Documentation

Full documentation website on: https://biostacreator.github.io/mr.MEITests

## Documentation

Full documentation website on: https://biostacreator.github.io/mr.MEITests

## Documentation

Full documentation website on: https://biostacreator.github.io/mr.MEITests

## Documentation

Full documentation website on: https://biostacreator.github.io/mr.MEITests

## Documentation

Full documentation website on: https://biostacreator.github.io/mr.MEITests

## Documentation

Full documentation website on: https://biostacreator.github.io/mr.MEITests

## Example

This is a basic example which shows you how to solve a common problem:


``` r
library(mr.MEITests) # load the mr.MEITests package 
data(Meta_T2D) # load the real analysis data 
# analyze the example data with the MEI tests 
mr_MEITests(
    g_hat = Meta_T2D$b.exp, 
    gse = Meta_T2D$se.exp, 
    G_hat = Meta_T2D$b.out, 
    Gse = Meta_T2D$se.out, 
    EAF.exp = Meta_T2D$eaf.exp, 
    EAF.out = Meta_T2D$eaf.out, 
    eta = 0.5, 
    sel.pthr = 5e-5) 
#> Modified Egger intercept tests
#> 
#> IV selection threshold: 5e-05 
#> Number of variants : 343 
#> Null hypothesis: absence of both directional and correlated pleiotropy
#> ------------------------------------------------------------------
#>                           Method Z_value  P_value
#>   Major-allele-referenced coding  -0.093    0.926
#>  Normal-allele-referenced coding   3.922 8.78e-05
#>      Maximum Z-value combination         1.76e-04
#> ------------------------------------------------------------------
```

