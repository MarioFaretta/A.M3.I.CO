<img width="1600" height="836" alt="image" src="https://github.com/user-attachments/assets/56787f4f-ec03-4597-a9de-cd0e73c56d1d" />


# Macros for Image Cytometry Analysis by Fluorescence Microscopy in ImageJ. 
The site is under construction. For more information take a look at the references below or write to mario.faretta@ieo.it
The macros were tested on ImageJ 1.53n, JAVA 1.8.0_172 (64-bit) on Windows 10.

# History

<img width="600" height="432" alt="immagine" src="https://github.com/user-attachments/assets/6bb3bfaf-fd92-459c-b921-0903128d6dad" />


# References:
Furia, Laura, Pier Giuseppe Pelicci, e Mario Faretta. 2013a. «A Computational Platform for Robotized Fluorescence Microscopy (I): High-Content Image-Based Cell-Cycle Analysis». Cytometry Part A 83A (4): 333–43. https://doi.org/10.1002/cyto.a.22266.

Furia, Laura, Pier Giuseppe Pelicci, e Mario Faretta. 2013b. «A Computational Platform for Robotized Fluorescence Microscopy (II): DNA Damage, Replication, Checkpoint Activation, and Cell Cycle Progression by High-Content High-Resolution Multiparameter Image-Cytometry». Cytometry Part A 83A (4): 344–55. https://doi.org/10.1002/cyto.a.22265.

Furia, Laura, Piergiuseppe Pelicci, e Mario Faretta. 2014a. «Confocal Microscopy for High‐Resolution and High‐Content Analysis of the Cell Cycle». Current Protocols in Cytometry 70 (1). https://doi.org/10.1002/0471142956.cy0742s70.

Furia, Laura, Piergiuseppe Pelicci, e Mario Faretta. 2014b. «High‐Resolution Cytometry for High‐Content Cell Cycle Analysis». Current Protocols in Cytometry 70 (1). https://doi.org/10.1002/0471142956.cy0741s70.

Furia, Laura, Simone Pelicci, Federica Perillo, et al. 2022. «Automated Multimodal Fluorescence Microscopy for Hyperplex Spatial-Proteomics: Coupling Microfluidic-Based Immunofluorescence to High Resolution, High Sensitivity, Three-Dimensional Analysis of Histological Slides». Frontiers in Oncology 12 (ottobre): 960734. https://doi.org/10.3389/fonc.2022.960734.

Furia, Laura, Simone Pelicci, Mirco Scanarini, Pier Giuseppe Pelicci, e Mario Faretta. 2022. «From Double-Strand Break Recognition to Cell-Cycle Checkpoint Activation: High Content and Resolution Image Cytometry Unmasks 53BP1 Multiple Roles in DNA Damage Response and P53 Action». International Journal of Molecular Sciences 23 (17): 10193. https://doi.org/10.3390/ijms231710193.

Pelicci, Simone, Laura Furia, Pier Giuseppe Pelicci, e Mario Faretta. 2023. «Correlative Multi-Modal Microscopy: A Novel Pipeline for Optimizing Fluorescence Microscopy Resolutions in Biological Applications». Cells 12 (3): 3. https://doi.org/10.3390/cells12030354.

Pelicci, Simone, Laura Furia, Pier Giuseppe Pelicci, e Mario Faretta. 2024. «From Cell Populations to Molecular Complexes: Multiplexed Multimodal Microscopy to Explore P53-53BP1 Molecular Interaction». International Journal of Molecular Sciences 25 (9): 9. https://doi.org/10.3390/ijms25094672.

Pelicci, Simone, Laura Furia, Francesco Spadari, et al. 2026. «Automated Intelligent Microscopy for Phenotype Identification, Spatial Localization, and Retargeting of Cells». In Laser Capture Microdissection: Methods and Protocols, a cura di Roberta Noberini. Springer US. https://doi.org/10.1007/978-1-0716-5154-4_15.

# [AMICO_Union](Union.md)
Macro to Browse through acquired images, set up of Segmentation parameters and analysis of particles, and intracellular subcompartment (e.g. foci) recognition. Results are stored in a tab-txt file. The macro works on .nd2, multichannel OME.tiff files or on separated channels tiffs for a single position.

Source:
[AMICO_Union.txt](https://github.com/MarioFaretta/AMICO/blob/main/AMICO_Union.txt)

# AMICO_Plotting.txt
Macro to analyze the results of AMICO_Union Image Analysis producing Dot Plots and Histograms. It is possible to define Regions of Interest and combine them into logical gates as normally done in flow-cytometry.

