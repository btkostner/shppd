# FedEx

FedEx tracking can be enabled by setting up a FedEx developer account, project, and API key.

Instructions for setting up a FedEx developer account and project can be found [here](https://developer.fedex.com/api/en-us/home.html).

Once you have your FedEx developer account and project set up, you can enable FedEx tracking by adding the following environment variables to your deployment:

| Environment Variable | Description | Default |
| --- | --- | --- |
| `FEDEX_PRODUCTION_ENVIRONMENT` | `true` if the `api_key` and `api_secret` are for the FedEx production environment. | `false` |
| `FEDEX_API_KEY` | Your FedEx API key. | |
| `FEDEX_API_SECRET` | Your FedEx API secret. | |
