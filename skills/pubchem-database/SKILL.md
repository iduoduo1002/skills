---
name: pubchem-database
description: Access PubChem (110M+ compounds, 270M+ bioactivities). Search by name/CID/SMILES/InChI/formula, retrieve molecular properties, similarity search, substructure screening, bioactivity data. For compound identification from MS data and chemical structure annotation.
license: Public domain (US government database)
metadata:
    skill-author: K-Dense Inc.
---

# PubChem Database

## Overview

PubChem is the world's largest freely available chemical database with 110M+ compounds and 270M+ bioactivities. Search and retrieve chemical compound information, molecular properties, structural data, and bioactivity results.

## When to Use This Skill

- Identifying compounds from mass spectrometry data using molecular formula or exact mass
- Searching for chemical structures by name, SMILES, InChI, or CID
- Retrieving molecular properties (MW, LogP, TPSA, etc.) for annotation
- Performing similarity searches to find structurally related compounds
- Accessing bioactivity screening data for compounds of interest
- Converting between chemical identifier formats

## Installation

```bash
uv pip install pubchempy requests pandas
```

## Core Capabilities

### 1. Chemical Structure Searching

```python
import pubchempy as pcp

# Search by name
compounds = pcp.get_compounds('glucose', 'name')

# Search by CID (PubChem Compound ID)
compound = pcp.get_compounds(5793, 'cid')

# Search by SMILES
compounds = pcp.get_compounds('C([C@@H]1[C@H]([C@@H]([C@H](C(O1)O)O)O)O)O', 'smiles')

# Search by InChI Key
compounds = pcp.get_compounds('WQZGKKKJIJFFOK-GASJEMHNSA-N', 'inchikey')

# Search by molecular formula
compounds = pcp.get_compounds('C6H12O6', 'formula')
```

### 2. Molecular Property Retrieval

```python
import pubchempy as pcp

compound = pcp.get_compounds('aspirin', 'name')[0]

# Basic properties
print(compound.cid)                    # PubChem CID
print(compound.molecular_weight)       # Molecular weight
print(compound.molecular_formula)      # Molecular formula
print(compound.isomeric_smiles)        # Isomeric SMILES
print(compound.inchikey)               # InChI Key
print(compound.iupac_name)             # IUPAC name

# Physical/chemical properties
print(compound.xlogp)                  # LogP
print(compound.tpsa)                   # Topological polar surface area
print(compound.h_bond_donor_count)     # H-bond donors
print(compound.h_bond_acceptor_count)  # H-bond acceptors
print(compound.rotatable_bond_count)   # Rotatable bonds
print(compound.exact_mass)             # Exact mass (monoisotopic)
```

### 3. Batch Property Retrieval via REST API

```python
import requests
import pandas as pd

def get_compound_properties(cids, properties):
    """Retrieve properties for multiple CIDs."""
    cid_str = ','.join(map(str, cids))
    props_str = ','.join(properties)
    url = f"https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/{cid_str}/property/{props_str}/JSON"
    response = requests.get(url)
    data = response.json()
    return pd.DataFrame(data['PropertyTable']['Properties'])

# Example: Get MW and formula for multiple CIDs
properties = ['MolecularFormula', 'MolecularWeight', 'ExactMass', 'IsomericSMILES', 'InChIKey']
df = get_compound_properties([5793, 2244, 1983], properties)
print(df)
```

### 4. Similarity Search

```python
import requests

def similarity_search(smiles, threshold=90, max_records=100):
    """Find similar compounds by Tanimoto similarity."""
    url = f"https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/fastsimilarity_2d/smiles/{smiles}/cids/JSON"
    params = {'Threshold': threshold, 'MaxRecords': max_records}
    response = requests.get(url, params=params)
    return response.json()['IdentifierList']['CID']

# Example
similar_cids = similarity_search('C1=CC=CC=C1')  # Benzene analogs
```

### 5. Substructure Search

```python
import requests

def substructure_search(smarts, max_records=100):
    """Find compounds containing a substructure."""
    url = f"https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/fastsubstructure/smarts/{smarts}/cids/JSON"
    params = {'MaxRecords': max_records}
    response = requests.get(url, params=params)
    return response.json()['IdentifierList']['CID']
```

### 6. Search by Exact Mass (for MS Compound Identification)

```python
import requests

def search_by_exact_mass(mass, tolerance=0.005):
    """Search compounds by exact monoisotopic mass - useful for MS identification."""
    mass_min = mass - tolerance
    mass_max = mass + tolerance
    url = f"https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/fastformula/exactmass/{mass_min}/{mass_max}/cids/JSON"
    response = requests.get(url)
    if response.status_code == 200:
        return response.json().get('IdentifierList', {}).get('CID', [])
    return []

# Example: Find compounds with exact mass ~180.063 (glucose)
cids = search_by_exact_mass(180.063)
```

### 7. Download Structure Files

```python
import requests

def download_sdf(cid, filename):
    """Download SDF structure file for a compound."""
    url = f"https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/{cid}/SDF"
    response = requests.get(url)
    with open(filename, 'w') as f:
        f.write(response.text)

# Download as PNG image
def download_image(cid, filename, size=300):
    url = f"https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/{cid}/PNG?image_size={size}x{size}"
    response = requests.get(url)
    with open(filename, 'wb') as f:
        f.write(response.content)
```

### 8. Bioactivity Data

```python
import pubchempy as pcp

# Get bioassay data for a compound
assays = pcp.get_assays(cid=2244, listkey_count=10)  # aspirin

# Get bioactivity via REST API
import requests
cid = 2244
url = f"https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/{cid}/assaysummary/JSON"
response = requests.get(url)
bioactivity = response.json()
```

## Common MS Identification Workflow

```python
import pubchempy as pcp
import requests

def identify_from_ms(exact_mass, formula=None, tolerance=0.005):
    """Identify compound candidates from MS exact mass."""
    candidates = []

    if formula:
        # Search by molecular formula
        compounds = pcp.get_compounds(formula, 'formula')
        for c in compounds:
            if abs(float(c.exact_mass) - exact_mass) <= tolerance:
                candidates.append({
                    'cid': c.cid,
                    'name': c.iupac_name,
                    'formula': c.molecular_formula,
                    'exact_mass': c.exact_mass,
                    'smiles': c.isomeric_smiles
                })
    else:
        # Search by mass range
        cids = search_by_exact_mass(exact_mass, tolerance)
        for cid in cids[:20]:  # Limit results
            compound = pcp.get_compounds(cid, 'cid')[0]
            candidates.append({
                'cid': cid,
                'formula': compound.molecular_formula,
                'exact_mass': compound.exact_mass,
                'smiles': compound.isomeric_smiles
            })

    return candidates
```

## Rate Limits

- Maximum 5 requests per second
- Maximum 400 requests per minute
- Use batch requests for multiple CIDs to reduce API calls
- Implement delays for large-scale queries

## Best Practices

1. **Use CID identifiers** for efficiency - they are the most reliable identifier
2. **Implement request delays** for batch operations to respect rate limits
3. **Use exact mass search** for MS compound identification
4. **Cross-reference** with HMDB and MetaCyc for metabolite-specific annotation
5. **Cache results** locally to avoid redundant API calls
