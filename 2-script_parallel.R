# This script illustrates how to use multiple cores of a single cluster node
#  for a repeated calculation with the parallel package in R

library(parallel)

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

# Generate 10000 parameter sets
nwalks <- 10000

params <- data.frame(nsteps = runif(nwalks, 100, 1000),
                     sigma = runif(nwalks, 0, 10))

# Apply rw_stats function to all parameter sets, and parallelize over the 8 cores
#  of the cluster node where this script will be submitted
system.time(
    results <- mclapply(1:nwalks, 
                        function(i) rw_stats(params$nsteps[i], params$sigma[i]),
                        mc.cores = 8)
)

summary(do.call(rbind, results))
