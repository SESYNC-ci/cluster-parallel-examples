# The code below is the basis for the other examples in this directory
#  demonstrating different methods for parellelizing code execution on the cluster
#
# This version is meant to be run locally from RStudio


### Define functions

# Creates a random walk from (0, 0) with nsteps and RMS step length sigma 
rwalk <- function(nsteps, sigma) {
    rw_path <- matrix(NA, nrow = nsteps, ncol = 2)
    rw_path[1, ] <- c(0, 0)
    for (i in 2:nsteps) {
        rw_path[i, ] <- rw_path[i - 1, ] + rnorm(2, 0, sigma)
    }
    rw_path   
}

# Creates a random walk and returns some summary statistics
rw_stats <- function(nsteps, sigma) {
    path <- rwalk(nsteps, sigma)
    c(xdist = abs(path[1, 1] - path[nsteps, 1]),
      ydist = abs(path[1, 2] - path[nsteps, 2]),
      xspan = max(path[, 1]) - min(path[, 1]),
      yspan = max(path[, 2]) - min(path[, 2]))
}


### Run function for 1000 parameter sets

nwalks <- 1000

params <- data.frame(nsteps = runif(nwalks, 100, 1000),
                     sigma = runif(nwalks, 0, 10))

# Stats for one run
rw_stats(params$nsteps[1], params$sigma[1])

# Time how long it takes to apply function over all parameter sets
system.time( 
    results <- lapply(1:nwalks, 
                      function(i) rw_stats(params$nsteps[i], params$sigma[i]))
)

# Bind resulting stats in one data frame and summarize
summary(do.call(rbind, results))




