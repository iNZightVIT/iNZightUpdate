#' Update iNZightVIT
#' 
#' @param os one of 'windows', 'macos', or 'linux'
#' @return logical whether or not update was successful
#' @author Tom Elliott
#' @export
update <- function(os = c("windows", "macos", "linux")) {
    os <- match.arg(os)
    update_fun <- eval(parse(text = sprintf("update_%s", os)))
    res <- update_fun()
    if (!res) stop("There was a problem running the updater")
        
    cat("* iNZightVIT was updated successfully\n")
}

.update <- function(lib, type = "source") {
    cat(sprintf("* Updating packages in %s\n", lib))
    x <- try(utils::update.packages(
        lib.loc = lib, 
        repos = c(
            "https://r.docker.stat.auckland.ac.nz",
            "https://cloud.r-project.org"
        ),
        type = type,
        ask = FALSE
    ), silent = TRUE)
    !inherits(x, "try-error")
}

update_windows <- function() {
    .update(.libPaths()[1], type = "win.binary")
}

update_macos <- function() {
    .update("/Applications/iNZightVIT/.library")
        # and either type = "mac.binary.el-capitan")
        # or type = "mac.binary") ???
}

update_linux <- function() {
    .update(getwd())
}
