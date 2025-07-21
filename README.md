# Formatted Reporter Assembly for Measuring Editing in R (FRAMEr)

<img src="FRAMEr.png" width="100"/>

## Index

1. [Overview](#1-overview)
2. [Additional Resources](#2-additional-resources)
3. [Contact](#3-contact)
4. [Citation](#4-citation)
5. [Installation using Anaconda (Linux, Mac OS or WSL)](#5-installation-using-anaconda-linux-mac-os-or-wsl)
6. [Generating reporter target](#6-generating-reporter-target)
   - 6.1 [import_PRIDICT()](#61-import_pridict())
   - 6.2 [format_reporter()](#62-format_reporter())
7. [Filter targeting pegRNAs](#7-filter-targeting-pegrnas)
   - 7.1 [PAM_seed_disrupted()](#71-pam_seed_disrupted())
   - 7.2 [size_restrict_pegRNAs()](#72-size_restrict_pegrnas())
   - 7.3 [pick_pegRNAs()](#73-prioritize_pegRNAs())
8. [Add controls](#8-add-controls)
   - 8.1 [create_matched_controls()](#81-create_matched_controls())
   - 8.2 [nontargeting_pegRNAs()](#82-nontargeting_pegRNAs())
   - 8.3 [compile_pegRNAs()](#82-compile_pegRNAs())
9. [Format pegRNA oligos](#9-format-pegrna-oligos)
   - 9.1 [generate_barcodes()](#91-generate_barcodes())
   - 9.2 [format_oligos()](#92-format_oligos())

## 1. Overview
FRAMEr is an R package to format PRIDICT2.0 generated prime editing guide RNAs into reporter oligos for high-throughput screening. This repository allows you to run the workflow locally.

## 2. Additional Resources

[PRIDICT2.0](https://github.com/uzh-dqbm-cmi/PRIDICT2) is a model designed for predicting the efficiency of prime editing guide RNAs. See [Mathis et al., Nature Biotechnology, 2024](https://rdcu.be/dLu0f) and the initial [BioRxiv preprint](https://www.biorxiv.org/content/10.1101/2023.10.09.561414v1).


## 3. Contact

For questions or suggestions, please either:
- Email us at [marisa.hamilton@duke.edu](mailto:marisa.hamilton@duke.edu)
- Open a GitHub issue

## 4. Citation

If find our work useful for your research please cite: TBA

## 5. Installation using Anaconda (Linux, Mac OS or WSL)

* Start a terminal and run:
    ```shell
    # clone FRAMEr repository
    git clone https://github.com/miahamilton5/FRAMEr.git
    ```
* Start RStudio and run:
    ```r
   install.packages("devtools")
   library(devtools)
   frameR = devtools::build("~/put/the/package/path/here")
   devtools::install_local(frameR)
   library(frameR)
    ```

## 6. Generating reporter target

### 6.1 import_PRIDICT()

Creates an R dataframe of PRIDICT pegRNAs from directory containing PRIDICT outputs

####  Required:
  -  `input_directory`: Path to PRIDICT output with prediction .csvs

Example command:
```r
pegRNAs <- import_PRIDICT(input_directory = "PATH/TO/PRIDICT2/predictions/")
``` 
#

### 6.2 format_reporter()

Adds column to pegRNA dataframe containing reporter sequence

####  Required:
  -  `pegRNAs`: Dataframe of imported PRIDICT pegRNAs. Generated from import_PRIDICT()

Example command:
```r
pegRNAs <- format_reporter(pegRNAs = pegRNAs)
``` 
#

## 7. Filter targeting pegRNAs

### 7.1 PAM_seed_disrupted()

Adds column to pegRNA dataframe indicating TRUE/FALSE for edit disrupting the PAM or seed regions of the pegRNA target sequence

####  Required:
  -  `pegRNAs`: Dataframe of pegRNAs

Example command:
```r
pegRNAs <- PAM_seed_disrupted(pegRNAs = pegRNAs)
``` 
#

### 7.2 size_restrict_pegRNAs()

Removes pegRNAs surpasing size limitations. Default oligo length = 300

####  Required:
  -  `pegRNAs`: Dataframe of pegRNAs containing 'reporter' column generated from format_reporter()

####  Optional:
   - `five_prime_overhang`: 5' overhang for PCR amplification and plasmid cloning. Default: "GTGGAAAGGACGAAACACC"
   - `tevopreq1`: tevopreQ1 sequence, enter "" for no tevopreQ1. Default: "CGCGGTTCTATCTAGTTACGCGTTAAACCAACTAGAA"
   - `terminator`: terminator sequence following tevopreQ1. Default: "TTTTTTT"
   - `barcode_length`: length of the pegRNA barcode. Enter 0 for no barcode. Default: 7
   - `three_prime_overhang`: 3' overhang for PCR amplification and plasmid cloning. Default: "AGATCGGAAGAGCACACGTC"
   - `matched_controls`: TRUE/FALSE to adjust the length requirements to account for future matched control pegRNAs. e.g. matched control pegRNAs for a 5 bp deletion will be 5 bases longer than the targeting pegRNA. Default: TRUE
   - `size_limit`: size limit of oligos. Default: 300

Example command:
```r
pegRNAs <- size_restrict_pegRNAs(pegRNAs = pegRNAs)
``` 
#

### 7.3 pick_pegRNAs()

Subsets a dataframe of pegRNAs based on number of desired pegRNAs, ranking by PRIDICT score

####  Required:
  -  `pegRNAs`: Dataframe of pegRNAs
  -  `number_of_pegRNAs`: Number of pegRNAs per edit to pick
  -  `PRIDICT_celltype`: PRIDICT score to rank by. Options: "HEK" (MMR deficienct) or "K562" (MMR proficient)

####  Optional:
   - `remove_PAM_seed_disrupted`: TRUE/FALSE to remove pegRNAs that disrupt the PAM or seed region of the pegRNA. Default: FALSE
   - `PRIDICT_threshold`: Will remove all pegRNAs for a particular edit if that edit does not have at least one pegRNA with a PRIDICT score greater than or equal to this threshold

Example command:
```r
pegRNAs <- pick_pegRNAs(pegRNAs, number_of_pegRNAs = 4, PRIDICT_celltype = "HEK", remove_PAM_seed_disrupted = TRUE, PRIDICT_threshold = 50)
``` 
#

## 8. Add controls

### 8.1 create_matched_controls()

Creates a new dataframe of matched control pegRNAs from a dataframe of targeting pegRNAs

####  Required:
  -  `pegRNAs`: Dataframe of pegRNAs

Example command:
```r
matched_pegRNAs <- create_matched_controls(pegRNAs)
``` 

### 8.2 nontargeting_pegRNAs()

### 8.3 compile_pegRNAs()

## 9. Format pegRNA oligos

### 9.1 generate_barcodes()

### 9.2 format_oligos()
