import json
import pathlib

# https://github.com/dbt-labs/dbt-docs/issues/53#issuecomment-1011053807

PATH_TO_FILE = str(pathlib.Path(__file__).parent.resolve())
path = PATH_TO_FILE + "/../dbt/"
OUTPUT_PATH = PATH_TO_FILE + "/../docs/hosting/"
OUTPUT_FILE_NAME = "dbt.html"

print(f"Read the files from {path}")


search_str = 'o=[i("manifest","manifest.json"+t),i("catalog","catalog.json"+t)]'


with open(path + "target/index.html", "r") as f:
    content_index = f.read()

with open(path + "target/manifest.json", "r") as f:
    json_manifest = json.loads(f.read())

with open(path + "target/catalog.json", "r") as f:
    json_catalog = json.loads(f.read())

with open(OUTPUT_PATH + OUTPUT_FILE_NAME, "w") as f:
    new_str = (
        "o=[{label: 'manifest', data: "
        + json.dumps(json_manifest)
        + "},{label: 'catalog', data: "
        + json.dumps(json_catalog)
        + "}]"
    )
    new_content = content_index.replace(search_str, new_str)
    f.write(new_content)

print(f"Generated data docuemnt at {OUTPUT_PATH + OUTPUT_FILE_NAME}")
