# bicep

Validate deployment by template
```az deployment group validate -g PLAYGROUND -f ./main.bicep

Run deployment by template
```az deployment group create -g PLAYGROUND -f ./main.bicep

Cancel deployment by name
```az deployment group cancel -g PLAYGROUND -n main

Delete deployment by name
```az deployment group delete -g PLAYGROUND -n main
