#' S4 class for MEI tests results
#'
#' @slot Zvalue_major Numeric
#' @slot Pvalue_major Numeric
#' @slot Zvalue_normal Numeric
#' @slot Pvalue_normal Numeric
#' @slot Pvalue_combine Numeric
#' @slot SNPsNum Numeric
#' @slot sel.pthr Numeric
#'
#' @export
setClass(
  "MEITests",
  slots = list(
    Zvalue_major = "numeric",
    Pvalue_major = "numeric",
    Zvalue_normal = "numeric",
    Pvalue_normal = "numeric",
    Pvalue_combine = "numeric",
    SNPsNum = "numeric",
    sel.pthr = "numeric"
  )
)
