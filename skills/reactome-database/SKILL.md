---
name: reactome-database
description: Query Reactome REST API for pathway analysis, enrichment, gene-pathway mapping, disease pathways, molecular interactions, expression analysis, for systems biology studies.
license: Unknown
metadata:
    skill-author: K-Dense Inc.
---

# Reactome Database

## Overview

Reactome is a free, open-source, curated pathway database with 2,825+ human pathways. Query biological pathways, perform overrepresentation and expression analysis, map genes to pathways, explore molecular interactions via REST API and Python client for systems biology research.

## When to Use This Skill

- Performing pathway enrichment analysis on gene or protein lists
- Analyzing gene expression data to identify relevant biological pathways
- Querying specific pathway information, reactions, or molecular interactions
- Mapping genes or proteins to biological pathways and processes
- Exploring disease-related pathways and mechanisms
- Visualizing analysis results in the Reactome Pathway Browser
- Conducting comparative pathway analysis across species

## Core Capabilities

### 1. Content Service - Data Retrieval

Query and retrieve biological pathway data, molecular interactions, and entity information.

**API Base URL:** `https://reactome.org/ContentService`

```python
import requests

# Get database version
response = requests.get("https://reactome.org/ContentService/data/database/version")
version = response.text
print(f"Reactome version: {version}")

# Query a specific entity
entity_id = "R-HSA-69278"
response = requests.get(f"https://reactome.org/ContentService/data/query/{entity_id}")
data = response.json()

# Get participating molecules in a pathway
response = requests.get(
    f"https://reactome.org/ContentService/data/event/{entity_id}/participatingPhysicalEntities"
)
molecules = response.json()
```

### 2. Analysis Service - Pathway Analysis

**API Base URL:** `https://reactome.org/AnalysisService`

**Analysis types:**
- **Overrepresentation Analysis**: Identify statistically significant pathways from gene/protein lists
- **Expression Data Analysis**: Analyze gene expression datasets to find relevant pathways
- **Species Comparison**: Compare pathway data across different organisms

### 3. reactome2py Python Package

```bash
uv pip install reactome2py
```

Note: The reactome2py package (version 3.0.0) is functional but not actively maintained. For up-to-date functionality, use direct REST API calls.

## Performing Pathway Analysis

### Overrepresentation Analysis

```python
import requests

# Prepare identifier list
identifiers = ["TP53", "BRCA1", "EGFR", "MYC"]
data = "\n".join(identifiers)

# Submit analysis
response = requests.post(
    "https://reactome.org/AnalysisService/identifiers/",
    headers={"Content-Type": "text/plain"},
    data=data
)

result = response.json()
token = result["summary"]["token"]  # Save token to retrieve results later

# Access pathways
for pathway in result["pathways"]:
    print(f"{pathway['stId']}: {pathway['name']} (p-value: {pathway['entities']['pValue']})")
```

### Retrieve Analysis by Token

```python
# Token is valid for 7 days
response = requests.get(f"https://reactome.org/AnalysisService/token/{token}")
results = response.json()
```

### Expression Data Analysis

**Input format (TSV with header starting with #):**
```
#Gene	Sample1	Sample2	Sample3
TP53	2.5	3.1	2.8
BRCA1	1.2	1.5	1.3
EGFR	4.5	4.2	4.8
```

```python
with open("expression_data.tsv", "r") as f:
    data = f.read()

response = requests.post(
    "https://reactome.org/AnalysisService/identifiers/",
    headers={"Content-Type": "text/plain"},
    data=data
)
result = response.json()
```

### Species Projection

Map identifiers to human pathways using the `/projection/` endpoint:

```python
response = requests.post(
    "https://reactome.org/AnalysisService/identifiers/projection/",
    headers={"Content-Type": "text/plain"},
    data=data
)
```

## Visualizing Results

```python
token = result["summary"]["token"]
pathway_id = "R-HSA-69278"
url = f"https://reactome.org/PathwayBrowser/#{pathway_id}&DTAB=AN&ANALYSIS={token}"
print(f"View results: {url}")
```

## Supported Identifier Types

Reactome accepts various identifier formats (auto-detected):
- UniProt accessions (e.g., P04637)
- Gene symbols (e.g., TP53)
- Ensembl IDs (e.g., ENSG00000141510)
- EntrezGene IDs (e.g., 7157)
- ChEBI IDs for small molecules

## Output Format

All API responses return JSON containing:
- `pathways`: Array of enriched pathways with statistical metrics
- `summary`: Analysis metadata and token
- `entities`: Matched and unmapped identifiers
- Statistical values: pValue, FDR (false discovery rate)

## Current Database Statistics (Version 94, September 2025)

- 2,825 human pathways
- 16,002 reactions
- 11,630 proteins
- 2,176 small molecules
- 1,070 drugs
- 41,373 literature references

## Additional Resources

- **API Documentation**: https://reactome.org/dev
- **User Guide**: https://reactome.org/userguide
- **Data Downloads**: https://reactome.org/download-data
- **reactome2py Docs**: https://reactome.github.io/reactome2py/
