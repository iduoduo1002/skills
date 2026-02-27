---
name: rdkit
description: Cheminformatics toolkit for fine-grained molecular control. SMILES/SDF parsing, descriptors (MW, LogP, TPSA), fingerprints, substructure search, 2D/3D generation, similarity, reactions. For standard workflows with simpler interface, use datamol (wrapper around RDKit). Use rdkit for advanced control, custom sanitization, specialized algorithms.
license: BSD-3-Clause license
metadata:
    skill-author: K-Dense Inc.
---

# RDKit Cheminformatics Toolkit

## Overview

RDKit is a comprehensive cheminformatics library providing Python APIs for molecular analysis and manipulation. This skill provides guidance for reading/writing molecular structures, calculating descriptors, fingerprinting, substructure searching, chemical reactions, 2D/3D coordinate generation, and molecular visualization.

## Core Capabilities

### 1. Molecular I/O and Creation

```python
from rdkit import Chem

# From SMILES strings
mol = Chem.MolFromSmiles('Cc1ccccc1')

# From MOL files
mol = Chem.MolFromMolFile('path/to/file.mol')

# From InChI
mol = Chem.MolFromInchi('InChI=1S/C6H6/c1-2-4-6-5-3-1/h1-6H')

# To canonical SMILES
smiles = Chem.MolToSmiles(mol)

# To InChI
inchi = Chem.MolToInchi(mol)
```

**Batch Processing:**
```python
# Read SDF files
suppl = Chem.SDMolSupplier('molecules.sdf')
for mol in suppl:
    if mol is not None:
        pass  # Process molecule

# Write molecules to SDF
writer = Chem.SDWriter('output.sdf')
for mol in molecules:
    writer.write(mol)
writer.close()
```

### 2. Molecular Descriptors and Properties

```python
from rdkit.Chem import Descriptors

# Molecular weight
mw = Descriptors.MolWt(mol)
exact_mw = Descriptors.ExactMolWt(mol)

# LogP (lipophilicity)
logp = Descriptors.MolLogP(mol)

# Topological polar surface area
tpsa = Descriptors.TPSA(mol)

# Hydrogen bond donors/acceptors
hbd = Descriptors.NumHDonors(mol)
hba = Descriptors.NumHAcceptors(mol)

# Rotatable bonds
rot_bonds = Descriptors.NumRotatableBonds(mol)

# Calculate all descriptors at once
all_descriptors = Descriptors.CalcMolDescriptors(mol)
```

**Lipinski's Rule of Five:**
```python
def analyze_druglikeness(smiles):
    mol = Chem.MolFromSmiles(smiles)
    if mol is None:
        return None
    return {
        'MW': Descriptors.MolWt(mol),
        'LogP': Descriptors.MolLogP(mol),
        'HBD': Descriptors.NumHDonors(mol),
        'HBA': Descriptors.NumHAcceptors(mol),
        'TPSA': Descriptors.TPSA(mol),
        'Lipinski': (Descriptors.MolWt(mol) <= 500 and
                     Descriptors.MolLogP(mol) <= 5 and
                     Descriptors.NumHDonors(mol) <= 5 and
                     Descriptors.NumHAcceptors(mol) <= 10)
    }
```

### 3. Fingerprints and Molecular Similarity

```python
from rdkit.Chem import rdFingerprintGenerator
from rdkit import DataStructs

# Morgan fingerprints (circular, similar to ECFP)
morgan_gen = rdFingerprintGenerator.GetMorganGenerator(radius=2, fpSize=2048)
fp = morgan_gen.GetFingerprint(mol)

# RDKit topological fingerprint
rdk_gen = rdFingerprintGenerator.GetRDKitFPGenerator(minPath=1, maxPath=7, fpSize=2048)
fp = rdk_gen.GetFingerprint(mol)

# MACCS keys (166-bit structural key)
from rdkit.Chem import MACCSkeys
fp = MACCSkeys.GenMACCSKeys(mol)

# Calculate Tanimoto similarity
fp1 = morgan_gen.GetFingerprint(mol1)
fp2 = morgan_gen.GetFingerprint(mol2)
similarity = DataStructs.TanimotoSimilarity(fp1, fp2)

# Bulk similarity
fps = [morgan_gen.GetFingerprint(m) for m in [mol2, mol3, mol4]]
similarities = DataStructs.BulkTanimotoSimilarity(fp1, fps)
```

### 4. Substructure Searching and SMARTS

```python
# Define query using SMARTS
query = Chem.MolFromSmarts('[#6]1:[#6]:[#6]:[#6]:[#6]:[#6]:1')  # Benzene ring

# Check if molecule contains substructure
has_match = mol.HasSubstructMatch(query)

# Get all matches (atom indices)
matches = mol.GetSubstructMatches(query)
```

**Common SMARTS Patterns:**
```python
primary_alcohol = Chem.MolFromSmarts('[CH2][OH1]')
carboxylic_acid = Chem.MolFromSmarts('C(=O)[OH]')
amide = Chem.MolFromSmarts('C(=O)N')
aromatic_n = Chem.MolFromSmarts('[nR]')
```

### 5. 2D and 3D Coordinate Generation

```python
from rdkit.Chem import AllChem

# Generate 2D coordinates for depiction
AllChem.Compute2DCoords(mol)

# Generate 3D conformer
AllChem.EmbedMolecule(mol, randomSeed=42)
AllChem.MMFFOptimizeMolecule(mol)

# Generate multiple conformers
conf_ids = AllChem.EmbedMultipleConfs(mol, numConfs=10, randomSeed=42)
```

### 6. Molecular Visualization

```python
from rdkit.Chem import Draw

# Draw single molecule
img = Draw.MolToImage(mol, size=(300, 300))
img.save('molecule.png')

# Draw multiple molecules in grid
img = Draw.MolsToGridImage([mol1, mol2, mol3], molsPerRow=2, subImgSize=(200, 200))

# Highlight substructure match
query = Chem.MolFromSmarts('c1ccccc1')
match = mol.GetSubstructMatch(query)
img = Draw.MolToImage(mol, highlightAtoms=match)
```

### 7. Molecular Analysis

```python
# Ring information
ring_info = mol.GetRingInfo()
ring_info.NumRings()
ring_info.AtomRings()

# Stereochemistry
from rdkit.Chem import FindMolChiralCenters
chiral_centers = FindMolChiralCenters(mol, includeUnassigned=True)

# Fragment analysis
frags = Chem.GetMolFrags(mol, asMols=True)

# Murcko scaffold
from rdkit.Chem.Scaffolds import MurckoScaffold
scaffold = MurckoScaffold.GetScaffoldForMol(mol)
```

## Common Workflows

### Similarity Screening

```python
def similarity_screen(query_smiles, database_smiles, threshold=0.7):
    query_mol = Chem.MolFromSmiles(query_smiles)
    mfpgen = rdFingerprintGenerator.GetMorganGenerator(radius=2, fpSize=2048)
    query_fp = mfpgen.GetFingerprint(query_mol)

    hits = []
    for idx, smiles in enumerate(database_smiles):
        mol = Chem.MolFromSmiles(smiles)
        if mol:
            fp = mfpgen.GetFingerprint(mol)
            sim = DataStructs.TanimotoSimilarity(query_fp, fp)
            if sim >= threshold:
                hits.append((idx, smiles, sim))

    return sorted(hits, key=lambda x: x[2], reverse=True)
```

### Substructure Filtering

```python
def filter_by_substructure(smiles_list, pattern_smarts):
    query = Chem.MolFromSmarts(pattern_smarts)
    return [smiles for smiles in smiles_list
            if (mol := Chem.MolFromSmiles(smiles)) and mol.HasSubstructMatch(query)]
```

## Installation

```bash
uv pip install rdkit
```

## Best Practices

1. **Always check for None**: `MolFrom*` functions return `None` on failure
2. **Use bulk operations**: `BulkTanimotoSimilarity` for batch similarity
3. **Memory management**: Use `ForwardSDMolSupplier` for large SDF files
4. **Validate before processing**: Use `DetectChemistryProblems()` to debug sanitization issues

## Resources

- `references/api_reference.md` - Comprehensive RDKit modules and functions
- `references/descriptors_reference.md` - Complete list of molecular descriptors
- `references/smarts_patterns.md` - Common SMARTS patterns for functional groups
