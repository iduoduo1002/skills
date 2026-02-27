---
name: uniprot-database
description: Direct REST API access to UniProt. Protein searches, FASTA retrieval, ID mapping, Swiss-Prot/TrEMBL. For Python workflows with multiple databases, prefer bioservices (unified interface to 40+ services). Use this for direct HTTP/REST work or UniProt-specific control.
license: Unknown
metadata:
    skill-author: K-Dense Inc.
---

# UniProt Database

## Overview

UniProt is the world's leading comprehensive protein sequence and functional information resource. Search proteins by name, gene, or accession, retrieve sequences in FASTA format, perform ID mapping across databases, access Swiss-Prot/TrEMBL annotations via REST API for protein analysis.

## When to Use This Skill

- Searching for protein entries by name, gene symbol, accession, or organism
- Retrieving protein sequences in FASTA or other formats
- Mapping identifiers between UniProt and external databases (Ensembl, RefSeq, PDB, etc.)
- Accessing protein annotations including GO terms, domains, and functional descriptions
- Batch retrieving multiple protein entries efficiently
- Querying reviewed (Swiss-Prot) vs. unreviewed (TrEMBL) protein data
- Streaming large protein datasets
- Building custom queries with field-specific search syntax

## Core Capabilities

### 1. Searching for Proteins

```python
# Search by protein name
query = "insulin AND organism_name:\"Homo sapiens\""

# Search by gene name
query = "gene:BRCA1 AND reviewed:true"

# Search by accession
query = "accession:P12345"

# Search by taxonomy
query = "taxonomy_id:9606"  # Human proteins

# Search by GO term
query = "go:0005515"  # Protein binding
```

Use the API search endpoint: `https://rest.uniprot.org/uniprotkb/search?query={query}&format={format}`

**Supported formats:** JSON, TSV, Excel, XML, FASTA, RDF, TXT

### 2. Retrieving Individual Protein Entries

**Retrieve endpoint:** `https://rest.uniprot.org/uniprotkb/{accession}.{format}`

Example: `https://rest.uniprot.org/uniprotkb/P12345.fasta`

### 3. Batch Retrieval and ID Mapping

**ID Mapping workflow:**
1. Submit mapping job to: `https://rest.uniprot.org/idmapping/run`
2. Check job status: `https://rest.uniprot.org/idmapping/status/{jobId}`
3. Retrieve results: `https://rest.uniprot.org/idmapping/results/{jobId}`

**Supported databases for mapping:**
- UniProtKB AC/ID
- Gene names
- Ensembl, RefSeq, EMBL
- PDB, AlphaFoldDB
- KEGG, GO terms

**Limitations:**
- Maximum 100,000 IDs per job
- Results stored for 7 days

### 4. Streaming Large Result Sets

For large queries, use the stream endpoint:

`https://rest.uniprot.org/uniprotkb/stream?query={query}&format={format}`

### 5. Customizing Retrieved Fields

**Common fields:**
- `accession` - UniProt accession number
- `id` - Entry name
- `gene_names` - Gene name(s)
- `organism_name` - Organism
- `protein_name` - Protein names
- `sequence` - Amino acid sequence
- `length` - Sequence length
- `go_*` - Gene Ontology annotations

**Example:** `https://rest.uniprot.org/uniprotkb/search?query=insulin&fields=accession,gene_names,organism_name,length,sequence&format=tsv`

## Query Syntax Examples

**Boolean operators:**
```
kinase AND organism_name:human
(diabetes OR insulin) AND reviewed:true
cancer NOT lung
```

**Field-specific searches:**
```
gene:BRCA1
accession:P12345
organism_id:9606
```

**Range queries:**
```
length:[100 TO 500]
mass:[50000 TO 100000]
```

## Best Practices

1. **Use reviewed entries when possible**: Filter with `reviewed:true` for Swiss-Prot (manually curated) entries
2. **Specify format explicitly**: Choose appropriate format (FASTA for sequences, TSV for tabular data)
3. **Use field selection**: Only request fields you need to reduce bandwidth
4. **Handle pagination**: For large result sets, use the stream endpoint
5. **Cache results**: Store frequently accessed data locally to minimize API calls

## Resources

- **API Documentation**: https://www.uniprot.org/help/api
- **Interactive API Explorer**: https://www.uniprot.org/api-documentation
- **REST Tutorial**: https://www.uniprot.org/help/uniprot_rest_tutorial
- **Query Syntax Help**: https://www.uniprot.org/help/query-fields
