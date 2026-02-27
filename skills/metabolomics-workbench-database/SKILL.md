---
name: metabolomics-workbench-database
description: Access NIH Metabolomics Workbench REST API (4200+ studies). Search metabolites by m/z, standardize names via RefMet, query study data by analytical method/ionization mode, find disease-specific metabolomics datasets. Essential for untargeted metabolomics compound annotation.
license: Public (NIH-sponsored)
metadata:
    skill-author: K-Dense Inc.
---

# Metabolomics Workbench Database

## Overview

The Metabolomics Workbench is an NIH-sponsored repository containing over 4,200 processed studies (3,790+ publicly available) with standardized metabolite nomenclature and multi-platform analytical data. It provides a REST API for programmatic access to metabolomics data, compound structures, and the RefMet nomenclature system.

## When to Use This Skill

- Identifying compounds from MS data by m/z value
- Standardizing metabolite naming conventions using RefMet
- Finding disease-specific metabolomics studies
- Exploring gene-metabolite relationships
- Accessing untargeted metabolomics experimental results
- Searching for studies by analytical platform (LC-MS, GC-MS, NMR)

## API Base URL

```
https://www.metabolomicsworkbench.org/rest/
```

## Core Capabilities

### 1. Mass Spectrometry m/z Search

Search compounds by m/z value — the primary use case for MS data annotation:

```python
import requests

def search_by_mz(mz, adduct='M+H', tolerance=0.005, database='all'):
    """Search for compounds by m/z value."""
    url = f"https://www.metabolomicsworkbench.org/rest/compound/mass/{mz}/exact_mass/{mz + tolerance}/all"
    response = requests.get(url)
    return response.json()

# Example: Find compounds matching m/z 180.0634 (positive mode, M+H)
def search_mz_with_adduct(mz_observed, adduct='M+H', tolerance=0.01):
    """Search accounting for common adducts."""
    adduct_masses = {
        'M+H':    1.00728,
        'M+Na':   22.98922,
        'M+K':    38.96316,
        'M+NH4':  18.03437,
        'M-H':    -1.00728,
        'M+FA-H': 44.99765,
        'M+Cl':   34.96940,
    }
    neutral_mass = mz_observed - adduct_masses.get(adduct, 0)
    url = f"https://www.metabolomicsworkbench.org/rest/compound/mass/{neutral_mass - tolerance}/{neutral_mass + tolerance}/all"
    response = requests.get(url)
    if response.status_code == 200:
        return response.json()
    return {}
```

### 2. Metabolite Structure Queries

```python
import requests

# Search by compound name
def search_by_name(name):
    url = f"https://www.metabolomicsworkbench.org/rest/compound/name/{name}/all"
    response = requests.get(url)
    return response.json()

# Search by various identifiers
def search_by_id(id_type, id_value):
    """
    id_type: 'pubchem_cid', 'inchikey', 'kegg_id', 'hmdb_id', 'refmet_name'
    """
    url = f"https://www.metabolomicsworkbench.org/rest/compound/{id_type}/{id_value}/all"
    response = requests.get(url)
    return response.json()

# Example: Search by InChI Key
result = search_by_id('inchikey', 'WQZGKKKJIJFFOK-GASJEMHNSA-N')

# Example: Search by PubChem CID
result = search_by_id('pubchem_cid', '5793')
```

### 3. RefMet Nomenclature Standardization

RefMet is the standardized reference nomenclature for metabolites, especially important for lipids and metabolomics:

```python
import requests

def get_refmet(name):
    """Get standardized RefMet name and classification for a metabolite."""
    url = f"https://www.metabolomicsworkbench.org/rest/refmet/name/{name}/all"
    response = requests.get(url)
    return response.json()

def get_refmet_classification(refmet_name):
    """Get hierarchical chemical classification."""
    url = f"https://www.metabolomicsworkbench.org/rest/refmet/name/{refmet_name}/classification"
    response = requests.get(url)
    return response.json()

# Example
result = get_refmet('glucose')
# Returns: refmet_name, formula, exact_mass, super_class, main_class, sub_class

# Batch name standardization
def standardize_names(name_list):
    """Standardize a list of metabolite names to RefMet."""
    results = {}
    for name in name_list:
        result = get_refmet(name)
        results[name] = result
    return results
```

### 4. Study Data Access

```python
import requests

# Search studies by metabolite
def find_studies_by_metabolite(metabolite_name):
    url = f"https://www.metabolomicsworkbench.org/rest/study/metabolite_name/{metabolite_name}/summary"
    response = requests.get(url)
    return response.json()

# Search studies by disease
def find_studies_by_disease(disease):
    url = f"https://www.metabolomicsworkbench.org/rest/study/disease/{disease}/summary"
    response = requests.get(url)
    return response.json()

# Get all studies (paginated)
def get_studies(page=1, pagesize=10):
    url = f"https://www.metabolomicsworkbench.org/rest/study/study_id/ST/summary"
    response = requests.get(url)
    return response.json()

# Get specific study details
def get_study(study_id):
    url = f"https://www.metabolomicsworkbench.org/rest/study/study_id/{study_id}/summary"
    response = requests.get(url)
    return response.json()

# Get study data
def get_study_data(study_id):
    url = f"https://www.metabolomicsworkbench.org/rest/study/study_id/{study_id}/data"
    response = requests.get(url)
    return response.json()
```

### 5. Filter Studies by Analytical Parameters

```python
import requests

# Find LC-MS studies in positive ion mode
def find_lcms_studies(ionization='positive'):
    url = f"https://www.metabolomicsworkbench.org/rest/study/analysis_type/MS/summary"
    response = requests.get(url)
    return response.json()

# Search by sample type
def find_studies_by_sample(sample_type):
    """sample_type: 'urine', 'plasma', 'serum', 'tissue', etc."""
    url = f"https://www.metabolomicsworkbench.org/rest/study/subject_type/{sample_type}/summary"
    response = requests.get(url)
    return response.json()
```

### 6. Gene and Protein Information

```python
import requests

# Get gene-metabolite associations
def get_gene_metabolite(gene_symbol):
    url = f"https://www.metabolomicsworkbench.org/rest/gene/gene_symbol/{gene_symbol}/all"
    response = requests.get(url)
    return response.json()
```

## Common MS Annotation Workflow

```python
import requests
import pandas as pd

def annotate_ms_features(feature_list, ion_mode='positive', ppm_tolerance=10):
    """
    Annotate a list of m/z features using Metabolomics Workbench.

    Parameters:
    - feature_list: list of dicts with 'mz' and optionally 'rt'
    - ion_mode: 'positive' or 'negative'
    - ppm_tolerance: mass tolerance in ppm
    """
    adducts_pos = {'M+H': 1.00728, 'M+Na': 22.98922, 'M+K': 38.96316}
    adducts_neg = {'M-H': -1.00728, 'M+FA-H': 44.99765, 'M+Cl': 34.96940}
    adducts = adducts_pos if ion_mode == 'positive' else adducts_neg

    annotations = []
    for feature in feature_list:
        mz = feature['mz']
        feature_annotations = []

        for adduct_name, adduct_mass in adducts.items():
            neutral_mass = mz - adduct_mass
            tolerance = neutral_mass * ppm_tolerance / 1e6

            url = f"https://www.metabolomicsworkbench.org/rest/compound/mass/{neutral_mass - tolerance}/{neutral_mass + tolerance}/all"
            response = requests.get(url)

            if response.status_code == 200 and response.text != 'null':
                hits = response.json()
                if hits:
                    for hit in (hits if isinstance(hits, list) else [hits]):
                        feature_annotations.append({
                            'mz': mz,
                            'adduct': adduct_name,
                            'compound_name': hit.get('name', ''),
                            'formula': hit.get('formula', ''),
                            'exact_mass': hit.get('exact_mass', ''),
                            'refmet_name': hit.get('refmet_name', '')
                        })

        annotations.extend(feature_annotations)

    return pd.DataFrame(annotations)
```

## Output Formats

The API returns data in:
- **JSON** (default): For programmatic access
- **Tab-delimited TXT**: For tabular data

## Best Practices

1. **Standardize names first**: Use RefMet before searching studies to ensure consistent naming
2. **Use appropriate mass tolerances**: 5-10 ppm for high-resolution MS, 0.01-0.05 Da for unit resolution
3. **Check multiple adducts**: Test M+H, M+Na, M+K in positive mode; M-H, M+FA-H in negative mode
4. **Cross-reference**: Combine with HMDB and PubChem results for higher confidence annotations
5. **Note study conditions**: Filter by analytical platform and ion mode matching your experiment

## Resources

- **API Documentation**: https://www.metabolomicsworkbench.org/tools/MWRestAPIv1.0.pdf
- **Web Interface**: https://www.metabolomicsworkbench.org
- **RefMet**: https://www.metabolomicsworkbench.org/databases/refmet/
