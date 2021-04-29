# bicep

prerequisite
Login to azure and suppose there is a resource group named AutomationTest
```az login

Validate deployment by template
```az deployment group validate -g AutomationTest -f ./main.bicep

Dry-run deployment by template
```az deployment group what-if -g AutomationTest -f ./main.bicep

Run deployment by template
```az deployment group create -g AutomationTest -f ./main.bicep

Cancel deployment by name
```az deployment group cancel -g AutomationTest -n main

Delete deployment by name (in azure, deleting a deployment does not delete the corresponding resources)
```az deployment group delete -g AutomationTest -n main

