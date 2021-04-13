# bicep

prerequisite
Login to azure and suppose there is a resource group named PLAYGROUND
```az login

Validate deployment by template
```az deployment group validate -g PLAYGROUND -f ./main.bicep

Run deployment by template
```az deployment group create -g PLAYGROUND -f ./main.bicep

Cancel deployment by name
```az deployment group cancel -g PLAYGROUND -n main

Delete deployment by name (in azure, deleting a deployment does not delete the corresponding resources)
```az deployment group delete -g PLAYGROUND -n main


az deployment group validate -g AutomationTest -f ./atmrsrc.bicep -p atmaccntname=sqlpooladmin
