# This script illustrates how to run code in parallel over the cluster by
#  repeatedly submitting the same script with different arguments, then
#  importing and collating the output.
# See single_run.R for the code that is called in each script run.

# Produce 10 random parameter sets for the random walk
nwalks <- 10

params <- data.frame(nsteps = runif(nwalks, 100, 1000),
                     sigma = runif(nwalks, 0, 10))

# Loop to submit a cluster job for each parameter set
for (i in 1:nwalks) {
    system(paste("sbatch single_run.sh", params$nsteps[i], params$sigma[i]))    
}

# Find all the cluster output files (.out)
out_files <- dir(pattern = "\\.out")

# Read the files and combine their output in one data frame, print summary
results <- lapply(out_files, read.table, header = TRUE)
summary(do.call(rbind, results))

# Delete the .out files when we're done with them
unlink(out_files)
