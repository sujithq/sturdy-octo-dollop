application="shir"
skip_create_image=true
cg_image_version="1.0.0"
vm_name="zwesepacktmpn01"
install_user="zwesepacktmpn01-adm"
cg_image_name="win22-appimg-shir"
mi_name="win22-appimg-shir"
image_sku="2022-Datacenter"
image_offer="WindowsServer"
image_publisher="MicrosoftWindowsServer"

vm_size= "Standard_F8s_v2"
mi_rg_name="rg-suqu-packer"
mi_build_rg_name="rg-suqu-packer-build"
virtual_network_name="vnet-suqu-packer"
virtual_network_subnet_name="default"
virtual_network_resource_group_name ="rg-suqu-packer"
cg_gallery_name="cgnsuqupacker"
cg_rg_name="rg-suqu-packer"
os_disk_size_gb=127
user_assigned_managed_identities=["/subscriptions/3340dada-95cb-400f-960d-12f6c38f8503/resourcegroups/rg-suqu-packer/providers/Microsoft.ManagedIdentity/userAssignedIdentities/id-suqu-packer"]
storage_account_name="stsuqupacker"
install_password="SuperSecretPassword*1"

key_vault_name="kvsuqupacker"
adf_key="IR@24844d4b-b7cf-41f3-b434-2870d47c1ddf@ese-cube-euwe-adf-n@ServiceEndpoint=ese-cube-euwe-adf-n.westeurope.datafactory.azure.net@5sxJWayUVXsaLves8ukyiOafKNZbEvIHQLF6YXSMRxs="
