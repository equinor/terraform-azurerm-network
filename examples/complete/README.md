# Complete example

Creates an Azure Virtual Network with the following configuration:

- A subnet with the following configuration:
  - An attached NSG
  - An attached NAT gateway
  - An attached route table
  - Service endpoints for three Azure services: Key Vault, Storage and SQL
  - Delegation for the Azure Container Instances service
