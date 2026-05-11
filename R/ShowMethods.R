setMethod("show",
          "MEITests",
          function(object){

            Method <- c(
              "Major-allele-referenced coding",
              "Normal-allele-referenced coding",
              "Maximum Z-value combination"
            )

            format_p <- function(p) {
              if (is.na(p)) return(NA)
              if (p >= 1e-3) {
                return(format(round(p, 3), nsmall = 3))
              } else {
                return(format(p, scientific = TRUE, digits = 3))
              }
            }

            Z_value <- c(
              sprintf("%.3f", object@Zvalue_major),
              sprintf("%.3f", object@Zvalue_normal),
              " "
            )

            P_value <- c(
              format_p(object@Pvalue_major),
              format_p(object@Pvalue_normal),
              format_p(object@Pvalue_combine)
            )

            # Final table
            output.table <- data.frame(
              Method = Method,
              Z_value = Z_value,
              P_value = P_value,
              stringsAsFactors = FALSE
            )

            cat("Modified Egger intercept tests\n\n")

            cat("IV selection threshold:", object@sel.pthr, "\n")
            cat("Number of variants :", object@SNPsNum, "\n")

            cat("Null hypothesis: absence of both directional and correlated pleiotropy\n")

            cat("------------------------------------------------------------------\n")
            print(output.table, quote = F, row.names = FALSE, justify= "left")
            cat("------------------------------------------------------------------\n")

          }
)
