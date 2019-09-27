`%notin%` <- function(x, y) !x %in% y

gh_url <- function(pkg)
    sprintf(
        "https://github.com/iNZightVIT/%s/releases/latest/download",
        pkg
    )