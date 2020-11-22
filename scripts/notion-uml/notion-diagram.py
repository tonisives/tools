import json
import sys
import subprocess
from notion.client import NotionClient
from notion.block import ImageBlock
from notion.block import FileBlock
from notion.block import ToggleBlock

if (len(sys.argv) > 1):
    sequence_diagram_table_url = sys.argv[1]
    if (len(sys.argv) > 2):
        actor = sys.argv[2]
else: 
    print("please use table url as input arg")
    exit(2)

def puml_diagram(client):
    pum = "@startuml"
    if (len(sys.argv) > 2):
        pum += "\nactor {}\n".format(actor)

    cv = client.get_collection_view(sequence_diagram_table_url)
    pum += "title {}\n".format(cv.collection.name)

    for row in cv.collection.get_rows():
        if len(row.origin) == 0: 
            if row.note == "":
                continue
            else:
                pum += "{}\n".format(row.note)
        else:
            service_origin_block = row.origin[0]
            service_end_block = row.end[0]
            pum+=("\"{}\" -> \"{}\": {}\n".format(service_origin_block.name,
                                                service_end_block.name,
                                                row.label))
    pum+="@enduml"
    print(pum)
    return pum

def write_files(diagram, client):
    print(diagram, file=open('out.puml', 'w'))
    subprocess.Popen(["java", "-jar", "plantuml.jar", "-tsvg", "out.puml"])
    subprocess.Popen(["java", "-jar", "plantuml.jar", "-tpng", "out.puml"])

# TODO: Remove existing blocks rather than appending new ones
def upload_to_notion(client):
    sequence_diagrams_page_url = ""
    page = client.get_block(sequence_diagrams_page_url)
    svg_file = page.children.add_new(FileBlock)
    svg_file.upload_file("out.svg")

def client():
    token = ""
    with open('config.json', 'r') as f:
        token = json.load(f)['token']
    return NotionClient(token_v2=token)

client = client()
write_files(puml_diagram(client), client)
# upload_to_notion(client)