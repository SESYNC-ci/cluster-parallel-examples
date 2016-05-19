# This script takes two command line arguments i.e.
#  Rscript single_run.R [nsteps] [sigma]
# and returns the summary statistics for a random walk using those parameters.
#
# It is repeatedly submitted to the cluster in the 'loop_combine.R' script.

# Creates create a random walk from (0, 0) with nsteps and RMS step length sigma 
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

# Get two parameters from command line arguments
params <- commandArgs(trailingOnly = TRUE)

nsteps <- as.integer(params[1])
sigma <- as.integer(params[2])

# Output stats
rw_stats(nsteps, sigma)

