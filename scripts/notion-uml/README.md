# Sequence diagram from Notion
Script to converte Notion table into a sequence diagram using PlantUML. 

## Setup
* Install `notion` module:  `pip install notion`.
* `python` should point to Python 3.
* Put your Notion cookie key in the `config.json` file. Get the key from your [browser cookies](https://github.com/cstrnt/notion-api/blob/master/README.md#Obtaining-Credentials).

## Run
Run the script with `python notion-diagram.py {notion table url} {OPTIONAL actor table row name}`
Example:
`python notion-diagram.py https://www.notion.so/952a65008448439b9f0d82c9755a525d\?v\=0de421bd4e2b485fb624ff4edc527e0d Alice`
