context("Get dependencies")

test_that("", {
    deps <- get_dependencies("iNZightTools")
    expect_equal(colnames(deps), c("name", "compare", "version"))
})

# needs_install(deps, .libPaths()[1])
# install_deps(needed, repos, lib)