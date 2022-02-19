###############################################################################
# Extract sampling data
# create column specifying group
# combine to df
###############################################################################

brain_met <- read.csv("data/sampling_brain_metastasis_100.csv")
# create column with group
brain_l <- nrow(brain_met)
brain_met$group <- c(rep("Brain metastasis", brain_l))

breast_cancer <- read.csv("data/sampling_breast_cancer_100.csv")
breast_l <- nrow(breast_cancer)
breast_cancer$group <- c(rep("Breast cancer", breast_l))

lung_met <- read.csv("data/sampling_lung_metastasis_100.csv")
lung_l <- nrow(lung_met)
lung_met$group <- c(rep("Lung metastasis", lung_l))

brain_tissue <- read.csv("data/sampling_brain_tissue_100.csv")
brain_l <- nrow(brain_tissue)
brain_tissue$group <- c(rep("Brain tissue", brain_l))

breast_tissue <- read.csv("data/sampling_breast_tissue_100.csv")
breast_l <- nrow(breast_tissue)
breast_tissue$group <- c(rep("Breast tissue", breast_l))

lung_tissue <- read.csv("data/sampling_lung_tissue_100.csv")
lung_l <- nrow(lung_tissue)
lung_tissue$group <- c(rep("Lung tissue", lung_l))

ependymoma <- read.csv("data/sampling_ependymoma_100.csv")
l <- nrow(ependymoma)
ependymoma$group <- c(rep("Ependymoma", l))

glioblastoma <- read.csv("data/sampling_glioblastoma_100.csv")
l <- nrow(glioblastoma)
glioblastoma$group <- c(rep("Glioblastoma", l))

gbm_sur <- read.csv("data/sampling_gbm_surrounding_tissue_100.csv")
l <- nrow(gbm_sur)
gbm_sur$group <- c(rep("GBM surrounding tissue", l))

medullablastoma <- read.csv("data/sampling_medullablastoma_100.csv")
l <- nrow(medullablastoma)
medullablastoma$group <- c(rep("Medullablastoma", l))

pilocyticastrocytoma <- read.csv("data/sampling_pilocyticastrocytoma_100.csv")
l <- nrow(pilocyticastrocytoma)
pilocyticastrocytoma$group <- c(rep("Pilocyticastrocytoma", l))


# summarize reactions from all models
all_reactions <- unique(c(
  colnames(brain_met), colnames(breast_cancer), colnames(lung_met),
  colnames(brain_tissue), colnames(breast_tissue), colnames(lung_tissue),
  colnames(ependymoma), colnames(gbm_sur), colnames(glioblastoma),
  colnames(medullablastoma), colnames(pilocyticastrocytoma)
))

# fill in missing reactions as NA
brain_met[, setdiff(all_reactions, colnames(brain_met))] <- NA
brain_tissue[, setdiff(all_reactions, colnames(brain_tissue))] <- NA
breast_tissue[, setdiff(all_reactions, colnames(breast_tissue))] <- NA
breast_cancer[, setdiff(all_reactions, colnames(breast_cancer))] <- NA
lung_met[, setdiff(all_reactions, colnames(lung_met))] <- NA
lung_tissue[, setdiff(all_reactions, colnames(lung_tissue))] <- NA
ependymoma[, setdiff(all_reactions, colnames(ependymoma))] <- NA
glioblastoma[, setdiff(all_reactions, colnames(glioblastoma))] <- NA
gbm_sur[, setdiff(all_reactions, colnames(gbm_sur))] <- NA
medullablastoma[, setdiff(all_reactions, colnames(medullablastoma))] <- NA
pilocyticastrocytoma[, setdiff(all_reactions, colnames(pilocyticastrocytoma))] <- NA

# combine dataframes
flux <- rbind(brain_met, breast_cancer, lung_met, brain_tissue, breast_tissue,
              lung_tissue, glioblastoma, gbm_sur, pilocyticastrocytoma, ependymoma, medullablastoma,
              fill = TRUE
)
# set NA to zero flux
flux[is.na(flux)] <- 0