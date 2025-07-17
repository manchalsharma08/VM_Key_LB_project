az vm create `
  --resource-group mymeerg01 `
  --name MyLinuxVM `
  --location centralindia `
  --image Canonical:0001-com-ubuntu-server-jammy:22_04-lts:latest `
  --size Standard_B1ls `
  --admin-username azureuser `
  --admin-password 'Man@12345789' `
  --authentication-type password
