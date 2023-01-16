#!/bin/bash
#SBATCH --job-name=tmp		# Job name (testBowtie2)
#SBATCH --partition=tcb_sas_p		# Partition name (batch, highmem_p, or gpu_p)
#SBATCH --ntasks=1			# Run job in single task, by default using 1 CPU core on a single node
#SBATCH --cpus-per-task=10	 	# CPU core count per task, by default 1 CPU core per task
#SBATCH --mem=50G			# Memory per node (4GB); by default using M as unit
#SBATCH --time=24:00:00              	# Time limit hrs:min:sec or days-hours:minutes:seconds
#SBATCH --export=NONE                   # Do not export any user’s explicit environment variables to compute node
#SBATCH --output=log_%x_%j.out		# Standard output log, e.g., testBowtie2_12345.out
#SBATCH --error=log_%x_%j.err		# Standard error log, e.g., testBowtie2_12345.err
#SBATCH --mail-user=schmutte@uga.edu    # Where to send mail
#SBATCH --mail-type=END,FAIL          	# Mail events (BEGIN, END, FAIL, ALL)


cd $SLURM_SUBMIT_DIR			# Change directory to job submission directory (Optional!)

ml SAS/9.4-TerryCollege    		# Load software module 

sas -memsize 50G -sortsize 45G ./01.01.RAIS_extract.sas
