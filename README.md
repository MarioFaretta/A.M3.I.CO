<img width="3388" height="1320" alt="immagine" src="https://github.com/user-attachments/assets/7e2a2e84-cf24-4188-a3ce-7d673022113c" />

# Automated Multiplexed Multimodal Microscopy for Image CytOmetry A.M<sup>3</sup>.I.CO

Microscope automation allows surpassing the intrinsic limitations of human-driven usage of the instrument, providing:

- virtually unlimited sampling with the acquisition of hundreds to thousands of images in multiple fluorescence channels

- objective data collection and analysis

Automated image analysis provides the basis for the implementation of an image cytometry approach that, harnessing the framework of flow cytometry, reaches a statistical sampling in the order of several thousands of events and associates quantitative data extracted from the collected images to spatial information on the localization of the detected signals.

The Automated Microscopy for Image Cytometry A.M<sup>3</sup>.I.CO pipeline is composed of protocols, procedures, and computational tools starting from sample preparation to image collection and data analysis.This site contains the sources of the developed ImageJ macros to perform  analysis on the acquired images.

# -----------------------------------------------------------------

# Macros for Image Cytometry Analysis by Fluorescence Microscopy in ImageJ. 
## [AMICO_Union](https://github.com/MarioFaretta/A.M3.I.CO/blob/Tutorial/Union_Tutorial/1-Union.md)
Macro to Browse through acquired images, set up of Segmentation parameters and analysis of particles, and intracellular subcompartment (e.g. foci) recognition. Results are stored in a tab-txt file. The macro works on single or multi channel .nd2, OME.tiff files and other image formats.

Source:
[AMICO_Union.txt](https://github.com/MarioFaretta/AMICO/blob/main/AMICO_Union.txt)

## [AMICO_Plotting](https://github.com/MarioFaretta/A.M3.I.CO/blob/Tutorial/Plotting_Tutorial/1-Plotting.md)

Macro to analyze the results of AMICO_Union Image Analysis producing Dot Plots and Histograms. It is possible to define Regions of Interest and combine them into logical gates as normally done in flow-cytometry.

Source:
[AMICO_Plotting.txt](https://github.com/MarioFaretta/AMICO/blob/main/AMICO_Plotting.txt)

# -----------------------------------------------------------------
The site is under construction. For more information take a look at the references below or write to mario.faretta@ieo.it
The macros were tested on ImageJ 1.53n, JAVA 1.8.0_172 (64-bit) on Windows 10.

## History

<img width="600" height="432" alt="immagine" src="https://github.com/user-attachments/assets/6bb3bfaf-fd92-459c-b921-0903128d6dad" />

## Contributions

A.M<sup>3</sup>.I.CO is composed of protocols for sample preparation and experimental assays for widefield, confocal and super-resolution microscopy, procedures for automated image collection and software tools for data analysis. It has been created with the contribution of:

- ## Mario Faretta : Conception and development of the pipelines and coding of the software packages (acquisition and analysis)
- ## Laura Furia: Design and validation of experimental assays
- ## Simone Pelicci: Software validation. Creation of data analysis tools.



## References:
Furia, Laura, Pier Giuseppe Pelicci, Mario Faretta. 2013a. «A Computational Platform for Robotized Fluorescence Microscopy (I): High-Content Image-Based Cell-Cycle Analysis». Cytometry Part A 83A (4): 333–43. https://doi.org/10.1002/cyto.a.22266.

Furia, Laura, Pier Giuseppe Pelicci, Mario Faretta. 2013b. «A Computational Platform for Robotized Fluorescence Microscopy (II): DNA Damage, Replication, Checkpoint Activation, and Cell Cycle Progression by High-Content High-Resolution Multiparameter Image-Cytometry». Cytometry Part A 83A (4): 344–55. https://doi.org/10.1002/cyto.a.22265.

Furia, Laura, Piergiuseppe Pelicci, Mario Faretta. 2014a. «Confocal Microscopy for High‐Resolution and High‐Content Analysis of the Cell Cycle». Current Protocols in Cytometry 70 (1). https://doi.org/10.1002/0471142956.cy0742s70.

Furia, Laura, Piergiuseppe Pelicci, Mario Faretta. 2014b. «High‐Resolution Cytometry for High‐Content Cell Cycle Analysis». Current Protocols in Cytometry 70 (1). https://doi.org/10.1002/0471142956.cy0741s70.

Furia, Laura, Simone Pelicci, Federica Perillo, et al. 2022. «Automated Multimodal Fluorescence Microscopy for Hyperplex Spatial-Proteomics: Coupling Microfluidic-Based Immunofluorescence to High Resolution, High Sensitivity, Three-Dimensional Analysis of Histological Slides». Frontiers in Oncology 12 (ottobre): 960734. https://doi.org/10.3389/fonc.2022.960734.

Furia, Laura, Simone Pelicci, Mirco Scanarini, Pier Giuseppe Pelicci, Mario Faretta. 2022. «From Double-Strand Break Recognition to Cell-Cycle Checkpoint Activation: High Content and Resolution Image Cytometry Unmasks 53BP1 Multiple Roles in DNA Damage Response and P53 Action». International Journal of Molecular Sciences 23 (17): 10193. https://doi.org/10.3390/ijms231710193.

Pelicci, Simone, Laura Furia, Pier Giuseppe Pelicci, Mario Faretta. 2023. «Correlative Multi-Modal Microscopy: A Novel Pipeline for Optimizing Fluorescence Microscopy Resolutions in Biological Applications». Cells 12 (3): 3. https://doi.org/10.3390/cells12030354.

Pelicci, Simone, Laura Furia, Pier Giuseppe Pelicci, Mario Faretta. 2024. «From Cell Populations to Molecular Complexes: Multiplexed Multimodal Microscopy to Explore P53-53BP1 Molecular Interaction». International Journal of Molecular Sciences 25 (9): 9. https://doi.org/10.3390/ijms25094672.

Pelicci, Simone, Laura Furia, Francesco Spadari, et al. 2026. «Automated Intelligent Microscopy for Phenotype Identification, Spatial Localization, and Retargeting of Cells». In Laser Capture Microdissection: Methods and Protocols, a cura di Roberta Noberini. Springer US. https://doi.org/10.1007/978-1-0716-5154-4_15.


