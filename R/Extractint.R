#' @title Signal matching and alignment
#' @description  After inputting the average mass spectra information, this step
#'     enables automatically matching the intensities between the experimentally
#'     measured m/z and the targeted list with a tolerance of 5 ppm for each sample.
#'
#' @param Intensity The theoretical m/z value of labeled metabolites in the database.
#' @param Intensitys The experimentally detected m/z value of ions.
#' @param next_Intensitys The intensity corresponding to the experimentally detected m/z.
#' @param thr m/z error range.
#'
#' @return A table containing matched intensities with the targeted m/z.
#' @export
#'
#' @examples \donttest{
#' Extractint(70.21,70.12,1000,5*10^(-6))
#' }
Extractint <- function(Intensity, Intensitys, next_Intensitys, thr=5*10^(-6)){
  results <- abs((Intensitys-Intensity)/Intensity)
  potential_Intensitys <- next_Intensitys[results < thr]
  if(length(potential_Intensitys) == 0){
    return(NA)
  }
  return(max(potential_Intensitys))
}
