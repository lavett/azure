#log in to Azure sub
Add-AzureAccount

#switch to resource manager
Switch-AzureMode -Name AzureResourceManager

#List all publishers
$location="WestEurope"
Get-AzureVMImagePublisher -Location $location | Select PublisherName

#Select a publisher and list all offers from that one
$publisher="MicrosoftVisualStudio"
Get-AzureVMImageOffer -Location $location -Publisher $publisher | Select Offer

#List the SKU for that offer
$offer="Windows"
Get-AzureVMImageSku -Location $location -Publisher $publisher -Offer $offer | Select Skus

#List the versions of the SKU
$sku="10-Enterprise-N"
Get-AzureVMImage -Location $location -PublisherName $publisher -Offer $offer -Skus $sku
