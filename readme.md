<img width="3388" height=auto alt="immagine" src="https://github.com/user-attachments/assets/7e2a2e84-cf24-4188-a3ce-7d673022113c" />


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
[AM3ICO_Union](Sources/AM3ICO_Union_12052026.ijm)

## [AMICO_Plotting](https://github.com/MarioFaretta/A.M3.I.CO/blob/Tutorial/Plotting_Tutorial/1-Plotting.md)

Macro to analyze the results of AMICO_Union Image Analysis producing Dot Plots and Histograms. It is possible to define Regions of Interest and combine them into logical gates as normally done in flow-cytometry.

Source:
[AM3ICO_Plotting](Sources/AM3ICO_Plotting_15042026.ijm)

# -----------------------------------------------------------------

# Automated multi resolution data collection

The general procedure is explained in the references below (in particular, Furia et al. Cytometry 2013, Furia et al. Front. Onc. 2022, Pelicci et al. Cells 2023, Pelicci et al. Laser Microdissection, Methods Molecular Biology, 2026).
Here you find a description of the [Automated Image Cytometry](Automated_Image_Cytometry/ScanStage.md) image acquisition procedure. It has been created as a  _JOB_ for the NIS Elements control software on a motorized Nikon microscopes (Ti2E inverted motorized microscope as described in our works). The detailed description of all the steps wants to help users of different microscopy station to rebuild the process in the brand specific environment.

# -----------------------------------------------------------------
The site is under construction. For more information take a look at the references below or write to mario.faretta@ieo.it
The macros were tested on ImageJ 1.53n, JAVA 1.8.0_172 (64-bit) on Windows 10.

## History

<img width="1025" height="545" alt="image" src="https://github.com/user-attachments/assets/42a20107-20d1-42e9-a163-0e7bfb549cd3" />


## Contributions

A.M<sup>3</sup>.I.CO is composed of protocols for sample preparation and experimental assays for widefield, confocal and super-resolution microscopy, procedures for automated image collection and software tools for data analysis. It has been created with the contribution of:

- **Mario Faretta** : Creation of the pipelines and coding of software packages (acquisition and analysis).
- **Laura Furia**: Design and validation of experimental assays.
- **Simone Pelicci**: Software validation. Creation of data analysis tools.



## References:

Furia L, Pelicci PG, Faretta M. A computational platform for robotized fluorescence microscopy (I): high-content image-based cell-cycle analysis. Cytometry A. 2013 Apr;83(4):333-43. doi: 10.1002/cyto.a.22266.

Furia L, Pelicci PG, Faretta M. A computational platform for robotized fluorescence microscopy (II): DNA damage, replication, checkpoint activation, and cell cycle progression by high-content high-resolution multiparameter image-cytometry. Cytometry A. 2013 Apr;83(4):344-55. doi: 10.1002/cyto.a.22265.

Furia L, Pelicci P, Faretta M. High-resolution cytometry for high-content cell cycle analysis. Curr Protoc Cytom. 2014 Oct 1;70:7.41.1-15. doi: 10.1002/0471142956.cy0741s70.

Furia L, Pelicci P, Faretta M. Confocal microscopy for high-resolution and high-content analysis of the cell cycle. Curr Protoc Cytom. 2014 Oct 1;70:7.42.1-14. doi: 10.1002/0471142956.cy0742s70.

Furia L, Pelicci S, Perillo F, Bolognesi MM, Pelicci PG, Facciotti F, Cattoretti G, Faretta M. Automated multimodal fluorescence microscopy for hyperplex spatial-proteomics: Coupling microfluidic-based immunofluorescence to high resolution, high sensitivity, three-dimensional analysis of histological slides. Front Oncol. 2022 Oct 13;12:960734. doi: 10.3389/fonc.2022.960734.

Furia L, Pelicci S, Scanarini M, Pelicci PG, Faretta M. From Double-Strand Break Recognition to Cell-Cycle Checkpoint Activation: High Content and Resolution Image Cytometry Unmasks 53BP1 Multiple Roles in DNA Damage Response and p53 Action. Int J Mol Sci. 2022 Sep 5;23(17):10193. doi: 10.3390/ijms231710193.

Pelicci S, Furia L, Pelicci PG, Faretta M. Correlative Multi-Modal Microscopy: A Novel Pipeline for Optimizing Fluorescence Microscopy Resolutions in Biological Applications. Cells. 2023 Jan 17;12(3):354. doi: 10.3390/cells12030354.

Pelicci S, Furia L, Pelicci PG, Faretta M. From Cell Populations to Molecular Complexes: Multiplexed Multimodal Microscopy to Explore p53-53BP1 Molecular Interaction. Int J Mol Sci. 2024 Apr 25;25(9):4672. doi: 10.3390/ijms25094672.

Pelicci S, Furia L, Spadari F, Grigolato R, Calabrese L, Girolami I, Faretta M. Automated Intelligent Microscopy for Phenotype Identification, Spatial Localization, and Retargeting of Cells. Methods Mol Biol. 2026;3015:193-209. doi: 10.1007/978-1-0716-5154-4_15.

Pelicci S, Furia L, Ciacci L, Gravina T, Pelicci PG, Dellino GI, Faretta M. 53BP1 as a cofactor in the activation of the p53-family transcriptional program: A correlative multimodal microscopy approach. Sci Adv. 2026 Oct 23;12(43):eaeh6993. doi: 10.1126/sciadv.aeh6993. 
