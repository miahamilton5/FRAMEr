# Formatted Reporter Assembly for Measuring Editing in R (FRAMEr)

<img src="frameR.png" width="100"/>

## Index

1. [Overview](#1-overview)
2. [Additional Resources](#2-additional-resources)
3. [Contact](#3-contact)
4. [Citation](#4-citation)
5. [Installation using Anaconda (Linux, Mac OS or WSL)](#5-installation-using-anaconda-linux-mac-os-or-wsl)
6. [Generating reporter target](#6-generating-reporter-target)
   - 6.1 [import_PRIDICT()](#61-import_PRIDICT())
   - 6.2 [format_reporter()](#62-format_reporter())
7. [Filter targeting pegRNAs](#7-filter-pegRNAs)
   - 7.1 [PAM_seed_disrupted()](#71-PAM_seed_disrupted())
   - 7.2 [size_restrict_pegRNAs()](#72-size_restrict_pegRNAs())
   - 7.3 [prioritize_pegRNAs()](#73-prioritize_pegRNAs())
8. [Add controls](#8-generating-pegRNA-library)
   - 8.1 [create_matched_controls()](#81-create_matched_controls())
   - 8.2 [nontargeting_pegRNAs()](#82-nontargeting_pegRNAs())
9. [Format pegRNA oligos](#9-generating-pegRNA-library)
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

## 6. Generating reporter target

### 6.1 import_PRIDICT()
####  Required:
  -  `input_directory`: Path to PRIDICT output with prediction .csvs

Example command:
```r
pegRNAs <- import_PRIDICT(input_directory = "PATH/TO/PRIDICT2/predictions/")
``` 
#

### 6.2 format_reporter()
####  Required:
  -  `pegRNAs`: Dataframe of imported PRIDICT pegRNAs. Generated from import_PRIDICT()

Example command:
```r
pegRNAs_with_reporter <- format_reporter(pegRNAs = pegRNAs)
``` 
#

## 7. Filter targeting pegRNAs

### 7.1 PAM_seed_disrupted()

### 7.2 size_restrict_pegRNAs()

### 7.3 prioritize_pegRNAs()

## 8. Add controls

### 8.1 create_matched_controls()

### 8.2 nontargeting_pegRNAs()

## 9. Format pegRNA oligos

### 9.1 generate_barcodes()

### 9.2 format_oligos()
