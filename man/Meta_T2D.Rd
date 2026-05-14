\name{Meta_T2D}
\alias{Meta_T2D}
\docType{data}
\title{
Example dataset for genetic association meta-analysis of a metabolic trait (free cholesterol to total lipids ratio in large high-density lipoprotein) and type 2 diabetes
}
\description{
This dataset is an example data frame containing the variables needed for the modified Egger tests in two-sample Mendelian randomization. It has been pre-processed with filtering using the rerandomization threshold approach (\code{eta=0.5} and \code{sel.pthr=5e-5}), followed by harmonisation and clumping. The dataset is intended to demonstrate the workflow of functions in this package (e.g., \code{\link{mr_MEITests}}), and users can may it as a template to prepare their own data.
}
\format{
A data frame with rows corresponding to genetic variants (e.g., SNPs) and the following 6 numeric variables:
\describe{
  \item{\code{SNP}}{The rs identifier of the single nucleotide polymorphism.}
  \item{\code{A1}}{Character vector specifying the effect allele for each SNP. All reported effect estimates (\code{b.exp} and \code{b.out}) are defined with respect to this allele.}
  \item{\code{A2}}{Character vector specifying the other allele for each SNP.}
  \item{\code{b.exp}}{Numeric vector of beta coefficients for genetic associations with the exposure variable. Corresponds to the parameter \code{g_hat}.}
  \item{\code{se.exp}}{Standard errors of \code{b.exp}. Corresponds to the parameter \code{gse}.}
  \item{\code{b.out}}{Numeric vector of beta coefficients for genetic associations with the outcome variable. Corresponds to the parameter \code{G_hat}.}
  \item{\code{se.out}}{Standard errors of \code{b.out}. Corresponds to the parameter \code{Gse}.}
  \item{\code{eaf.exp}}{Effect allele frequency in the exposure sample. Corresponds to the parameter \code{EAF.exp}.}
  \item{\code{eaf.out}}{Effect allele frequency in the outcome sample. Corresponds to the parameter \code{EAF.out}.}
}
}
\details{
All variables have the same length (i.e., number of selected genetic variants). When using analysis functions from this package, users can directly pass the columns of this data frame to the respective arguments.

Note that the exposure trait is the free cholesterol to total lipids ratio in large high-density lipoprotein, and the outcome is type 2 diabetes.
}
\source{
The metabolic trait (free cholesterol to total lipids ratio in large HDL) was obtained from the UK Biobank.
See: Richardson TG, Leyden GM, Wang Q, et al. (2022). Characterising metabolomic signatures of lipid-modifying therapies through drug target Mendelian  randomisation. *PLoS Biology*, 20(2):e3001547.
The type 2 diabetes dataset was obtained from the FinnGen study.
See: Kurki MI, Karjalainen J, Palta P, et al. (2023). FinnGen provides genetic insights from a well-phenotyped isolated population. *Nature*, 613:508–518.
}
\examples{
# View the first few rows
head(Meta_T2D)

# Example usage with a hypothetical mr_analysis() function
\dontrun{
mr_MEITests(g_hat = Meta_T2D$b.exp,
            gse = Meta_T2D$se.exp,
            G_hat = Meta_T2D$b.out,
            Gse = Meta_T2D$se.out,
            EAF.exp = Meta_T2D$eaf.exp,
            EAF.out = Meta_T2D$eaf.out,
            eta=0.5,
            sel.pthr=5e-5)
}
}
\keyword{datasets}
