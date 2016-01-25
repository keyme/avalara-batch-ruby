# Avalara Batch Service #

Source for Ruby gem Avatax_BatchService

Avalara BatchSvc SOAP API and Ruby Avatax_BatchService samples demonstrates execution of BatchSave, BatchFetch, Ping, and IsAuthorized.

Authentication for batch service requires admin level username and password.

BatchSave file needs to be in csv, xls, or xlsx format. For more information about importing and formatting data, Avalara templates and documentation can be found [here](https://help.avalara.com/000_AvaTax_Calc/000AvaTaxCalc_User_Guide/055_Add_or_Import_Transactions#Import_formats).

The SOAP call in this application uses a local copy of the Batch Service WSDL to keep the service static, per Avalara [documentation](documentation.avalara.com/api-docs/soap).
