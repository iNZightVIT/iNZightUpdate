#' Update iNZightVIT
#'
#' @param os one of 'windows', 'macos', or 'linux'
#' @return logical whether or not update was successful
#' @author Tom Elliott
#' @export
update <- function(os = c("windows", "macos", "linux")) {
    os <- match.arg(os)

    if (package_version("iNZight") < numeric_version("4.0.0")) {
        msg <- c(
            "The latest version, iNZight 4.0, contains some bigger changes",
            "than usual. It also has some updated dependencies, so please",
            "head to our website and download the latest installer.",
            "",
            "  https://inzight.nz/getinzight"
        )
        if (requireNamespace("tcltk", quietly = TRUE)) {
            tcltk::tk_messagebox("ok",
                message = paste(msg, collapse = "\n"),
                caption = "New Major Release Available"
            )
        } else {
            cat(sep = "", paste0(" * ", msg, "\n"))
        }
        return()
    }

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
