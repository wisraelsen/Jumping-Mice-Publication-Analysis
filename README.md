# Jumping-Mice-Publication-Analysis
This contains a few awk scripts and a textfile "notebook" containing all of my working data analysis for the following scientific publication:

Brem EA, McNulty AD, Israelsen WJ. *Breeding and hibernation of captive meadow jumping mice (Zapus hudsonius).* PLoS One. 2021 May 10;16(5):e0240706. doi: 10.1371/journal.pone.0240706. PMID: 33970917; PMCID: PMC8109813.  [Link to Full Text](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0240706)

While the relevant final data and methods are contained in the paper and Supporting Information, I am sharing my scripts and working commands & notes here, mostly for my own reference if needed.

### As context:
- The text file is a running log of my bash and R commands and notes.  It is more of a historical record and only runnable in the sense that one could manually run through the commands to reproduce everything I did in the paper.  
- The ad hoc awk scripts were for wrangling some time series data obtained from Expedata software (Sable Systems International), following cleanup.
- I am working on sorting through the intermediate results to upload relevant input data for running the awk scripts.
- The glm_hib_experiment folder contains the data I used for the multiple regression in the paper; the R commands are in the text file.
