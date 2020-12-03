# An example on how to run the file

docker build -t phac-epitweetr . 
docker run --rm -p 443:3838 phac-epitweetr

# Tutorial on how to deploy it to Azure Container Registry ACR
# https://docs.microsoft.com/en-us/azure/container-registry/container-registry-get-started-portal

# Need to move it to the Azure Web Apps 
# Before doing that, need to enable admin in ACR
# It's all GUI-based from here!