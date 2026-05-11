#'The Modified Egger Intercept (MEI) Tests for Detecting Horizontal Pleiotropy in Mendelian Randomization
#'

#' @description The modified Egger intercept (MEI) tests are developed to detect horizontal pleiotropy in two-sample summary-data Mendelian randomization.
#'
#' @param g_hat A numeric vector of beta-coefficient values for genetic associations with the exposure variable.
#' @param gse The standard errors associated with the beta-coefficients \code{g_hat}.
#' @param G_hat A numeric vector of beta-coefficient values for genetic associations with the outcome variable.
#' @param Gse The standard errors associated with the beta-coefficients \code{G_hat}.
#' @param EAF.exp A numeric vector of effect allele frequency in the exposure sample.
#' @param EAF.out A numeric vector of effect allele frequency in the outcome sample.
#' @param Gse The standard errors associated with the beta-coefficients \code{G_hat}.
#' @param eta A parameter representing the standard deviation of the pseudo IV-exposure effect. By default, \code{eta=0.5}.
#' @param sel.pthr The significance level threshold for IV selection. By default, \code{sel.pthr=5e-5}.
#'
#' @details The modified Egger intercept (MEI) tests are developed to detect horizontal pleiotropy in two-sample Mendelian
#' randomization with summary statistics, i.e., an exposure dataset (with IV-exposure effect \code{g_hat} and standard error
#' \code{gse}) and an outcome dataset (with IV-outcome effect \code{G_hat} and standard error \code{Gse}).
#'
#' We recommend that the input datasets be pre-processed with filtering using the rerandomization threshold approach,
#' harmonisation, and clumping.  \code{eta} and \code{sel.pthr} should be consistent with the parameters used during pre-filtering.
#'
#' The MEI test under a specific allele coding scheme is constructed by deriving a bias-corrected Egger intercept estimator
#' along with its variance under the null hypothesis of absence of both directional and correlated pleiotropy, leveraging
#' the rerandomized inverse variance weighted (RIVW) estimator (see Ma et al., 2023). Under the null hypothesis, the test
#' statistic follows a asymptotic standard normal distribution.
#'
#' The MEI test statistic is computed under two allele coding schemes, along with a combined version:
#' (i) major allele referenced coding;
#' (ii) normal allele referenced coding, where the normal allele from the exposure GWAS is used as the reference; and
#' (iii) a combined version, which aggregates the two test statistics under the major and normal allele schemes using the
#' maximum Z-value approach.
#'
#' \code{EAF.exp} and \code{EAF.out} are used to recode the summary data into the major allele referenced coding scheme.
#' (1) If both \code{EAF.exp} and \code{EAF.out} > 0.5, the IV-exposure and IV-outcome effects are flipped.
#' (2) If one of \code{EAF.exp} and \code{EAF.out} is missing, the SNP is flipped if the available value > 0.5.
#' (3) In all other cases, the original allele coding is retained.
#'
#' @return The output from the function is a \code{MEITests} object containing:
#'
#'  \item{Zvalue_major}{Z-value from the MEI test under the major allele referenced coding scheme.}
#'  \item{Pvalue_major}{P-value associated with \code{Zvalue_major}.}
#'  \item{Zvalue_normal}{Z-value from the MEI test under the normal allele referenced coding scheme.}
#'  \item{Pvalue_normal}{P-value associated with \code{Zvalue_normal}.}
#'  \item{Pvalue_combine}{The P-value from the combined MEI test statistics obtained under major and normal allele referenced coding schemes.}
#'  \item{SNPsNum}{The number of SNPs after IV selection.}
#'  \item{sel.pthr}{The significance level threshold for IV selection.}
#'
#' @examples mr_MEITests(g_hat=b.exp, gse=se.exp, G_hat=b.out, Gse=se.out, EAF.exp=eaf.exp, EAF.out=eaf.out, eta=0.5, sel.pthr=5e-5)
#'
#' @export

mr_MEITests <- function(g_hat, gse, G_hat, Gse, EAF.exp, EAF.out, eta=0.5, sel.pthr=5e-5){

  MEITest_default <- function(g_hat, gse, G_hat, Gse, eta, sel.pthr){

    # g_hat_RB and ga_se_RB estimation
    C_sel <- qnorm(sel.pthr/2,lower.tail = FALSE)
    alpha1 <- (-C_sel - g_hat/gse) / eta
    alpha2 <- (C_sel - g_hat/gse) / eta
    g_hat_RB <- g_hat - (gse/eta) * ((dnorm(alpha2) - dnorm(alpha1)) / (pnorm(alpha1) + 1 - pnorm(alpha2)))
    g_var_RB <- (1 - ((alpha2*dnorm(alpha2) - alpha1*dnorm(alpha1)) / (1 - pnorm(alpha2) + pnorm(alpha1) ) - ((dnorm(alpha2) - dnorm(alpha1))/(1 - pnorm(alpha2) + pnorm(alpha1)))^2) / eta^2) * gse^2
    g_se_RB <- sqrt(g_var_RB)

    # RIVW estimate
    theta1_R <- sum(g_hat_RB * G_hat / Gse^2)
    theta2_R <- sum((g_hat_RB^2 - g_se_RB^2)/ Gse^2)
    beta_R <- theta1_R/theta2_R

    # MEI statistic
    Lambda_RC <- theta2_R * sum(g_hat_RB/Gse^2) - theta1_R * sum(g_hat_RB/Gse^2) + sum(G_hat*g_se_RB^2/Gse^4)

    # MEI variance
    Omega1 <- G_hat - beta_R*g_hat_RB
    Omega2 <- g_hat_RB*G_hat - beta_R*(g_hat_RB^2-g_se_RB^2)
    u_hat <- Omega1*theta2_R - Omega2*sum(g_hat_RB/Gse^2)
    u_hat_adj <- u_hat/Gse^2
    V_Lambda <- as.numeric(u_hat_adj%*%u_hat_adj)
    SE_Lambda <- sqrt(V_Lambda)

    # P value
    Z <- Lambda_RC / SE_Lambda
    P <- pnorm(abs(Z),lower.tail = F)*2

    result <- list(
      Zvalue = Z,
      Pvalue = P,
      u_hat_adj = u_hat_adj
    )

    return(result)
  }

  # IV selection
  C_sel <- qnorm(sel.pthr/2,lower.tail = FALSE)

  if (min(abs(g_hat/gse)) < C_sel - 5*eta) {
    warning("Input datasets may NOT have been pre-filtered using the rerandomization threshold approach. Auto-filtered applied. Please see documentation for proper data preparation.")
    set.seed(0)
    ind_filter <- abs(g_hat/gse + rnorm(length(g_hat), mean = 0, sd = eta)) > C_sel
    g_hat_sel <- g_hat[ind_filter]
    gse_sel <- gse[ind_filter]
    G_hat_sel <- G_hat[ind_filter]
    Gse_sel <- Gse[ind_filter]
    EAF.exp_sel <- EAF.exp[ind_filter]
    EAF.out_sel <- EAF.out[ind_filter]
  } else {
    g_hat_sel <- g_hat
    gse_sel <- gse
    G_hat_sel <- G_hat
    Gse_sel <- Gse
    EAF.exp_sel <- EAF.exp
    EAF.out_sel <- EAF.out
  }
  Num <- length(g_hat_sel)

  # MEI test under major allele referenced coding
  both_na <- is.na(EAF.exp_sel) & is.na(EAF.out_sel)
  e1 <- ifelse(is.na(EAF.exp_sel), EAF.out_sel, EAF.exp_sel)
  e2 <- ifelse(is.na(EAF.out_sel), EAF.exp_sel, EAF.out_sel)
  ind_flip <- !both_na & e1 > 0.5 & e2 > 0.5

  G_hat_major <- G_hat_sel
  g_hat_major <- g_hat_sel

  G_hat_major[ind_flip] <- -G_hat_major[ind_flip]
  g_hat_major[ind_flip] <- -g_hat_major[ind_flip]

  MEITest_major <- MEITest_default(g_hat=g_hat_major, gse=gse_sel, G_hat=G_hat_major, Gse=Gse_sel, eta=eta, sel.pthr=sel.pthr)
  Z_major <- MEITest_major$Zvalue
  P_major <- MEITest_major$Pvalue

  # MEI test under normal allele referenced coding
  G_hat_normal <- G_hat_sel * sign(g_hat_sel)
  g_hat_normal <- abs(g_hat_sel)

  MEITest_normal <- MEITest_default(g_hat=g_hat_normal, gse=gse_sel, G_hat=G_hat_normal, Gse=Gse_sel, eta=eta, sel.pthr=sel.pthr)
  Z_normal <- MEITest_normal$Zvalue
  P_normal <- MEITest_normal$Pvalue

  # combined MEI test
  max_absZ <- max(abs(Z_major), abs(Z_normal))
  rho12_hat <- sum(MEITest_major$u_hat_adj * MEITest_normal$u_hat_adj) / sqrt(sum(MEITest_major$u_hat_adj ^2) * sum(MEITest_normal$u_hat_adj ^2))
  rho_matrix <- matrix(c(1,rho12_hat,rho12_hat,1), 2, 2)

  P_combine <- 1 - mvtnorm::pmvnorm(upper = rep(max_absZ,2), lower = rep(-max_absZ,2), mean = rep(0, 2), corr = rho_matrix)
  P_combine <- as.numeric(P_combine)

  return(new("MEITests",
              Zvalue_major = Z_major,
              Pvalue_major = P_major,
              Zvalue_normal = Z_normal,
              Pvalue_normal = P_normal,
              Pvalue_combine = P_combine,
              SNPsNum = Num,
              sel.pthr = sel.pthr)
  )

}

