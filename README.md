# Parallelizing R calculations on the SLURM cluster

The code in this directory illustrates three different approaches to repeatedly
run a piece of R code (with different parameters/settings) in parallel on the
SLURM cluster. 

## 0. Basic example

The script `0-local_run.R` introduces the sample problem we want to parallelize:
simulate random walks with different number of steps and step sizes, and compute
their summary statistics (via the `rw_stats` function). 

This version is meant to be run locally on RStudio and uses `lapply` to call
`rw_stats` with each set of parameters. 


## 1. Submit cluster jobs in a loop

The first approach is to wrap the code for a single execution of the code in 
a R script (`1-single_run.R`), create the corresponding submission script
(`1-single_run.sh`), then have a R script that loops over all parameter sets
and submits a job to the cluster for each (`1-loop_combine.R`). This requires
the `single_run` scripts to accept command line arguments in order to vary
parameters, and the `loop_combine` script needs to put together the cluster
output files for each job.

This approach is most appropriate when submitting a few long-running jobs, or 
a series of jobs where some can take a much longer time. Because of the overhead
cost involved in setting up a job and sending data to and from the cluster, this
is not an efficient way to submit a large number of relatively fast computations.


## 2. Explicit parallelization within a script

The second approach, illustrated in `2-script_parallel.R`, is similar to the
`local_run` script, but replaces `lapply` with `mclapply` from the `parallel` 
package, which allows the loop to run in parallel on 8 of the 64 cores available on
a single cluster node. 

This option has a few advantages: it only requires minimal modification of the 
original script, it sends a single cluster job, and it avoids splitting the 
output over multiple files. However, this type of job is limited to 64-fold parallelization
since it is not currently possible for one job to use multiple nodes.


## 3. Using the rslurm package

The third method, as suggested by the script title `3-with_rslurm.R`, makes use
of the `rslurm` R package (https://cyberhelp.sesync.org/rslurm). 
The `slurm_apply` function automates the process of splitting a set of parameters 
in multiple chunks, sending each one to a different cluster node, and parallelizing within
each node using `parallel` (as in the previous method). Another `rslurm` function,
`get_slurm_out`, serves to combine the output from the different nodes into a
single R object. Detailed information and examples can be found in the 
[vignette](http://cyberhelp.sesync.org/rslurm/articles/rslurm.html) 
and in the package documentation accessible from R.