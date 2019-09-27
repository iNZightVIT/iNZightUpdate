inzight_packages <- function() {
    c(
        'iNZight',
        'iNZightTools',
        'iNZightModules',
        'iNZightPlots',
        'iNZightTS',
        'iNZightMR',
        'iNZightRegression',
        'iNZightMaps',
        'vit',
        'FutureLearnData'
    )
}

update_available <- function(pkg) {
    if (pkg %notin% inzight_packages()) return(character())
    # we are only interested in iNZight packages
    gh_url <- sprintf(
        "https://github.com/iNZightVIT/%s/releases/latest/download/",
        pkg
    )
    ap <- utils::available.packages(gh_url)
    pv <- utils::packageVersion(pkg)
    pv < numeric_version(ap[, 'Version'])
}

get_dependencies <- function(pkg) {
    if (pkg %notin% inzight_packages()) return(character())
    # we are only interested in iNZight packages
    ap <- utils::available.packages(gh_url(pkg))
    
    deps <- remotes:::parse_deps(
        paste(ap[, c("Depends", "Imports", "Suggests")], collapse = ",\n")
    )
    deps[deps$name %notin% c(inzight_packages(), 'NA'), ]
}

needs_install <- function(deps, lib) {
    # packages that aren't installed, OR are a lower version
    curpkgs <- utils::installed.packages(lib.loc = lib)
    needed <- apply(deps, 1, 
        function(dep) {
            if (dep[1] %notin% curpkgs[, 'Package']) return(1L)
            if (is.na(dep[3])) return(0L)
            pv <- numeric_version(curpkgs[dep[1], 'Version'])
            if (pv < numeric_version(dep[3])) return(1L)
            0L
        }
    )
    deps$name[needed == 1]
}

install_deps <- function(pkgs, repos, lib) {
    utils::install.packages(pkgs,
        repos = repos,
        lib = lib
    )
}

