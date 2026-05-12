\name{Meta_T2D}
\alias{Meta_T2D}
\docType{data}
\title{
Example dataset for genetic association meta-analysis of type 2 diabetes (T2D)
}
\description{
This dataset is an example data frame containing variables needed for two-sample Mendelian randomization or genetic association meta-analysis. It is intended to demonstrate the workflow of functions in this package (e.g., \code{\link{mr_MEITests}}), and users can use it as a template to prepare their own data.
}
\format{
A data frame with rows corresponding to genetic variants (e.g., SNPs) and the following 6 numeric variables:
\describe{
  \item{\code{SNP}}{SNP}
  \item{\code{A1}}{A1}
  \item{\code{A2}}{A2}
  \item{\code{b.exp}}{Numeric vector of beta coefficients for genetic associations with the exposure variable. Corresponds to the parameter \code{g_hat}.}
  \item{\code{se.exp}}{Standard errors of \code{b.exp}. Corresponds to the parameter \code{gse}.}
  \item{\code{b.out}}{Numeric vector of beta coefficients for genetic associations with the outcome variable. Corresponds to the parameter \code{G_hat}.}
  \item{\code{se.out}}{Standard errors of \code{b.out}. Corresponds to the parameter \code{Gse}.}
  \item{\code{eaf.exp}}{Effect allele frequency in the exposure sample. Corresponds to the parameter \code{EAF.exp}.}
  \item{\code{eaf.out}}{Effect allele frequency in the outcome sample. Corresponds to the parameter \code{EAF.out}.}
}
}
\details{
This dataset is simulated and does not reflect real genetic association results. All variables are numeric vectors of the same length (i.e., number of genetic variants). When using analysis functions from this package, users can directly pass the columns of this data frame to the respective arguments.
}
\source{
Simulated data, for illustrative and testing purposes only.
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
