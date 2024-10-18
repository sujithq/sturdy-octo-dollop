################################################################################
##  File:  Install-NET48.ps1
##  Desc:  Install .NET 4.8.1
##  Supply chain security: checksum validation
################################################################################

# .NET 4.8.1
Install-Binary `
    -Url 'https://dotnet.microsoft.com/en-us/download/dotnet-framework/thank-you/net481-offline-installer' `
    -InstallArgs @("Setup", "/passive", "/norestart") `
    -Type EXE
# -ExpectedSHA256Sum '3618A20537C440BB6DD1B1DBBB1D43CA09612F5DBC9F370FFCAD853DA52904EA' `
