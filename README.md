# Varonis Home Assignment

## Table of Contents

- [Project Structure](#project-structure)
- [Basic Architecture](#basic-architecture)
- [Technical Details](#technical-details)

##  Project Structure
```sh
└── Varonis-Assignment/
    ├── .github
    │   └── workflows
    │       └── docker-publish.yml
    ├── README.md
    ├── api-code
    │   ├── Dockerfile
    │   ├── main.py
    │   └── requirements.txt
    ├── db-setup-code
    │   └── in.sql
    └── terraform
        ├── .gitignore
        ├── main.tf
        ├── modules
        │   ├── app_gw
        │   ├── azure_sql
        │   ├── container_app
        │   ├── docker_registry
        │   ├── key_vault
        │   ├── network
        │   ├── private_dns
        │   ├── resource_group
        │   ├── service_account
        │   └── storage_account_storage
        ├── outputs.tf
        └── provider.tf
```

## Basic Architecture
Basic diagram that shows the general flow of what resources I created and how they communicate with each other.

![Alt text](./varonis_arc.png)

## Technical Details
1. Implemented the solution using Azure cloud and the services it offers.
2. I used my own laptop to run `terraform plan/apply` (and my own credentials).
3. Created a CI using GitHub Actions for creating docker image.
4. Since I wanted to save $$$ for myself, didn't always used "production" component, such as multi replicas for the SQL server, etc.
5. Wrote the Application using Python, my work assumption was that the request is already stucred, so no need to do extra manipulation on it (e.g. "show me what restaurants are open *tomorrow at 9:30*", "show me restarurants does serve Japanise food but *doesn't* have delivery").
6. Used Azure SQL service to storage the data. Chose a rational DB since the data is stucred & clear, Otherwise would use a diffenet DB, such as MongoDB.
