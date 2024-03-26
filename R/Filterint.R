#' @title Selection of ions with potential labeling signals
#' @description Compare the average ion intensities of M2 and M3 isotopologue
#'     between labeled and unlabeled groups by ratio analysis.
#'
#' @param df The updated table generated after running Scanint.
#' @param Intensity The minimum intensity ratio indicating isotopic enrichment.
#'
#' @return A table of potential labeled metabolites.
#' @export
#'
#' @examples Filterint(Target1, Intensity=10)
Filterint <- function(df, Intensity=10){
  new_df <- df[, 1:6]
  for(col in c("Unlabel_01", "Unlabel_02", "Unlabel_03", "Glc_Label_01", "Glc_Label_02", "Glc_Label_03")){
    Intensitys <- unlist(df[, col])
    new_df[, col] <- ifelse(Intensitys == 0, 1, Intensitys)
  }

  remove_ids2 <- NULL
  remove_ids3 <- NULL

  select_df <- new_df[new_df$IsotopeLabel == "C13-label-2",]
  for(row in 1:nrow(select_df)){
    sum_Intensity1 <- sum(unlist(select_df[row, c("Glc_Label_01", "Glc_Label_02", "Glc_Label_03")]))
    sum_Intensity2 <- sum(unlist(select_df[row, c("Unlabel_01", "Unlabel_02", "Unlabel_03")]))
    if(unlist(select_df[row, "ID"]) == 2){
      print(sum_Intensity1)
      print(sum_Intensity2)
      print(sum_Intensity1/sum_Intensity2)
    }
    if(sum_Intensity1/sum_Intensity2 < Intensity){
      remove_ids2 <- c(remove_ids2, unlist(select_df[row, "ID"]))
    }
  }

  select_df <- new_df[new_df$IsotopeLabel == "C13-label-3",]
  for(row in 1:nrow(select_df)){
    sum_Intensity1 <- sum(unlist(select_df[row, c("Glc_Label_01", "Glc_Label_02", "Glc_Label_03")]))
    sum_Intensity2 <- sum(unlist(select_df[row, c("Unlabel_01", "Unlabel_02", "Unlabel_03")]))
    if(sum_Intensity1/sum_Intensity2 < Intensity){
      remove_ids3 <- c(remove_ids3, unlist(select_df[row, "ID"]))
    }
  }

  remove_ids <- NULL
  for(id in remove_ids2){
    if(id %in% remove_ids3){
      remove_ids <- c(remove_ids, id)
    }
  }
  print(remove_ids)
  remain_df <- df[(df$ID %in% remove_ids) == F,]
  return(remain_df)
}
