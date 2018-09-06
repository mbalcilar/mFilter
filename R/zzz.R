#.First.lib <-
.onAttach <- function(libname, pkgname) {
    # mylib <- dirname(system.file(package = "mFilter"))
    # ver <- packageDescription("mFilter", lib.loc = mylib)["Version"]
    ver <- packageDescription("mFilter")$Version
    txt <- c("\n",
             paste(sQuote("mFilter"), "version:", ver),
             "\n",
             paste(sQuote("mFilter"),
                   "is a package for time series filtering"),
             "\n",
             paste("See",
                   sQuote("library(help=\"mFilter\")"),
                   "for details"),
             "\n",
             paste("Author: Mehmet Balcilar, mbalcilar@yahoo.com"),
             "\n"
    )
    if (interactive() || getOption("verbose")) {
        msg = paste(strwrap(txt, indent = 4, exdent = 4), collapse = "\n")
        packageStartupMessage(msg)
    }
}

